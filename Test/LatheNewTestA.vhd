library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

use work.SimProc.all;
use work.RegDef.all;

entity A_LatheNewTest is
end A_LatheNewTest;
architecture behavior OF A_LatheNewTest is

 component LatheNew is
  port(
   sysClk : in std_logic;

   led : out std_logic_vector(7 downto 0);
   dbg : out std_logic_vector(7 downto 0);
   anode : out std_logic_vector(3 downto 0);
   seg : out std_logic_vector(6 downto 0);

   dclk : in std_logic;
   dout : out std_logic;
   din  : in std_logic;
   dsel : in std_logic;

   aIn : in std_logic;
   bIn : in std_logic;
   syncIn : in std_logic;

   zDro : in std_logic_vector(1 downto 0);
   xDro : in std_logic_vector(1 downto 0);
   zMpg : in std_logic_vector(1 downto 0);
   xMpg : in std_logic_vector(1 downto 0);

   pinIn : in std_logic_vector(4 downto 0);
   aux : in std_logic_vector(7 downto 0);

   pinOut : out std_logic_vector(11 downto 0) := (others => '0');
   extOut : out std_logic_vector(2 downto 0) := (others => '0');
   
   bufOut : out std_logic_vector(3 downto 0) := (others => '0');

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

 signal sysClk : std_logic := '0';

 signal led : std_logic_vector(7 downto 0) := (7 downto 0 => '0');
 signal dbg : std_logic_vector(7 downto 0) := (7 downto 0 => '0');
 signal anode : std_logic_vector(3 downto 0) := (3 downto 0 => '0');
 signal seg : std_logic_vector(6 downto 0) := (6 downto 0 => '0');

 signal zDro : std_logic_vector(1 downto 0) := (others => '0');
 signal xDro : std_logic_vector(1 downto 0) := (others => '0');
 signal zMpg : std_logic_vector(1 downto 0) := (others => '0');
 signal xMpg : std_logic_vector(1 downto 0) := (others => '0');

 signal pinIn : std_logic_vector(4 downto 0) := (others => '0');
 signal aux : std_logic_vector(7 downto 0) := (others => '0');

 signal pinOut : std_logic_vector(11 downto 0);
 signal extOut : std_logic_vector(2 downto 0);
  
 signal bufOut : std_logic_vector(3 downto 0);

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

begin

 uut : LatheNew
  port map(
   sysClk => sysClk,
   
   led => led,
   dbg => dbg,
   anode => anode,
   seg => seg,

   dclk => dclk,
   dout => dout,
   din  => din,
   dsel => dsel,

   aIn => aIn,
   bIn => bIn,
   syncIn => syncIn,

   zDro => zDro,
   xDro => xDro,
   zMpg => zMpg,
   xMpg => xMpg,

   pinIn => pinIn,
   aux => aux,

   pinOut => pinOut,
   extOut => extOut,

   zDoneInt => zDoneInt,
   xDoneInt => xDoneInt
   );

 -- Clock process definitions

 clkProcess :process
 begin
  sysClk <= '0';
  wait for clk_period/2;
  sysClk <= '1';
  wait for clk_period/2;
 end process;

 -- Stimulus process

 stimProc: process

  procedure delay(constant n : in integer) is
  begin
   for i in 0 to n-1 loop
    wait until (sysClk = '1');
    wait until (sysClk = '0');
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
   report "parmIdx " & integer'image(to_integer(tmp));
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
  
  procedure loadMid(variable value : in integer;
                    constant bits : in natural) is
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

  procedure loadMidC(constant value : in integer;
                     constant bits : in natural) is
   variable tmp : integer;
  begin
   tmp := value;
   loadMid(tmp, bits);
  end procedure loadMidC;
  
  procedure readValue(constant bits : in natural) is
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
   dsel <= '1';                          --end of load
   delay(10);
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
  variable base : unsigned(opb -1 downto 0);

-- axis control register

  constant axisCtlSize : integer := 13;
  signal axisCtlReg : unsigned(axisCtlSize-1 downto 0);
  alias ctlInit      : std_logic is axisCtlreg(0); -- x01 reset flag
  alias ctlStart     : std_logic is axisCtlreg(1); -- x02 start
  alias ctlBacklash  : std_logic is axisCtlreg(2); -- x04 backlash move no pos upd
  alias ctlWaitSync  : std_logic is axisCtlreg(3); -- x08 wait for sync to start
  alias ctlDir       : std_logic is axisCtlreg(4); -- x10 direction
  alias ctlDirPos    : std_logic is axisCtlreg(4); -- x10 move in positive dir
  alias ctlDirNeg    : std_logic is axisCtlreg(4); -- x10 move in negative dir
  alias ctlSetLoc    : std_logic is axisCtlreg(5); -- x20 set location
  alias ctlChDirect  : std_logic is axisCtlreg(6); -- x40 ch input direct
  alias ctlSlave     : std_logic is axisCtlreg(7); -- x80 slave controlled by other axis
  alias ctlDroEnd    : std_logic is axisCtlreg(8); -- x100 use dro to end move
  alias ctlJogCmd    : std_logic is axisCtlreg(9); -- x200 jog with commands
  alias ctlJogMpg    : std_logic is axisCtlreg(10); -- x400 jog with mpg
  alias ctlHome      : std_logic is axisCtlreg(11); -- x800 homing axis
  alias ctlIgnoreLim : std_logic is axisCtlreg(12); -- x1000 ignore limits

  constant c_ctlInit      : integer :=  0; -- x01 reset flag
  constant c_ctlStart     : integer :=  1; -- x02 start
  constant c_ctlBacklash  : integer :=  2; -- x04 backlash move no pos upd
  constant c_ctlWaitSync  : integer :=  3; -- x08 wait for sync to start
  constant c_ctlDir       : integer :=  4; -- x10 direction
  constant c_ctlDirPos    : integer :=  4; -- x10 move in positive dir
  constant c_ctlDirNeg    : integer :=  4; -- x10 move in negative dir
  constant c_ctlSetLoc    : integer :=  5; -- x20 set location
  constant c_ctlChDirect  : integer :=  6; -- x40 ch input direct
  constant c_ctlSlave     : integer :=  7; -- x80 slave controlled by other axis
  constant c_ctlDroEnd    : integer :=  8; -- x100 use dro to end move
  constant c_ctlJogCmd    : integer :=  9; -- x200 jog with commands
  constant c_ctlJogMpg    : integer := 10; -- x400 jog with mpg
  constant c_ctlHome      : integer := 11; -- x800 homing axis
  constant c_ctlIgnoreLim : integer := 12; -- x1000 ignore limits

-- configuration control register

  constant cfgCtlSize : integer := 20;
  variable cfgCtlReg : unsigned(cfgCtlSize-1 downto 0) := (others => '0');
  alias cfgZDirInv   : std_logic is cfgCtlreg(0); -- x01 z direction inverted
  alias cfgXDirInv   : std_logic is cfgCtlreg(1); -- x02 x direction inverted
  alias cfgZDroInv   : std_logic is cfgCtlreg(2); -- x04 z dro direction inverted
  alias cfgXDroInv   : std_logic is cfgCtlreg(3); -- x08 x dro direction inverted
  alias cfgZJogInv   : std_logic is cfgCtlreg(4); -- x10 z jog direction inverted
  alias cfgXJogInv   : std_logic is cfgCtlreg(5); -- x20 x jog direction inverted
  alias cfgSpDirInv  : std_logic is cfgCtlreg(6); -- x40 spindle direction inverted
  alias cfgZHomeInv  : std_logic is cfgCtlreg(7); -- x80 z home inverted
  alias cfgZMinusInv : std_logic is cfgCtlreg(8); -- x100 z minus inverted
  alias cfgZPlusInv  : std_logic is cfgCtlreg(9); -- x200 z plus inverted
  alias cfgXHomeInv  : std_logic is cfgCtlreg(10); -- x400 x home inverted
  alias cfgXMinusInv : std_logic is cfgCtlreg(11); -- x800 x minus inverted
  alias cfgXPlusInv  : std_logic is cfgCtlreg(12); -- x1000 x plus inverted
  alias cfgProbeInv  : std_logic is cfgCtlreg(13); -- x2000 probe inverted
  alias cfgEncDirInv : std_logic is cfgCtlreg(14); -- x4000 invert encoder direction
  alias cfgEStopEna  : std_logic is cfgCtlreg(15); -- x8000 estop enable
  alias cfgEStopInv  : std_logic is cfgCtlreg(16); -- x10000 estop invert
  alias cfgEnaEncDir : std_logic is cfgCtlreg(17); -- x20000 enable encoder direction
  alias cfgGenSync   : std_logic is cfgCtlreg(18); -- x40000 no encoder generate sync pulse
  alias cfgPWMEna    : std_logic is cfgCtlreg(19); -- x80000 pwm enable

  constant clkCtlSize : integer := 7;
  variable clkCtlReg : unsigned(clkCtlSize-1 downto 0) := (others => '0');
  alias zFreqSel     : unsigned is clkCtlreg(2 downto 0); -- x04 z Frequency select
  alias xFreqSel     : unsigned is clkCtlreg(5 downto 3); -- x20 x Frequency select
  constant clkNone      : unsigned (2 downto 0) := "000"; -- 
  constant clkFreq      : unsigned (2 downto 0) := "001"; -- 
  constant clkCh        : unsigned (2 downto 0) := "010"; -- 
  constant clkIntClk    : unsigned (2 downto 0) := "011"; -- 
  constant clkSlvFreq   : unsigned (2 downto 0) := "100"; -- 
  constant clkSlvCh     : unsigned (2 downto 0) := "101"; -- 
  constant clkSpindle   : unsigned (2 downto 0) := "110"; -- 
  constant clkDbgFreq   : unsigned (2 downto 0) := "111"; -- 
  constant zClkNone     : unsigned (2 downto 0) := "000"; -- 
  constant zClkZFreq    : unsigned (2 downto 0) := "001"; -- 
  constant zClkCh       : unsigned (2 downto 0) := "010"; -- 
  constant zClkIntClk   : unsigned (2 downto 0) := "011"; -- 
  constant zClkXFreq    : unsigned (2 downto 0) := "100"; -- 
  constant zClkXCh      : unsigned (2 downto 0) := "101"; -- 
  constant zClkSpindle  : unsigned (2 downto 0) := "110"; -- 
  constant zClkDbgFreq  : unsigned (2 downto 0) := "111"; -- 
  constant xClkNone     : unsigned (5 downto 3) := "000"; -- 
  constant xClkXFreq    : unsigned (5 downto 3) := "001"; -- 
  constant xClkCh       : unsigned (5 downto 3) := "010"; -- 
  constant xClkIntClk   : unsigned (5 downto 3) := "011"; -- 
  constant xClkZFreq    : unsigned (5 downto 3) := "100"; -- 
  constant xClkZCh      : unsigned (5 downto 3) := "101"; -- 
  constant xClkSpindle  : unsigned (5 downto 3) := "110"; -- 
  constant xClkDbgFreq  : unsigned (5 downto 3) := "111"; -- 

  alias clkDbgFreqEna : std_logic is clkCtlreg(6); -- x40 enable debug frequency

  constant c_clkDbgFreqEna : integer :=  6; -- x40 enable debug frequency

-- sync control register

  constant synCtlSize : integer := 3;
  signal synCtlReg : unsigned(synCtlSize-1 downto 0);
  alias synPhaseInit : std_logic is synCtlreg(0); -- x01 init phase counter
  alias synEncInit   : std_logic is synCtlreg(1); -- x02 init encoder
  alias synEncEna    : std_logic is synCtlreg(2); -- x04 enable encoder

  constant c_synPhaseInit : integer :=  0; -- x01 init phase counter
  constant c_synEncInit   : integer :=  1; -- x02 init encoder
  constant c_synEncEna    : integer :=  2; -- x04 enable encoder

-- spindle control register

  constant spCtlSize : integer := 4;
  signal spCtlReg : unsigned(spCtlSize-1 downto 0);
  alias spInit       : std_logic is spCtlreg(0); -- x01 spindle init
  alias spEna        : std_logic is spCtlreg(1); -- x02 spindle enable
  alias spDir        : std_logic is spCtlreg(2); -- x04 spindle direction
  alias spJogEnable  : std_logic is spCtlreg(3); -- x08 spindle jog enable

  constant c_spInit       : integer :=  0; -- x01 spindle init
  constant c_spEna        : integer :=  1; -- x02 spindle enable
  constant c_spDir        : integer :=  2; -- x04 spindle direction
  constant c_spJogEnable  : integer :=  3; -- x08 spindle jog enable

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
  -- incr2 := 2 * (dy - dx);
  -- incr2 := 2 * dy - 2 * dx;
  incr2 := incr1 - 2 * dx;
  d := incr1 - dx;

  accelVal := 8;
  accelCount := 100;

  base := F_ZAxis_Base;

  loadParm(base + F_Sync_Base + F_Ld_D);
  loadValue(d, synBits);

  delay(1);

  loadParm(base + F_Sync_Base + F_Ld_Incr1);
  loadValue(incr1, synBits);

  delay(1);

  loadParm(base + F_Sync_Base + F_Ld_Incr2);
  loadValue(incr2, synBits);

  delay(1);

  loadParm(base + F_Sync_Base + F_Ld_Accel_Val);
  loadValue(accelVal, synBits);

  delay(1);

  loadParm(base + F_Sync_Base + F_Ld_Accel_Count);
  loadValue(accelCount, countBits);
  
  delay(1);

  loadParm(base + F_Sync_Base + F_Ld_A_Dist);
  loadValue(dist, distBits);

  delay(1);

  loadParm(base + F_Loc_Base + F_Ld_Loc);
  loadValue(loc, locBits);

  axisCtlReg := (others => '0');
  axisCtlReg(c_ctlInit) := '1';
  axisCtlReg(c_ctlSetLoc) := '1';
  loadParm(base + F_Ld_Axis_Ctl);
  ctl := to_integer(axisCtlReg);
  loadValue(ctl, axisCtlSize);

  axisCtlReg(c_ctlJogCmd) := '1';       --enable jog command
  
  axisCtlReg(c_ctlInit) := '0';
  axisCtlReg(c_ctlSetLoc) := '0';
  axisCtlReg(c_ctlStart) := '1';
  axisCtlReg(c_ctlDir) := '1';
  --ctlChDirect := '1';
  loadParm(base + F_Ld_Axis_Ctl);
  ctl := to_integer(axisCtlReg);
  loadValue(ctl, axisCtlSize);

  freq := 10-1;
  loadParm(F_Dbg_Freq_Base + F_Ld_Dbg_Freq);
  loadValue(freq, freqBits);

  dbgCount := 3000;
  loadParm(F_Dbg_Freq_Base + F_Ld_Dbg_Count);
  loadValue(dbgCount ,freqCountBits);

  clkCtlReg := (others => '0');
  zFreqSel := clkDbgFreq;                --to_unsigned(7, 3);
  clkDbgFreqEna := '1';
  
  loadParm(F_Ld_Clk_Ctl);
  ctl := to_integer(clkCtlReg);
  loadValue(ctl, clkCtlSize);

  delayQuad(500);
  -- delay(3600);
  loadParm(base + F_Sync_Base + F_Ld_A_Dist);
  loadValue(dist, distBits);
  -- delayQuad(500);
  delay(5000);

  clkCtlReg := (others => '0');
  clkCtlReg(2 downto 0) := clkDbgFreq;
  clkCtlReg(6) := '1';
  -- freqSel := clkDbgFreq;                --to_unsigned(7, 3);
  clkDbgFreqEna := '1';
  
  loadParm(F_Ld_Clk_Ctl);
  ctl := to_integer(clkCtlReg);
  loadValue(ctl, clkCtlSize);

  delay(10);

  loadParm(F_Rd_Status);
  readValue(readBits);

  loadParm(base + F_Loc_Base + F_Rd_Loc);
  readValue(readBits);

  delay(20);

  accelCount := 1000;

  loadParm(base + F_Sync_Base + F_Ld_Accel_Count);
  loadValue(accelCount, countBits);

  axisCtlReg := (others => '0');
  axisCtlReg(c_ctlInit) := '1';
  axisCtlReg(c_ctlSetLoc) := '1';
  loadParm(base + F_Ld_Axis_Ctl);
  ctl := to_integer(axisCtlReg);
  loadValue(ctl, axisCtlSize);

  axisCtlReg := (others => '0');
  axisCtlReg(c_ctlStart) := '1';
  axisCtlReg(c_ctlDir) := '1';
  loadParm(base + F_Ld_Axis_Ctl);
  ctl := to_integer(axisCtlReg);
  loadValue(ctl, axisCtlSize);

  loadParm(base + F_Rd_Axis_Ctl);
  readValue(readBits);

  delayQuad(50000);
  
  wait;
 end process;

end;
