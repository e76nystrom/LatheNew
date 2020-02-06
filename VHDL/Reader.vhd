library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;

entity Reader is
 generic(opBase : unsigned;
         opBits : positive;
         rdAddrBits : positive;
         outBits : positive
         );
 port (
  clk : in std_logic;
  init : in std_logic;
  din : in std_logic;
  dshift : in boolean;
  op : in unsigned(opBits-1 downto 0);
  copy : in boolean;
  load : in boolean;
  copyOut : out boolean := false;
  opOut : out unsigned(opBits-1 downto 0) := (others => '0');
  active : out boolean := false
  );
end Reader;

architecture behavioral of  Reader is

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

 component RdMem IS
  port
   (
    clock : in std_logic;
    data  : in std_logic_vector (7 downto 0);
    rdaddress : in std_logic_vector (4 downto 0);
    wraddress : in std_logic_vector (4 downto 0);
    wren : in std_logic;
    q : out std_logic_vector (7 downto 0)
    );
 end component;

 constant byteBits : positive := 8;

 type ctlFsm is (cIdle, cShift, cWrite, cUpdAdr);
 signal ctlState : ctlFsm := cIdle;

 type runFsm is (rIdle, raddr, rCopy, rData, rShift, rDone);
 signal runState : runFsm := rIdle;

 signal dataReg : unsigned (byteBits-1 downto 0);

 signal rdAddress : unsigned (rdAddrBits-1 downto 0) := (others => '0');
 signal wrAddress : unsigned (rdAddrBits-1 downto 0) := (others => '0');

 signal writeEna : std_logic := '0';
 signal opSel : boolean;

 signal readSel : boolean := false;

 signal outData : std_logic_vector (byteBits-1 downto 0);

 signal data : unsigned (byteBits-1 downto 0) := (others => '0');

 signal count : integer range 0 to outBits := 0;

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

 memProc : rdMem
  port map
  (
   clock => clk,
   data => std_logic_vector(dataReg),
   rdaddress => std_logic_vector(rdAddress),
   wraddress => std_logic_vector(wrAddress),
   wren => writeEna,
   q => outData
   );

 Proc : process(clk)
 begin
  if (rising_edge(clk)) then
   if (init = '1') then
    ctlState <= cIdle;
    runState <= rIdle;
    writeEna <= '0';
   else
    if (opSel) then
     case ctlState is
      when cIdle =>                      --idle
       if (opSel and copy) then
        wrAddress <= (others => '0');
        count <= 7;
        ctlState <= cShift;
       end if;

      when cShift =>                     --shift data in
       if ((not opSel) or load) then
        ctlState <= cIdle;
       elsif (dshift) then
        if (count /= 0) then
         count <= count - 1;
        else
         writeEna <= '1';
         count <= 7;
         ctlState <= cWrite;
        end if;
       end if;

      when CWrite =>                    --write to memory
       writeEna <= '0';
       ctlState <= cUpdAdr;

      when cUpdAdr =>                   --update address
       wrAddress <= wrAddress + 1;
       ctlState <= cShift;

      when others => null;
     end case;
    end if;

    if (op = opBase + F_Read) then
     readSel <= true;
    else
     readSel <= false;
    end if;

    case runState is
     when rIdle =>                      --idle
      if (readSel) then
       active <= true;
       rdAddress <= (others => '0');
       runState <= raddr;
      end if;

     when rAddr =>
      opOut <= unsigned(outData);
      count <= outBits-1;
      runState <= rCopy;

     when rCopy =>
      copyOUt <= true;
      runState <= rData;
      
     when rData =>
      copyOut <= false;
      rdAddress <= rdAddress + 1;
      runState <= rShift;

     when rShift =>
      if (dshift) then
       if (count /= 0) then
        count <= count - 1;
       else
        if (rdAddress < wrAddress) then
         runState <= rAddr;
        else
         opOut <= (others => '0');
         runState <= rDone;
        end if;
       end if;
      end if;

     when rDone =>
      active <= false;
      if (not readSel) then
       runState <= rIdle;
      end if;

     when others => null;
    end case;
    
   end if;
  end if;
 end process Proc;

end behavioral;
