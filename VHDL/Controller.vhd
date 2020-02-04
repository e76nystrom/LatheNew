library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.conversion.all;

entity Controller is
 generic (opBase : unsigned;
          opBits : positive;
          addrBits : positive := 8;
          statusBits : positive;
          seqBits : positive;
          outBits : positive
          );
 port (
  clk : in std_logic;
  init : in boolean;
  din : in std_logic;
  dshift : in boolean;
  op : in unsigned(opBits-1 downto 0);
  copy : in boolean;
  load : in boolean;
  ena : in boolean;
  statusReg : in unsigned(statusBits-1 downto 0);
  
  dout : out std_logic := '0';
  dinOut : out std_logic := '0';
  dshiftOut : out boolean := false;
  opOut : out unsigned(opBits-1 downto 0) := (others => '0');
  loadOut : out boolean := false;
  empty : out boolean := true
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
    clock : in std_logic;
    data  : in std_logic_vector (7 downto 0);
    rdaddress : in std_logic_vector (7 downto 0);
    wraddress : in std_logic_vector (7 downto 0);
    wren : in std_logic;
    q : out std_logic_vector (7 downto 0)
    );
 end component;

 component ShiftOutN is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive;
          outBits : positive);
  port (
   clk : in std_logic;
   dshift : in boolean;
   op : in unsigned (opBits-1 downto 0);
   copy : in boolean;
   data : in unsigned(n-1 downto 0);
   dout : out std_logic
   );
 end Component;

 constant byteBits : positive := 8;

 type ctlFsm is (cIdle, cShift, cWrite, cUpdAdr);
 signal ctlState : ctlFsm := cIdle;

 type runFsm is (rIdle, rDly, rCmdLen, lSeq, rCmd, rData, rShift, rDone);
 signal runState : runFsm := rIdle;

 type cmdRec is record
  cmdWaitZ : boolean;
  cmdWaitX : boolean;
 end record cmdRec;

 function to_cmdRec(signal val : std_logic_vector)
  return cmdRec is
  variable result : cmdRec;
 begin
  result.cmdWaitZ := to_boolean(val(0));
  result.cmdWaitX := to_boolean(val(1));
  return result;
 end to_cmdRec;

 signal dataReg : unsigned (byteBits-1 downto 0);

 signal rdAddress : unsigned (addrBits-1 downto 0) := (others => '0');
 signal wrAddress : unsigned (addrBits-1 downto 0) := (others => '0');
 signal dataCount : integer range 0 to (2 ** addrBits) - 1 := 0;
 signal emptyFlag : boolean := true;

 signal tmp : unsigned (addrBits-1 downto 0);

 signal seqReg : unsigned (seqBits-1 downto 0) := (others => '0');
 signal seqDout : std_logic;
 signal countDout : std_logic;

 signal writeEna : boolean := false;
 signal opSel : boolean;

 signal outData : std_logic_vector (byteBits-1 downto 0);

 signal data : unsigned (byteBits-1 downto 0) := (others => '0');

 signal count : integer range 0 to 7;

 signal rdOp : unsigned (opBits-1 downto 0) := (others => '0'); 
 signal len : unsigned (byteBits-1 downto 0) := (others => '0'); 
 -- signal cmd : unsigned (byteBits-1 downto 0) := (others => '0');
 signal cmd : cmdRec := (others => false);
 -- signal cmd : cmdRec := (cmdWaitZ => false, cmdWaitX => false);

 constant readDelay : integer := 1;

 signal dlyNxt : runFsm := rIdle;
 signal delay : integer range 0 to readDelay := 0;

 alias zAxisEna   : std_logic is statusreg(0); -- x01 z axis enable flag
 alias zAxisDone  : std_logic is statusreg(1); -- x02 z axis done
 alias xAxisEna   : std_logic is statusreg(2); -- x04 x axis enable flag
 alias xAxisDone  : std_logic is statusreg(3); -- x08 x axis done
 alias queEmpty   : std_logic is statusreg(4); -- x10 controller queue empty

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
   wren => to_std_logic(writeEna),
   q => outData
   );

 dout <= seqDout or countDout;

 rdSeq : ShiftOutN
  generic map(opVal => opBase + F_Rd_Seq,
              opBits => opBits,
              n => seqBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   copy => copy,
   data => seqReg,
   dout => seqDout
   );

 tmp <= to_unsigned(dataCount, addrBits);

 rdCount : ShiftOutN
  generic map(opVal => opBase + F_Rd_Seq,
              opBits => opBits,
              n => addrBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   copy => copy,
   data => tmp,
   dout => countDout
   );

 emptyFlag <= true when (dataCount = 0) else false;

 dinOut <= data(byteBits-1);
 empty <= emptyFlag;

 Proc : process(clk)
 begin
  if (rising_edge(clk)) then
   if (init) then
    ctlState <= cIdle;
    runState <= rIdle;
    writeEna <= False;
    rdAddress <= (others => '0');
    wrAddress <= (others => '0');
    dataCount <= 0;
   else
    case ctlState is
     when cIdle =>
      if (opSel and copy) then
       ctlState <= cShift;
       count <= 7;
      end if;

     when cShift =>
      if ((not opSel) or load) then
       ctlState <= cIdle;
      elsif (dshift) then
       if (count /= 0) then
        count <= count - 1;
       else
        writeEna <= true;
        count <= 7;
        ctlState <= cWrite;
       end if;
      end if;

     when CWrite =>
      writeEna <= false;
      ctlState <= cUpdAdr;

     when cUpdAdr =>
      wrAddress <= wrAddress + 1;
      dataCount <= dataCount + 1;
      ctlState <= cShift;

     when others => null;
    end case;

    if (ena) then
     case runState is
      when rIdle =>
       loadOut <= false;
       if (not emptyFlag) then
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
       if (not emptyFlag) then
        if (rdOp = opBase + F_Ctrl_Cmd) then
         cmd <= to_cmdRec(outData);
         -- cmd <= unsigned(outData);
         dlyNxt <= rCmd;
        elsif (rdOp = opBase + F_Ld_seq) then
         seqReg <= unsigned(outdata);
         dlyNxt <= rIdle;
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
       -- if (cmd = 1) then
       if (cmd.cmdWaitZ) then
        if (zAxisDone = '1') then
         cmd.cmdWaitZ <= false;
         runState <= rIdle;
        end if;
       -- elsif (cmd = 2) then
       elsif (cmd.cmdWaitX) then
        if (xAxisDone = '1') then
         cmd.cmdWaitX <= false;
         runState <= rIdle;
        end if;
       else
        runState <= rIdle;
       end if;

      when rData =>
       if (len /= 0) then
        if (not emptyFlag) then
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
     -- cmd <= (others => '0');
     cmd <= (others => false);
     opOut <= (others => '0');
    end if;
   end if;
  end if;
 end process Proc;

end behavioral;
