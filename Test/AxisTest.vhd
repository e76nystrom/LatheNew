library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

use work.SimProc.all;
use work.RegDef.all;

entity A_AxisTest is
end A_AxisTest;
architecture behavior OF A_AxisTest is

 component Axis is
  generic (
   opBase : unsigned;
   opBits : positive;
   synBits : positive;
   posBits : positive;
   countBits : positive;
   distBits : positive;
   locBits : positive;
   outBits : positive;
   dbgBits : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in boolean;
   op : in unsigned(opBits-1 downto 0);
   load : in boolean;
   dshiftR : in boolean;
   opR : in unsigned(opBits-1 downto 0);
   copyR : in boolean;
   extInit : in std_logic;               --reset
   extEna : in std_logic;                --enable operation
   extUpdLoc : in std_logic;
   ch : in std_logic;
   encDir : in std_logic;
   sync : in std_logic;

   droQuad : in std_logic_vector(1 downto 0);
   droInvert : in std_logic;
   mpgQuad : in std_logic_vector(1 downto 0);
   jogInvert : in std_logic;
   currentDir : in std_logic;
   switches : in std_logic_vector(3 downto 0);
   eStop : in std_logic;

   dbgOut : out unsigned (dbgBits-1 downto 0);
   initOut : out std_logic;
   enaOut : out std_logic;
   updLocOut : out std_logic;
   dout : out std_logic;
   stepOut : out std_logic;
   dirOut : inout std_logic;
   doneInt : out std_logic
   );
 end Component;

 constant opBase : unsigned := F_ZAxis_Base;
 constant opBits : positive := 8;
 constant synBits : positive := 32;
 constant posBits : positive := 18;
 constant countBits : positive := 18;
 constant distBits : positive := 18;
 constant locBits : positive := 18;
 constant outBits : positive := 32;
 constant dbgBits : positive := 4;
 
 signal clk : std_logic := '0';
 signal din : std_logic := '0';
 signal dshift : boolean := false;
 signal op : unsigned(opBits-1 downto 0) := (opBits-1 downto 0 => '0');
 signal copy : boolean := false;
 signal load : boolean := false;
 signal extInit : std_logic := '0';
 signal extEna : std_logic := '0';
 signal extUpdLoc : std_logic := '0';
 signal ch : std_logic := '0';
 signal encDir : std_logic := '1';
 signal sync : std_logic := '0';

 signal droQuad : std_logic_vector(1 downto 0) := (1 downto 0 => '0');
 signal droInvert : std_logic := '0';
 signal mpgQuad : std_logic_vector(1 downto 0) := (1 downto 0 => '0');
 signal jogInvert : std_logic := '0';
 signal currentDir : std_logic := '0';
 signal switches : std_logic_vector(3 downto 0) := (3 downto 0 => '0');
 signal eStop : std_logic := '0';

 signal dbgOut : unsigned (dbgBits-1 downto 0) := (others => '0');
 signal initOut : std_logic := '0';
 signal enaOut : std_logic := '0';
 signal updLocOut : std_logic := '0';
 signal dout : std_logic := '0';
 signal stepOut : std_logic := '0';
 signal dirOut : std_logic := '0';
 signal doneInt : std_logic := '0';

begin

uut : Axis
  generic map (
   opBase => opBase,
   opBits => opBits,
   synBits => synBits,
   posBits => posBits,
   countBits => countBits,
   distBits => distBits,
   locBits => locBits,
   outBits => outBits,
   dbgBits => dbgBits
   )
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   load => load,
   dshiftR => dshift,
   opR => op,
   copyR => copy,
   extInit => extInit,
   extEna => extEna,
   extUpdLoc => extUpdLoc,
   ch => ch,
   encDir => encDir,
   sync => sync,

   droQuad => droQuad,
   droInvert => droInvert,
   mpgQuad => mpgQuad,
   jogInvert => jogInvert,
   currentDir => currentDir,
   switches => switches,
   eStop => eStop,

   dbgOut => dbgOut,
   initOut => initOut,
   enaOut => enaOut,
   updLocOut => updLocOut,
   dout => dout,
   stepOut => stepOut,
   dirOut => dirOut,
   doneInt => doneInt
   );

-- Clock process definitions

 clkProcess : process
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

 procedure delayCh(constant n : in integer) is
 begin
  for i in 0 to n-1 loop
   ch <= '1';
   delay(1, clk);
   ch <= '0';
   delay(4, clk);
  end loop;
 end procedure delayCh;

 procedure loadShift(variable value : in integer;
                     constant bits : in natural) is
  variable tmp: std_logic_vector(32-1 downto 0);
 begin
  tmp := conv_std_logic_vector(value, 32);
  dshift <= true;
  for i in 0 to bits-1 loop
   din <= tmp(bits - 1);
   wait until clk = '1';
   tmp := tmp(31-1 downto 0) & tmp(31);
   wait until clk = '0';
  end loop;
  dshift <= false;
  load <= true;
  delay(1);
  load <= false;
 end procedure loadShift;

 variable count : integer;

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

--(++ axisCtl
-- axis control register

 constant axisCtlSize : integer := 12;
 variable axisCtlReg : unsigned(axisCtlSize-1 downto 0) := (others => '0');
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
 alias ctlJogEna    : std_logic is axisCtlreg(9); -- x200 enable jog
 alias ctlHome      : std_logic is axisCtlreg(10); -- x400 homeing axis
 alias ctlIgnoreLim : std_logic is axisCtlreg(11); -- x800 ignore limits

--++)

 begin
-- hold reset state for 100 ns.
  wait for 100 ns;

  delay(10);

-- insert stimulus here

  dx := 2540 * 8;
  dy := 600;

  --dx := 87381248;
  --dy := 341258;

  dist := 100;
  loc := 5;

  incr1 := 2 * dy;
  incr2 := 2 * (dy - dx);
  d := incr1 - dx;

  -- accelVal := 8;
  -- accelCount := 99;
  accelVal := 2;
  accelCount := 400;

  op <= F_ZAxis_Base + F_Sync_Base + F_Ld_D;
  loadShift(d, synBits);

  delay(1);

  op <= F_ZAxis_Base + F_Sync_Base + F_Ld_Incr1;
  loadShift(incr1, synBits);

  delay(1);

  op <= F_ZAxis_Base + F_Sync_Base + F_Ld_Incr2;
  loadShift(incr2, synBits);

  delay(1);

  op <= F_ZAxis_Base + F_Sync_Base + F_Ld_Accel_Val;
  loadShift(accelVal, synBits);

  delay(1);

  op <= F_ZAxis_Base + F_Sync_Base + F_Ld_Accel_Count;
  loadShift(accelCount, countBits);
  
  delay(1);

  op <= F_ZAxis_Base + F_Sync_Base + F_Ld_Dist;
  loadShift(dist, distBits);

  delay(1);

  op <= F_ZAxis_Base + F_Sync_Base + F_Ld_Loc;
  loadShift(loc, locBits);

  op <= F_ZAxis_Base + F_Ld_Axis_Ctl;
  ctlInit := '1';
  ctlSetLoc := '1';
  ctl := to_integer(axisCtlReg);
  loadShift(ctl, axisCtlSize);

  ctlInit := '0';
  ctlSetLoc := '0';
  ctlStart := '1';
  ctlDir := '1';
  --ctlChDirect := '1';
  ctl := to_integer(axisCtlReg);
  loadShift(ctl, axisCtlSize);

  op <= F_Noop;

  delayCh(5000);
  wait;
 end process;

end;
