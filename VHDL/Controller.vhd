library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;

entity Controller is
 generic (opBase : unsigned;
          opBits : positive;
          addrBits : positive := 8
          );
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in boolean;
  op : in unsigned(opBits-1 downto 0);
  copy : in boolean;
  load : in boolean;
  ena : in boolean;

  dinOut : out std_logic := '0';
  dshiftOut : out boolean := false;
  opOut : out unsigned(opBits-1 downto 0) := (others => '0');
  loadOut : out boolean := false
  );
end Controller;

architecture behavioral of  Controller is

 component ShiftOpSel is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive);
  port(
   clk : in std_logic;
   din : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   shift : in boolean;
   sel : out boolean;
   data : inout unsigned (n-1 downto 0)
   );
 end Component;

 component CMem IS
  port
   (
    clock : in std_logic := '1';
    data  : in std_logic_vector (7 downto 0);
    rdaddress : in std_logic_vector (7 downto 0);
    wraddress : in std_logic_vector (7 downto 0);
    wren : in std_logic := '0';
    q : out std_logic_vector (7 downto 0)
    );
 end component;

 constant byteBits : positive := 8;

 type ctlFsm is (ctlIdle, ctlShift, ctlWrite, ctlUpdAdr);
 signal ctlState : ctlFsm := ctlIdle;

 type runFsm is (rIdle, rDly, rCmdLen, rCmd, rData, rShift, rDone);
 signal runState : runFsm := rIdle;

 signal dataReg : unsigned (byteBits-1 downto 0);

 signal rdAddress : unsigned (addrBits-1 downto 0) := (others => '0');
 signal wrAddress : unsigned (addrBits-1 downto 0) := (others => '0');
 signal dataCount : integer range 0 to (2 ** addrBits) - 1 := 0;
 signal empty : boolean := true;

 signal writeEna : std_logic := '0';
 signal opSel : boolean;

 signal outData : std_logic_vector (byteBits-1 downto 0);

 signal data : unsigned (byteBits-1 downto 0) := (others => '0');

 signal count : integer range 0 to 7;

 signal rdOp : unsigned (opBits-1 downto 0) := (others => '0'); 
 signal len : unsigned (byteBits-1 downto 0) := (others => '0'); 
 signal cmd : unsigned (byteBits-1 downto 0) := (others => '0');

 constant readDelay : integer := 1;

 signal dlyNxt : runFsm := rIdle;
 signal delay : integer range 0 to readDelay := 0;

begin

 shiftProc : ShiftOpSel
  generic map(opVal => opBase + F_Ld_Ctrl_Data,
              opBits => opBits,
              n => byteBits)
  port map(
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   sel => opSel,
   data => dataReg
   );

 memProc : CMem
  port map
  (
   clock => clk,
   data => std_logic_vector(dataReg),
   rdaddress => std_logic_vector(rdAddress),
   wraddress => std_logic_vector(wrAddress),
   wren => writeEna,
   q => outData
   );

 empty <= true when (dataCount = 0) else false;
 dinOut <= data(byteBits-1);

 Proc : process(clk)
 begin
  if (rising_edge(clk)) then
   case ctlState is
    when ctlIdle =>
     if (opSel and copy) then
      ctlState <= ctlShift;
      count <= 7;
     end if;

    when ctlShift =>
     if ((not opSel) or load) then
      ctlState <= ctlIdle;
     elsif (dshift) then
      if (count /= 0) then
       count <= count - 1;
      else
       writeEna <= '1';
       count <= 7;
       ctlState <= ctlWrite;
      end if;
     end if;

    when CtlWrite =>
     writeEna <= '0';
     ctlState <= ctlUpdAdr;

     when ctlUpdAdr =>
     wrAddress <= wrAddress + 1;
     dataCount <= dataCount + 1;
     ctlState <= ctlShift;

    when others => null;
   end case;

   if (ena) then
    case runState is
     when rIdle =>
      loadOut <= false;
      if (not empty) then
       rdOp <= unsigned(outData);
       rdAddress <= rdAddress + 1;
       dataCount <= dataCount - 1;
       dlyNxt <= rCmdLen;
       delay <= readDelay;
       runState <= rDly;
      end if;

     when rDly =>
      if (delay = 0) then
       runState <= dlyNxt;
      else
       delay <= delay - 1;
      end if;

     when rCmdLen =>
      if (not empty) then
       if (rdOp = opBase + F_Ctrl_Cmd) then
        cmd <= unsigned(outData);
        dlyNxt <= rCmd;
       else
        opOut <= rdOp;
        len <= unsigned(outData);
        dlyNxt <= rData;
       end if;
       rdAddress <= rdAddress + 1;
       dataCount <= dataCount - 1;
       delay <= readDelay;
       runState <= rDly;
      else
      end if;
      
     when rCmd =>
      runState <= rIdle;

     when rData =>
      if (len /= 0) then
       if (not empty) then
        data <= unsigned(outData);
        count <= 7;
        dshiftOut <= true;
        rdAddress <= rdAddress + 1;
        dataCount <= dataCount - 1;
        runState <= rShift;
       else
        null;
       end if;
      else
       loadOut <= true;
       runState <= rDone;
      end if;

     when rShift =>
      if (count /= 0) then
       count <= count - 1;
       data <= shift_left(data, 1);
      else
       dshiftOut <= false;
       len <= len - 1;
       runState <= rData;
      end if;

     when rDone =>
      loadOut <= false;
      opOut <= (others => '0');
      runState <= rIdle;

    when others => null;
    end case;
   else
    len <= (others => '0');
    data <= (others => '0');
    rdOp <= (others => '0');
    cmd <= (others => '0');
    opOut <= (others => '0');
   end if;
  end if;
 end process Proc;

end behavioral;
