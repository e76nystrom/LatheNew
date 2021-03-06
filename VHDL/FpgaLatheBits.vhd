library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package FpgaLatheBits is

-- status register

 constant statusSize : integer := 11;
 signal statusReg : unsigned(statusSize-1 downto 0);
 alias zAxisEna     : std_logic is statusreg(0); -- x01 z axis enable flag
 alias zAxisDone    : std_logic is statusreg(1); -- x02 z axis done
 alias zAxisCurDir  : std_logic is statusreg(2); -- x04 z axis current dir
 alias xAxisDone    : std_logic is statusreg(3); -- x08 x axis done
 alias xAxisEna     : std_logic is statusreg(4); -- x10 x axis enable flag
 alias xAxisCurDir  : std_logic is statusreg(5); -- x20 x axis current dir
 alias stEStop      : std_logic is statusreg(6); -- x40 emergency stop
 alias spindleActive : std_logic is statusreg(7); -- x80 x axis current dir
 alias queNotEmpty  : std_logic is statusreg(8); -- x100 ctl queue not empty
 alias ctlBusy      : std_logic is statusreg(9); -- x200 controller busy
 alias syncActive   : std_logic is statusreg(10); -- x400 sync active

 constant c_zAxisEna     : integer :=  0; -- x01 z axis enable flag
 constant c_zAxisDone    : integer :=  1; -- x02 z axis done
 constant c_zAxisCurDir  : integer :=  2; -- x04 z axis current dir
 constant c_xAxisDone    : integer :=  3; -- x08 x axis done
 constant c_xAxisEna     : integer :=  4; -- x10 x axis enable flag
 constant c_xAxisCurDir  : integer :=  5; -- x20 x axis current dir
 constant c_stEStop      : integer :=  6; -- x40 emergency stop
 constant c_spindleActive : integer :=  7; -- x80 x axis current dir
 constant c_queNotEmpty  : integer :=  8; -- x100 ctl queue not empty
 constant c_ctlBusy      : integer :=  9; -- x200 controller busy
 constant c_syncActive   : integer := 10; -- x400 sync active

-- inputs register

 constant inputsSize : integer := 13;
 signal inputsReg : unsigned(inputsSize-1 downto 0);
 alias inZHome      : std_logic is inputsreg(0); -- x01 z home switch
 alias inZMinus     : std_logic is inputsreg(1); -- x02 z limit minus
 alias inZPlus      : std_logic is inputsreg(2); -- x04 z Limit Plus
 alias inXHome      : std_logic is inputsreg(3); -- x08 x home switch
 alias inXMinus     : std_logic is inputsreg(4); -- x10 x limit minus
 alias inXPlus      : std_logic is inputsreg(5); -- x20 x Limit Plus
 alias inSpare      : std_logic is inputsreg(6); -- x40 spare input
 alias inProbe      : std_logic is inputsreg(7); -- x80 probe input
 alias inPin10      : std_logic is inputsreg(8); -- x100 pin 10
 alias inPin11      : std_logic is inputsreg(9); -- x200 pin 11
 alias inPin12      : std_logic is inputsreg(10); -- x400 pin 12
 alias inPin13      : std_logic is inputsreg(11); -- x800 pin 13
 alias inPin15      : std_logic is inputsreg(12); -- x1000 pin 15

 constant c_inZHome      : integer :=  0; -- x01 z home switch
 constant c_inZMinus     : integer :=  1; -- x02 z limit minus
 constant c_inZPlus      : integer :=  2; -- x04 z Limit Plus
 constant c_inXHome      : integer :=  3; -- x08 x home switch
 constant c_inXMinus     : integer :=  4; -- x10 x limit minus
 constant c_inXPlus      : integer :=  5; -- x20 x Limit Plus
 constant c_inSpare      : integer :=  6; -- x40 spare input
 constant c_inProbe      : integer :=  7; -- x80 probe input
 constant c_inPin10      : integer :=  8; -- x100 pin 10
 constant c_inPin11      : integer :=  9; -- x200 pin 11
 constant c_inPin12      : integer := 10; -- x400 pin 12
 constant c_inPin13      : integer := 11; -- x800 pin 13
 constant c_inPin15      : integer := 12; -- x1000 pin 15

-- run control register

 constant runSize : integer := 3;
 signal runReg : unsigned(runSize-1 downto 0);
 alias runEna       : std_logic is runreg(0); -- x01 run from controller data
 alias runInit      : std_logic is runreg(1); -- x02 initialize controller
 alias readerInit   : std_logic is runreg(2); -- x04 initialize reader

 constant c_runEna       : integer :=  0; -- x01 run from controller data
 constant c_runInit      : integer :=  1; -- x02 initialize controller
 constant c_readerInit   : integer :=  2; -- x04 initialize reader

-- jog control register

 constant jogSize : integer := 2;
 signal jogReg : unsigned(jogSize-1 downto 0);
 alias jogContinuous : std_logic is jogreg(0); -- x01 jog continuous mode
 alias jogBacklash  : std_logic is jogreg(1); -- x02 jog backlash present

 constant c_jogContinuous : integer :=  0; -- x01 jog continuous mode
 constant c_jogBacklash  : integer :=  1; -- x02 jog backlash present

-- axis control register

 constant axisCtlSize : integer := 12;
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
 alias ctlJogEna    : std_logic is axisCtlreg(9); -- x200 enable jog
 alias ctlHome      : std_logic is axisCtlreg(10); -- x400 homeing axis
 alias ctlIgnoreLim : std_logic is axisCtlreg(11); -- x800 ignore limits

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
 constant c_ctlJogEna    : integer :=  9; -- x200 enable jog
 constant c_ctlHome      : integer := 10; -- x400 homeing axis
 constant c_ctlIgnoreLim : integer := 11; -- x800 ignore limits

-- axis status register

 constant axisStatusSize : integer := 4;
 signal axisStatusReg : unsigned(axisStatusSize-1 downto 0);
 alias axDoneDist   : std_logic is axisStatusreg(0); -- x01 axis done distance
 alias axDoneDro    : std_logic is axisStatusreg(1); -- x02 axis done dro
 alias axDoneHome   : std_logic is axisStatusreg(2); -- x04 axis done home
 alias axDoneLimit  : std_logic is axisStatusreg(3); -- x08 axis done limit

 constant c_axDoneDist   : integer :=  0; -- x01 axis done distance
 constant c_axDoneDro    : integer :=  1; -- x02 axis done dro
 constant c_axDoneHome   : integer :=  2; -- x04 axis done home
 constant c_axDoneLimit  : integer :=  3; -- x08 axis done limit

-- configuration control register

 constant cfgCtlSize : integer := 13;
 signal cfgCtlReg : unsigned(cfgCtlSize-1 downto 0);
 alias cfgZDirInv   : std_logic is cfgCtlreg(0); -- x01 z direction inverted
 alias cfgXDirInv   : std_logic is cfgCtlreg(1); -- x02 x direction inverted
 alias cfgZDroInv   : std_logic is cfgCtlreg(2); -- x04 z dro direction inverted
 alias cfgXDroInv   : std_logic is cfgCtlreg(3); -- x08 x dro direction inverted
 alias cfgZJogInv   : std_logic is cfgCtlreg(4); -- x10 z jog direction inverted
 alias cfgXJogInv   : std_logic is cfgCtlreg(5); -- x20 x jog direction inverted
 alias cfgSpDirInv  : std_logic is cfgCtlreg(6); -- x40 spindle directiion inverted
 alias cfgEncDirInv : std_logic is cfgCtlreg(7); -- x80 invert encoder direction
 alias cfgEStopEna  : std_logic is cfgCtlreg(8); -- x100 estop enable
 alias cfgEStopInv  : std_logic is cfgCtlreg(9); -- x200 estop invert
 alias cfgEnaEncDir : std_logic is cfgCtlreg(10); -- x400 enable encoder direction
 alias cfgGenSync   : std_logic is cfgCtlreg(11); -- x800 no encoder generate sync pulse
 alias cfgPWMEna    : std_logic is cfgCtlreg(12); -- x1000 pwm enable

 constant c_cfgZDirInv   : integer :=  0; -- x01 z direction inverted
 constant c_cfgXDirInv   : integer :=  1; -- x02 x direction inverted
 constant c_cfgZDroInv   : integer :=  2; -- x04 z dro direction inverted
 constant c_cfgXDroInv   : integer :=  3; -- x08 x dro direction inverted
 constant c_cfgZJogInv   : integer :=  4; -- x10 z jog direction inverted
 constant c_cfgXJogInv   : integer :=  5; -- x20 x jog direction inverted
 constant c_cfgSpDirInv  : integer :=  6; -- x40 spindle directiion inverted
 constant c_cfgEncDirInv : integer :=  7; -- x80 invert encoder direction
 constant c_cfgEStopEna  : integer :=  8; -- x100 estop enable
 constant c_cfgEStopInv  : integer :=  9; -- x200 estop invert
 constant c_cfgEnaEncDir : integer := 10; -- x400 enable encoder direction
 constant c_cfgGenSync   : integer := 11; -- x800 no encoder generate sync pulse
 constant c_cfgPWMEna    : integer := 12; -- x1000 pwm enable

-- clock control register

 constant clkCtlSize : integer := 7;
 signal clkCtlReg : unsigned(clkCtlSize-1 downto 0);
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

end FpgaLatheBits;

package body FpgaLatheBits is

end FpgaLatheBits;
