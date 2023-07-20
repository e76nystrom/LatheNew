library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.conversion.all;

entity Controller is
 generic (opBase     : unsigned;
          opBits     : positive;
          addrBits   : positive := 8;
          statusBits : positive;
          seqBits    : positive;
          outBits    : positive
          );
 port (
  clk       : in std_logic;
  init      : in std_logic;
  din       : in std_logic;
  dshift    : in boolean;
  op        : in unsigned(opBits-1 downto 0);
  copy      : in boolean;
  load      : in boolean;
  ena       : in std_logic;
  statusReg : in unsigned(statusBits-1 downto 0);
  
  dout      : out std_logic := '0';
  dinOut    : out std_logic := '0';
  dshiftOut : out boolean := false;
  opOut     : out unsigned(opBits-1 downto 0) := (others => '0');
  loadOut   : out boolean := false;
  busy      : out boolean := false;
  notEmpty  : out boolean := false
  );
end Controller;

architecture behavioral of  Controller is

 component ShiftOpSel is
  generic(opVal  : unsigned;
          opBits : positive;
          n      : positive);
  port(
   clk   : in std_logic;
   din   : in std_logic;
   op    : in unsigned (opBits-1 downto 0);
   shift : in boolean;
   sel   : out boolean;
   data  : inout unsigned (n-1 downto 0)
   );
 end Component;

 component CMem IS
  port
   (
    clock     : in std_logic;
    data      : in std_logic_vector (7 downto 0);
    rdaddress : in std_logic_vector (7 downto 0);
    wraddress : in std_logic_vector (7 downto 0);
    wren      : in std_logic;
    q         : out std_logic_vector (7 downto 0)
    );
 end component;

 component ShiftOutN is
  generic(opVal   : unsigned;
          opBits  : positive;
          n       : positive;
          outBits : positive);
  port (
   clk    : in std_logic;
   dshift : in boolean;
   op     : in unsigned (opBits-1 downto 0);
   copy   : in boolean;
   data   : in unsigned(n-1 downto 0);
   dout   : out std_logic
   );
 end Component;

 constant byteBits : positive := 8;

 type ctlFsm is (cIdle, cShift, cWrite, cUpdAdr);
 signal ctlState : ctlFsm := cIdle;

 type runFsm is (rIdle, raddr, rDly, rCmd, rWait, rSeq, rLen,
                 rData, rShift, rDone);
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
 signal notEmptyFlag : boolean := false;

 signal tmp : unsigned (addrBits-1 downto 0);

 signal seqReg : unsigned (seqBits-1 downto 0) := (others => '0');
 signal seqDout : std_logic;
 signal countDout : std_logic;

 signal writeEna : std_logic := '0';
 signal opSel : boolean;

 signal outData : std_logic_vector (byteBits-1 downto 0) := (others => '0');

 signal data : unsigned (byteBits-1 downto 0) := (others => '0');

 signal count : integer range 0 to 7;

 signal len : unsigned (byteBits-1 downto 0) := (others => '0'); 
 signal cmd : unsigned (byteBits-1 downto 0) := (others => '0');
 -- signal cmd : cmdRec := (others => false);
 -- signal cmd : cmdRec := (cmdWaitZ => false, cmdWaitX => false);

 constant readDelay : integer := 2-1;

 signal dlyNxt : runFsm := rIdle;
 signal delay : integer range 0 to readDelay := 0;

 constant statusSize : integer := 10;
 alias zAxisEna     : std_logic is statusreg(0); -- x01 z axis enable flag
 alias zAxisDone    : std_logic is statusreg(1); -- x02 z axis done
 alias zAxisCurDir  : std_logic is statusreg(2); -- x04 z axis current dir
 alias xAxisDone    : std_logic is statusreg(3); -- x08 x axis done
 alias xAxisEna     : std_logic is statusreg(4); -- x10 x axis enable flag
 alias xAxisCurDir  : std_logic is statusreg(5); -- x20 x axis current dir
 alias spindleActive : std_logic is statusreg(6); -- x40 x axis current dir
 alias queEmpty     : std_logic is statusreg(7); -- x80 controller queue empty
 alias ctlIdle      : std_logic is statusreg(8); -- x100 controller idle
 alias syncActive   : std_logic is statusreg(9); -- x200 sync active

begin

 shiftProc : ShiftOpSel
  generic map(opVal  => opBase + F_Ld_Ctrl_Data,
              opBits => opBits,
              n      => byteBits)
  port map(
   clk   => clk,
   din   => din,
   op    => op,
   shift => dshift,
   sel   => opSel,
   data  => dataReg
   );

 memProc : CMem
  port map
  (
   clock     => clk,
   data      => std_logic_vector(dataReg),
   rdaddress => std_logic_vector(rdAddress),
   wraddress => std_logic_vector(wrAddress),
   wren      => writeEna,
   q         => outData
   );

 dout <= seqDout or countDout;

 rdSeq : ShiftOutN
  generic map(opVal   => opBase + F_Rd_Seq,
              opBits  => opBits,
              n       => seqBits,
              outBits => outBits)
  port map (
   clk    => clk,
   dshift => dshift,
   op     => op,
   copy   => copy,
   data   => seqReg,
   dout   => seqDout
   );

 tmp <= to_unsigned(dataCount, addrBits);

 rdCount : ShiftOutN
  generic map(opVal   => opBase + F_Rd_Ctr,
              opBits  => opBits,
              n       => addrBits,
              outBits => outBits)
  port map (
   clk    => clk,
   dshift => dshift,
   op     => op,
   copy   => copy,
   data   => tmp,
   dout   => countDout
   );

 dinOut <= data(byteBits-1);
 notEmpty <= notEmptyFlag;

 Proc : process(clk)
  variable rdOp : unsigned (opBits-1 downto 0) := (others => '0'); 
 begin
  if (rising_edge(clk)) then
   if (init = '1') then                 --if initialize
    ctlState  <= cIdle;
    runState  <= rIdle;
    writeEna  <= '0';
    rdAddress <= (others => '0');
    wrAddress <= (others => '0');
    dataCount <= 0;
    notEmptyFlag <= false;
   else                                 --if not initializing

    -- control fsm

    case ctlState is
     when cIdle =>                      --idle
      if (opSel and copy) then
       count <= 7;
       ctlState <= cShift;              --next state
      end if;

     when cShift =>                     --shift data in
      if ((not opSel) or load) then
       ctlState <= cIdle;               --next state
      elsif (dshift) then
       if (count /= 0) then
        count <= count - 1;
       else
        writeEna <= '1';
        count    <= 7;
        ctlState <= cWrite;             --next state
       end if;
      end if;

     when CWrite =>                     --write to memory
      writeEna <= '0';
      ctlState <= cUpdAdr;              --next state

     when cUpdAdr =>                    --update address
      wrAddress    <= wrAddress + 1;
      dataCount    <= dataCount + 1;
      notEmptyFlag <= true;
      ctlState     <= cShift;           --next state

     when others => null;
    end case;                           --end control fsm

    if (ena = '1') then                 --if enabled

     -- run fsm

     case runState is
      when rIdle =>                     --idle
       loadOut <= false;
       if (notEmptyFlag) then
        rdOp := unsigned(outData);
        if (rdOp = opBase + F_Ctrl_Cmd) then
         dlyNxt <= rCmd;
        elsif (rdOp = opBase + F_Ld_seq) then
         dlyNxt <= rSeq;
        else
         opOut  <= rdOp;
         dlyNxt <= rLen;
        end if;
        runState <= rAddr;              --next state
       end if;

      when rAddr =>                     --update address
       if (not notEmptyFlag) then
        rdAddress <= rdAddress + 1;
        dataCount <= dataCount - 1;
        delay     <= readDelay;
        runState  <= rDly;              --next state
       else
        runState <= rIdle;              --next state
       end if;
       
      when rDly =>                      --delay for data
       if (delay /= 0) then
        delay <= delay - 1;
       else
        runState <= dlyNxt;             --nex state
       end if;

      when rCmd =>                      --get command
       cmd <= unsigned(outData);
       -- cmd <= to_cmdRec(outData);
       busy <= true;
       runState <= rWait;

      when rWait =>                     --wait for axis done
       if (cmd(0) = '1') then
        if (zAxisDone = '1') then
         cmd(0) <= '0';
        end if;
       elsif (cmd(1) = '1') then
        if (xAxisDone = '1') then
         cmd(1) <= '0';
        end if;
       else
        busy     <= false;
        dlyNxt   <= rIdle;
        runState <= rAddr;              --next state
       end if;

      when rSeq =>                      --save sequence number
       seqReg   <= unsigned(outdata);
       dlyNxt   <= rIdle;
       runState <= rAddr;               --next state

      when rLen =>                      --get length
       len <= unsigned(outData);
       dlyNxt   <= rData;
       runState <= rAddr;               --next state
       
      when rData =>                     --read data
       if (len /= 0) then
        if (notEmptyFlag) then
         data <= unsigned(outData);
         count     <= 7;
         dshiftOut <= true;
         rdAddress <= rdAddress + 1;
         dataCount <= dataCount - 1;
         runState  <= rShift;           --next state
        else
         null;
        end if;
       else
        loadOut  <= true;
        runState <= rDone;              --next state
       end if;

      when rShift =>                    --shift data out
       if (count /= 0) then
        count <= count - 1;
        data <= shift_left(data, 1);
       else
        dshiftOut <= false;
        len <= len - 1;
        if (dataCount = 0) then
         notEmptyFlag <= false;
        end if;
        runState <= rData;              --next state
       end if;

      when rDone =>                     --done
       loadOut  <= false;
       opOut    <= (others => '0');
       runState <= rIdle;               --next state

      when others => null;
     end case;                          --end run state machine
     
    else                                --not enabled
     len   <= (others => '0');
     data  <= (others => '0');
     cmd   <= (others => '0');
     opOut <= (others => '0');
    end if;                             --enabled
   end if;                              --initialize
  end if;                               --clock
 end process Proc;

end behavioral;
