library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

use std.textio.all;
use ieee.std_logic_textio.all;

use work.SimProc.all;
use work.RegDef.all;

entity LatheNewFileTest is
end LatheNewFileTest;
architecture behavior OF LatheNewFileTest is

 component LatheNew is
  port(
   sysClk : in std_logic;

   led : out std_logic_vector(7 downto 0);
   -- dbg : out std_logic_vector(7 downto 0);
   anode : out std_logic_vector(3 downto 0);
   seg : out std_logic_vector(6 downto 0);

   dclk : in std_logic;
   dout : out std_logic;
   din  : in std_logic;
   dsel : in std_logic;

   aIn : in std_logic;
   bIn : in std_logic;
   syncIn : in std_logic;

   zStep : out std_logic;
   zDir : out std_logic;
   xStep : out std_logic;
   xDir : out std_logic;

   zDoneInt : out std_logic;
   xDoneInt : out std_logic
   );
 end Component;

 constant synBits : positive := 32;
 constant posBits : positive := 18;
 constant countBits : positive := 18;
 constant distBits : positive := 18;
 constant locBits : positive := 18;

 constant freqBits : positive := 16;
 constant freqCountBits : positive := 16;

 constant readBits : positive := 32;

-- signal sysClk : std_logic := '0';
 signal led : std_logic_vector(7 downto 0) := (7 downto 0 => '0');
-- signal dbg : std_logic_vector(7 downto 0) := (7 downto 0 => '0');
 signal anode : std_logic_vector(3 downto 0) := (3 downto 0 => '0');
 signal seg : std_logic_vector(6 downto 0) := (6 downto 0 => '0');
 signal dclk : std_logic := '0';
 signal dout : std_logic := '0';
 signal din : std_logic := '0';
 signal dsel : std_logic := '0';
 signal aIn : std_logic := '0';
 signal bIn : std_logic := '0';
 signal syncIn : std_logic := '0';
 signal zStep : std_logic := '0';
 signal zDir : std_logic := '0';
 signal xStep : std_logic := '0';
 signal xDir : std_logic := '0';
 signal zDoneInt : std_logic := '0';
 signal xDoneInt : std_logic := '0';

 signal tmpx : unsigned(32-1 downto 0) := (others => '0');

begin

 uut : LatheNew
  port map(
   -- sysClk => sysClk,
   sysClk => clk,
   
   led => led,
   -- dbg => dbg,
   anode => anode,
   seg => seg,

   dclk => dclk,
   dout => dout,
   din  => din,
   dsel => dsel,

   aIn => aIn,
   bIn => bIn,
   syncIn => syncIn,

   zStep => zStep,
   zDir => zDir,
   xStep => xStep,
   xDir => xDir,

   zDoneInt => zDoneInt,
   xDoneInt => xDoneInt
   );

 -- Clock process definitions

 clkProcess :process
 begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
 end process;

 -- Stimulus process

 stimProc: process

  procedure delay(constant n : in integer) is
  begin
   for i in 0 to n-1 loop
    wait until (clk = '1');
    wait until (clk = '0');
   end loop;
  end procedure delay;

  variable count : integer := 0;
  variable indexCount : integer := 0;

  procedure delayQuad(constant n : in integer) is
  begin
   for i in 0 to n-1 loop
    count := count + 1;
    if (count > 3) then
     count := 0;
    end if;

    indexCount := indexCount + 1;
    if (indexCount > 127) then
     indexCount := 0;
     syncIn <= '1';
    else
     syncIn <= '0';
    end if;
    
    case count is
     when 0 =>
      bIn <= '0';
     when 1 =>
      aIn <= '1';
     when 2 =>
      bIn <= '1';
     when 3 =>
      aIn <= '0';
     when others =>
      count := 0;
    end case;
    delay(10);
   end loop;
  end procedure delayQuad;

  procedure loadParm(constant parmIdx : in unsigned (opbx-1 downto 0)) is
   variable i : integer := 0;
   variable tmp : unsigned (opbx-1 downto 0);
  begin
   dsel <= '0';                          --start of load
   delay(10);

   tmp := parmIdx;
   for i in 0 to opbx-1 loop             --load parameter
    dclk <= '0';
    din <= tmp(opbx-1);
    tmp := shift_left(tmp, 1);
    delay(2);
    dclk <= '1';
    delay(6);
   end loop;
   din <= '0';
   dclk <= '0';

   delay(10);
  end procedure loadParm;

  procedure loadValue(variable value : in integer;
                      constant bits : in natural) is
   variable tmp : std_logic_vector (32-1 downto 0);
  begin
   tmp := conv_std_logic_vector(value, 32);
   for i in 0 to bits-1 loop             --load value
    dclk <= '0';
    din <= tmp(bits-1);
    delay(6);
    dclk <= '1';
    tmp := tmp(31-1 downto 0) & tmp(31);
    delay(6);
   end loop;
   din <= '0';
   dclk <= '0';
   dsel <= '1';                          --end of load
   delay(10);
  end procedure loadValue;

  procedure loadValueC(constant value : in integer;
                       constant bits : in natural) is
   variable tmp : integer;
  begin
   tmp := value;
   loadValue(tmp, bits);
  end procedure loadValueC;
  
  constant lenBits : integer := 8;
  constant parmBits : integer := 8;
  constant byteBits : integer := 8;

  procedure loadMid(variable value : in integer;
                    variable bits : in natural) is
   variable tmp : std_logic_vector (32-1 downto 0);
  begin
   tmp := conv_std_logic_vector(value, 32);
   for i in 0 to bits-1 loop             --load value
    dclk <= '0';
    din <= tmp(bits-1);
    delay(2);
    dclk <= '1';
    tmp := tmp(31-1 downto 0) & tmp(31);
    delay(6);
   end loop;
   din <= '0';
   dclk <= '0';
  end procedure loadMid;

  procedure loadMidValue(variable value : in integer;
                         constant bits : in natural) is
   variable val : integer;
   variable bitLen : integer;
  begin
   val := (bits + 7) / 8;
   bitLen := lenBits;
   loadMid(val, bitLen);
   bitLen := val * 8;
   loadMid(value, bitLen);
  end procedure loadMidValue;

  procedure loadMidVC(variable value : in integer;
                      constant bits : in natural) is
   variable len : integer;
  begin
   len := bits;
   loadMid(value, len);
  end procedure loadMidVC;

  procedure loadMidCC(constant value : in integer;
                      constant bits : in natural) is
   variable tmp : integer;
   variable len : integer;
  begin
   tmp := value;
   len := bits;
   loadMid(tmp, len);
  end procedure loadMidCC;
  
  procedure loadEnd is
  begin
   dsel <= '1';                          --end of load
   delay(10);
  end procedure loadEnd;
  
  procedure readMidValue(constant bits : in natural) is
   variable tmp : unsigned (bits-1 downto 0);
  begin
   tmp := (others => '0');
   din <= '0';
   for i in 0 to bits-1 loop            --read value
    dclk <= '0';
    delay(6);
    dclk <= '1';
    tmp := tmp(31-1 downto 0) & dout;
    delay(6);
   end loop;
   report "value " & integer'image(to_integer(tmp));
   dclk <= '0';
   delay(10);
   tmpx <= tmp;
  end procedure readMidValue;

  procedure readValue(constant bits : in natural) is
  begin
   readMidValue(bits);
   dsel <= '1';
  end procedure readValue;

  -- procedure loadShift(variable value : in integer;
  --                     constant bits : in natural) is
  --  variable tmp: std_logic_vector(32-1 downto 0);
  -- begin
  --  tmp := conv_std_logic_vector(value, 32);
  --  dshift <= '1';
  --  for i in 0 to bits-1 loop
  --   din <= tmp(bits - 1);
  --   wait until clk = '1';
  --   tmp := tmp(31-1 downto 0) & tmp(31);
  --   wait until clk = '0';
  --  end loop;
  --  dshift <= '0';
  -- end procedure loadShift;

--variables

  variable dx : integer;
  variable dy : integer;
  variable d  : integer;
  variable incr1 : integer;
  variable incr2 : integer;
  variable accelVal : integer;
  variable accelCount : integer;
  variable dist : integer;
  variable loc : integer;

  variable ctl : integer;

  variable freq : integer;
  variable dbgCount : integer;

--(++ axisCtl
-- axis control register

  constant axisCtlSize : integer := 8;
  variable axisCtlReg : unsigned(axisCtlSize-1 downto 0) := (others => '0');
  alias ctlInit    : std_logic is axisCtlreg(0); -- x01 reset flag
  alias ctlStart   : std_logic is axisCtlreg(1); -- x02 start
  alias ctlBacklash : std_logic is axisCtlreg(2); -- x04 backlash move no pos upd
  alias ctlWaitSync : std_logic is axisCtlreg(3); -- x08 wait for sync to start
  alias ctlDir     : std_logic is axisCtlreg(4); -- x10 direction
  alias ctlDirPos  : std_logic is axisCtlreg(4); -- x10 move in positive dir
  alias ctlSetLoc  : std_logic is axisCtlreg(5); -- x20 set location
  alias ctlChDirect : std_logic is axisCtlreg(6); -- x40 ch input direct
  alias ctlSlave   : std_logic is axisCtlreg(7); -- x80 slave controlled by other

  -- configuration control register

  constant cfgCtlSize : integer := 6;
  variable cfgCtlReg : unsigned(cfgCtlSize-1 downto 0);
  alias cfgZDir    : std_logic is cfgCtlreg(0); -- x01 z direction inverted
  alias cfgXDir    : std_logic is cfgCtlreg(1); -- x02 x direction inverted
  alias cfgSpDir   : std_logic is cfgCtlreg(2); -- x04 spindle directiion inverted
  alias cfgEncDir  : std_logic is cfgCtlreg(3); -- x08 invert encoder direction
  alias cfgEnaEncDir : std_logic is cfgCtlreg(4); -- x10 enable encoder direction
  alias cfgGenSync : std_logic is cfgCtlreg(5); -- x20 no encoder generate sync pulse

  -- clock control register

  constant clkCtlSize : integer := 7;
  variable clkCtlReg : unsigned(clkCtlSize-1 downto 0);
  alias zFreqSel   : unsigned is clkCtlreg(2 downto 0); -- x01 z Frequency select
  alias xFreqSel   : unsigned is clkCtlreg(5 downto 3); -- x08 x Frequency select
  alias clkDbgFreqEna : std_logic is clkCtlreg(6); -- x40 enable debug frequency

  constant clkNone    : unsigned (2 downto 0) := "000";
  constant clkFreq    : unsigned (2 downto 0) := "001";
  constant clkCh      : unsigned (2 downto 0) := "010";
  constant clkIntClk  : unsigned (2 downto 0) := "011";
  constant clkSlvStep : unsigned (2 downto 0) := "100";
  constant clkslvFreq : unsigned (2 downto 0) := "101";
  constant clkSpare   : unsigned (2 downto 0) := "110";
  constant clkDbgFreq : unsigned (2 downto 0) := "111";

  -- sync control register

  constant synCtlSize : integer := 3;
  variable synCtlReg : unsigned(synCtlSize-1 downto 0);
  alias synPhaseInit : std_logic is synCtlreg(0); -- x01 init phase counter
  alias synEncInit : std_logic is synCtlreg(1); -- x02 init encoder
  alias synEncEna  : std_logic is synCtlreg(2); -- x04 enable encoder

--++)

  alias base : unsigned is F_XAxis_Base;
  -- alias freqSel : unsigned is clkCtlreg(2 downto 0);
  alias freqSel : unsigned is clkCtlreg(5 downto 3);

  constant waitZ : integer := 1;
  constant waitX : integer := 2;

  -- file cmdData : text;
  variable val : integer;
 begin

-- hold reset state for 100 ns.

  wait for 100 ns;

  delay(10);

  -- insert stimulus here

  dx := 2540 * 8;
  dy := 600;

  --dx := 87381248;
  --dy := 341258;

  dist := 20;
  loc := 5;

  incr1 := 2 * dy;
  incr2 := 2 * (dy - dx);
  d := incr1 - dx;

  loadParm(F_Ctrl_Base + F_Ld_Ctrl_Data); --load data

  -- val := to_integer(F_Ctrl_Base + F_Ctrl_Cmd); --wait for axis done
  -- loadMidVC(val, opB);
  -- loadMidCC(waitX, byteBits);

  val := to_integer(F_Ctrl_Base + F_Ld_seq);
  loadMidVC(val, opB);
  val := 3;
  loadMidVC(val, byteBits);

  val := to_integer(base + F_Ld_Axis_Ctl);
  loadMidVC(val, parmBits);

  axisCtlReg := (others => '0');        --clear axis control
  ctl := to_integer(axisCtlReg);
  loadMidValue(ctl, axisCtlSize);

  -- file_open(cmdData, "ctrlCmds.txt", read_mode);

  -- while not endfile(cmdData) loop
  --  readline(cmdData, inpLine);
  --  read(inpLine, dataVal);
  --  read(inpLine, sep);
  --  read(inpLine, lenVal);
  --  loadMid(dataVal, lenVal);
  -- end loop;

  -- loadEnd;
  -- file_close(cmdData);

  accelVal := 8;
  accelCount := 100;

  val := to_integer(base + F_Sync_Base + F_Ld_D);
  loadMidVC(val, parmBits);
  loadMidValue(d, synBits);

  delay(1);

  val := to_integer(base + F_Sync_Base + F_Ld_Incr1);
  loadMidVC(val, parmBits);
  loadMidValue(incr1, synBits);

  delay(1);

  val := to_integer(base + F_Sync_Base + F_Ld_Incr2);
  loadMidVC(val, parmBits);
  loadMidValue(incr2, synBits);

  delay(1);

  val := to_integer(base + F_Sync_Base + F_Ld_Accel_Val);
  loadMidVC(val, parmBits);
  loadMidValue(accelVal, synBits);

  delay(1);

  val := to_integer(base + F_Sync_Base + F_Ld_Accel_Count);
  loadMidVC(val, parmBits);
  loadMidValue(accelCount, countBits);
  
  delay(1);

  val := to_integer(base + F_Dist_Base + F_Ld_Dist);
  loadMidVC(val, parmBits);
  loadMidValue(dist, distBits);

  delay(1);

  val := to_integer(base + F_Loc_Base + F_Ld_Loc);
  loadMidVC(val, parmBits);
  loadMidValue(loc, locBits);

  val := to_integer(base + F_Ld_Axis_Ctl);
  loadMidVC(val, parmBits);

  axisCtlReg := (others => '0');
  ctlInit := '1';
  ctlSetLoc := '1';
  ctl := to_integer(axisCtlReg);
  loadMidValue(ctl, axisCtlSize);

  val := to_integer(base + F_Ld_Axis_Ctl);
  loadMidVC(val, parmBits);

  ctlInit := '0';
  ctlSetLoc := '0';
  ctlStart := '1';
  ctlDir := '1';
  ctl := to_integer(axisCtlReg);
  loadMidValue(ctl, axisCtlSize);

  val := to_integer(F_Dbg_Freq_Base + F_Ld_Dbg_Freq);
  loadMidCC(val, parmBits);
  freq := 10-1;
  loadMidValue(freq, freqBits);

  val := to_integer(F_Dbg_Freq_Base + F_Ld_Dbg_Count);
  loadMidCC(val, parmBits);
  dbgCount := 3000;
  loadMidValue(dbgCount ,freqCountBits);

  clkCtlReg := (others => '0');
  freqSel := clkDbgFreq;                --to_unsigned(7, 3);
  clkDbgFreqEna := '1';
  
  val := to_integer(F_Ld_Clk_Ctl);
  loadMidVC(val, parmBits);
  ctl := to_integer(clkCtlReg);
  loadMidValue(ctl, clkCtlSize);

  val := to_integer(F_Ctrl_Base + F_Ctrl_Cmd); --wait for axis done
  loadMidVC(val, opB);
  loadMidCC(waitX, byteBits);

  val := to_integer(base + F_Ld_Axis_Ctl); --clear axis control
  loadMidVC(val, parmBits);

  axisCtlReg := (others => '0');
  ctl := to_integer(axisCtlReg);
  loadMidValue(ctl, axisCtlSize);

  loadEnd;
  
  delay(10);
  
  loadParm(F_Ctrl_Base + F_Rd_Ctr);     --read byte count
  readValue(32);
  
  delay(10);

  loadParm(F_Ld_Run_ctl);
  val := 1;
  loadValue(val, byteBits);

  delay(1000);

  loadParm(F_Rd_Status);  --read byte count
  readValue(32);
  
  loadParm(F_Ctrl_Base + F_Rd_Seq);     --read sequence number
  readValue(32);

  loadParm(F_Ctrl_Base + F_Rd_Ctr);     --read byte count
  readValue(32);

  -- while (true) loop
  --  loadParm(F_Rd_Status);  --read byte count
  --  readValue(32);
  --  if (tmpx(4) = '1')  then
  --   exit;
  --  end if;
  -- end loop;
  
  delay(4500);

  loadParm(F_Read_Base + F_Ld_Read_Data);
  val := to_integer(F_XAxis_Base + F_Loc_Base + F_Rd_Loc);
  loadMidVC(val, opBx);
  val := to_integer(F_XAxis_Base + F_Sync_Base + F_Rd_XPos);
  loadMidVC(val, opBx);
  loadEnd;

  loadParm(F_Read_Base + F_Read);
  readMidValue(32);
  readMidValue(32);
  loadEnd;
  
  wait;
 end process;

end;
