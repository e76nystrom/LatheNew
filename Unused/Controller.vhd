library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.all;
use work.conversion.all;

entity Controller is
 generic (opBase     : unsigned;
          addrBits   : positive := 8;
          statusBits : positive;
          seqBits    : positive;
          outBits    : positive
          );
 port (
  clk      : in std_logic;
  init     : in std_logic;

  dInp     : in DataInp;

  copy     : in std_logic;

  ena      : in std_logic;

  zDoneInt : in std_logic;
  xDoneInt : in std_logic;

  dout     : out std_logic := '0';

  ctlDIn   : out std_logic := '0';
  ctlShift : out std_logic := '0';
  ctlOp    : out unsigned(opb-1 downto 0) := (others => '0');
  ctlLoad  : out std_logic := '0';

  busy      : out std_logic := '0';
  notEmpty  : out std_logic := '0'
  );
end Controller;

architecture behavioral of  Controller is

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
 signal notEmptyFlag : std_logic := '0';

 signal tmp : unsigned (addrBits-1 downto 0);

 signal seqReg : unsigned (seqBits-1 downto 0) := (others => '0');
 signal seqDout : std_logic;
 signal countDout : std_logic;

 signal writeEna : std_logic := '0';
 signal opSel : std_logic;

 signal outData : std_logic_vector (byteBits-1 downto 0) := (others => '0');

 signal data : unsigned (byteBits-1 downto 0) := (others => '0');

 signal dRead : DataOut;

 signal count : integer range 0 to 7;

 signal len : unsigned (byteBits-1 downto 0) := (others => '0'); 
 signal cmd : unsigned (byteBits-1 downto 0) := (others => '0');
 -- signal cmd : cmdRec := (others => false);
 -- signal cmd : cmdRec := (cmdWaitZ => false, cmdWaitX => false);

 constant readDelay : integer := 2-1;

 signal dlyNxt : runFsm := rIdle;
 signal delay : integer range 0 to readDelay := 0;

begin

 shiftProc : entity work.ShiftOpSel
  generic map (opVal  => opBase + F_Ld_Ctrl_Data,
               n      => byteBits)
  port map(
   clk   => clk,
   inp   => dInp,
   -- din   => din,
   -- op    => op,
   -- shift => dshift,
   sel   => opSel,
   data  => dataReg
   );

 memProc : entity work.CMem
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

 dRead <= (shift => dInp.shift, op => dInp.op, copy => copy);

 rdSeq : entity work.ShiftOutN
  generic map (opVal   => opBase + F_Rd_Seq,
               n       => seqBits,
               outBits => outBits)
  port map (
   clk    => clk,
   oRec   => dRead,
   -- dshift => dshift,
   -- op     => op,
   -- copy   => copy,
   data   => seqReg,
   dout   => seqDout
   );

 tmp <= to_unsigned(dataCount, addrBits);

 rdCount : entity work.ShiftOutN
  generic map (opVal   => opBase + F_Rd_Ctr,
               n       => addrBits,
               outBits => outBits)
  port map (
   clk    => clk,
   oRec   => dRead,
   -- dshift => dshift,
   -- op     => op,
   -- copy   => copy,
   data   => tmp,
   dout   => countDout
   );

 ctlDIn <= data(byteBits-1);
 notEmpty <= notEmptyFlag;

 Proc : process(clk)
  variable rdOp : unsigned (opb-1 downto 0) := (others => '0'); 
 begin
  if (rising_edge(clk)) then
   if (init = '1') then                 --if initialize
    ctlState  <= cIdle;
    runState  <= rIdle;
    writeEna  <= '0';
    rdAddress <= (others => '0');
    wrAddress <= (others => '0');
    dataCount <= 0;
    notEmptyFlag <= '0';
   else                                 --if not initializing

    -- control fsm

    case ctlState is
     when cIdle =>                      --idle
      if ((opSel = '1') and (copy = '1')) then
       count <= 7;
       ctlState <= cShift;              --next state
      end if;

     when cShift =>                     --shift data in
      if ((opSel = '0') or (dInp.load = '1')) then
       ctlState <= cIdle;               --next state
      elsif (dInp.shift = '1') then
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
      notEmptyFlag <= '1';
      ctlState     <= cShift;           --next state

     when others => null;
    end case;                           --end control fsm

    if (ena = '1') then                 --if enabled

     -- run fsm

     case runState is
      when rIdle =>                     --idle
       ctlLoad <= '0';
       if (notEmptyFlag = '1') then
        rdOp := unsigned(outData);
        if (rdOp = opBase + F_Ctrl_Cmd) then
         dlyNxt <= rCmd;
        elsif (rdOp = opBase + F_Ld_seq) then
         dlyNxt <= rSeq;
        else
         ctlOp  <= rdOp;
         dlyNxt <= rLen;
        end if;
        runState <= rAddr;              --next state
       end if;

      when rAddr =>                     --update address
       if (notEmptyFlag = '0') then
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
       busy <= '1';
       runState <= rWait;

      when rWait =>                     --wait for axis done
       if (cmd(0) = '1') then
        if (zDoneInt = '1') then
         cmd(0) <= '0';
        end if;
       elsif (cmd(1) = '1') then
        if (xDoneInt = '1') then
         cmd(1) <= '0';
        end if;
       else
        busy     <= '0';
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
        if (notEmptyFlag = '1') then
         data <= unsigned(outData);
         count     <= 7;
         ctlShift <= '1';
         rdAddress <= rdAddress + 1;
         dataCount <= dataCount - 1;
         runState  <= rShift;           --next state
        else
         null;
        end if;
       else
        ctlLoad  <= '1';
        runState <= rDone;              --next state
       end if;

      when rShift =>                    --shift data out
       if (count /= 0) then
        count <= count - 1;
        data <= shift_left(data, 1);
       else
        ctlShift <= '0';
        len <= len - 1;
        if (dataCount = 0) then
         notEmptyFlag <= '0';
        end if;
        runState <= rData;              --next state
       end if;

      when rDone =>                     --done
       ctlLoad  <= '0';
       ctlOp    <= (others => '0');
       runState <= rIdle;               --next state

      when others => null;
     end case;                          --end run state machine
     
    else                                --not enabled
     len   <= (others => '0');
     data  <= (others => '0');
     cmd   <= (others => '0');
     ctlOp <= (others => '0');
    end if;                             --enabled
   end if;                              --initialize
  end if;                               --clock
 end process Proc;

end behavioral;
