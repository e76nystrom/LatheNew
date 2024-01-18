-- xFile

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package FpgaLatheBits is

-- RiscV control register

 constant riscvCtlSize : integer := 3;
 signal riscvCtlReg : unsigned(riscvCtlSize-1 downto 0);
 --variable riscvCtlReg : unsigned(riscvCtlSize-1 downto 0);

 alias    riscvData          : std_logic is riscvCtlReg( 0); -- x0001 riscv data active
 alias    riscvSPI           : std_logic is riscvCtlReg( 1); -- x0002 riscv spi active
 alias    riscvInTest        : std_logic is riscvCtlReg( 2); -- x0004 riscv input test

 constant c_riscvData        : integer :=  0; -- x0001 riscv data active
 constant c_riscvSPI         : integer :=  1; -- x0002 riscv spi active
 constant c_riscvInTest      : integer :=  2; -- x0004 riscv input test

-- status register

 constant statusSize : integer := 10;
 signal statusReg : unsigned(statusSize-1 downto 0);
 --variable statusReg : unsigned(statusSize-1 downto 0);

 alias    zAxisEna           : std_logic is statusReg( 0); -- x0001 'ZE' z axis enable flag
 alias    zAxisDone          : std_logic is statusReg( 1); -- x0002 'ZD' z axis done
 alias    zAxisCurDir        : std_logic is statusReg( 2); -- x0004 'Zd' z axis current dir
 alias    xAxisEna           : std_logic is statusReg( 3); -- x0008 'XE' x axis enable flag
 alias    xAxisDone          : std_logic is statusReg( 4); -- x0010 'XD' x axis done
 alias    xAxisCurDir        : std_logic is statusReg( 5); -- x0020 'Xd' x axis current dir
 alias    stEStop            : std_logic is statusReg( 6); -- x0040 'ES' emergency stop
 alias    spindleActive      : std_logic is statusReg( 7); -- x0080 'S+' spindle active
 alias    syncActive         : std_logic is statusReg( 8); -- x0100 'SA' sync active
 alias    encoderDir         : std_logic is statusReg( 9); -- x0200 'ED' encoder direction

 constant c_zAxisEna         : integer :=  0; -- x0001 'ZE' z axis enable flag
 constant c_zAxisDone        : integer :=  1; -- x0002 'ZD' z axis done
 constant c_zAxisCurDir      : integer :=  2; -- x0004 'Zd' z axis current dir
 constant c_xAxisEna         : integer :=  3; -- x0008 'XE' x axis enable flag
 constant c_xAxisDone        : integer :=  4; -- x0010 'XD' x axis done
 constant c_xAxisCurDir      : integer :=  5; -- x0020 'Xd' x axis current dir
 constant c_stEStop          : integer :=  6; -- x0040 'ES' emergency stop
 constant c_spindleActive    : integer :=  7; -- x0080 'S+' spindle active
 constant c_syncActive       : integer :=  8; -- x0100 'SA' sync active
 constant c_encoderDir       : integer :=  9; -- x0200 'ED' encoder direction

-- input register

 constant inputsSize : integer := 13;
 signal inputsReg : unsigned(inputsSize-1 downto 0);
 --variable inputsReg : unsigned(inputsSize-1 downto 0);

 alias    inPin10            : std_logic is inputsReg( 0); -- x0001 '10' pin 10
 alias    inPin11            : std_logic is inputsReg( 1); -- x0002 '11' pin 11
 alias    inPin12            : std_logic is inputsReg( 2); -- x0004 '12' pin 12
 alias    inPin13            : std_logic is inputsReg( 3); -- x0008 '13' pin 13
 alias    inPin15            : std_logic is inputsReg( 4); -- x0010 '15' pin 15
 alias    inZHome            : std_logic is inputsReg( 5); -- x0020 'ZH' z home switch
 alias    inZMinus           : std_logic is inputsReg( 6); -- x0040 'Z-' z limit minus
 alias    inZPlus            : std_logic is inputsReg( 7); -- x0080 'Z+' z Limit Plus
 alias    inXHome            : std_logic is inputsReg( 8); -- x0100 'XH' x home switch
 alias    inXMinus           : std_logic is inputsReg( 9); -- x0200 'X-' x limit minus
 alias    inXPlus            : std_logic is inputsReg(10); -- x0400 'X+' x Limit Plus
 alias    inProbe            : std_logic is inputsReg(11); -- x0800 'PR' probe input
 alias    inSpare            : std_logic is inputsReg(12); -- x1000 'SP' spare input

 constant c_inPin10          : integer :=  0; -- x0001 '10' pin 10
 constant c_inPin11          : integer :=  1; -- x0002 '11' pin 11
 constant c_inPin12          : integer :=  2; -- x0004 '12' pin 12
 constant c_inPin13          : integer :=  3; -- x0008 '13' pin 13
 constant c_inPin15          : integer :=  4; -- x0010 '15' pin 15
 constant c_inZHome          : integer :=  5; -- x0020 'ZH' z home switch
 constant c_inZMinus         : integer :=  6; -- x0040 'Z-' z limit minus
 constant c_inZPlus          : integer :=  7; -- x0080 'Z+' z Limit Plus
 constant c_inXHome          : integer :=  8; -- x0100 'XH' x home switch
 constant c_inXMinus         : integer :=  9; -- x0200 'X-' x limit minus
 constant c_inXPlus          : integer := 10; -- x0400 'X+' x Limit Plus
 constant c_inProbe          : integer := 11; -- x0800 'PR' probe input
 constant c_inSpare          : integer := 12; -- x1000 'SP' spare input

-- axis inputs

 constant axisInSize : integer := 4;
 signal axisInReg : unsigned(axisInSize-1 downto 0);
 --variable axisInReg : unsigned(axisInSize-1 downto 0);

 alias    axHome             : std_logic is axisInReg( 0); -- x0001 axis home
 alias    axMinus            : std_logic is axisInReg( 1); -- x0002 axis minus limit
 alias    axPlus             : std_logic is axisInReg( 2); -- x0004 axis plus limit
 alias    axProbe            : std_logic is axisInReg( 3); -- x0008 axis probe

 constant c_axHome           : integer :=  0; -- x0001 axis home
 constant c_axMinus          : integer :=  1; -- x0002 axis minus limit
 constant c_axPlus           : integer :=  2; -- x0004 axis plus limit
 constant c_axProbe          : integer :=  3; -- x0008 axis probe

-- output register

 constant outputsSize : integer := 2;
 signal outputsReg : unsigned(outputsSize-1 downto 0);
 --variable outputsReg : unsigned(outputsSize-1 downto 0);

 alias    outPin1            : std_logic is outputsReg( 0); -- x0001 pin 1
 alias    outPin14           : std_logic is outputsReg( 1); -- x0002 pin 14

 constant c_outPin1          : integer :=  0; -- x0001 pin 1
 constant c_outPin14         : integer :=  1; -- x0002 pin 14

-- pin out signals

 constant pinOutSize : integer := 12;
 signal pinOutReg : unsigned(pinOutSize-1 downto 0);
 --variable pinOutReg : unsigned(pinOutSize-1 downto 0);

 alias    pinOut2            : std_logic is pinOutReg( 0); -- x0001 z dir
 alias    pinOut3            : std_logic is pinOutReg( 1); -- x0002 z step
 alias    pinOut4            : std_logic is pinOutReg( 2); -- x0004 x dir
 alias    pinOut5            : std_logic is pinOutReg( 3); -- x0008 x step
 alias    pinOut6            : std_logic is pinOutReg( 4); -- x0010 
 alias    pinOut7            : std_logic is pinOutReg( 5); -- x0020 
 alias    pinOut8            : std_logic is pinOutReg( 6); -- x0040 
 alias    pinOut9            : std_logic is pinOutReg( 7); -- x0080 
 alias    pinOut1            : std_logic is pinOutReg( 8); -- x0100 
 alias    pinOut14           : std_logic is pinOutReg( 9); -- x0200 
 alias    pinOut16           : std_logic is pinOutReg(10); -- x0400 
 alias    pinOut17           : std_logic is pinOutReg(11); -- x0800 

 constant c_pinOut2          : integer :=  0; -- x0001 z dir
 constant c_pinOut3          : integer :=  1; -- x0002 z step
 constant c_pinOut4          : integer :=  2; -- x0004 x dir
 constant c_pinOut5          : integer :=  3; -- x0008 x step
 constant c_pinOut6          : integer :=  4; -- x0010 
 constant c_pinOut7          : integer :=  5; -- x0020 
 constant c_pinOut8          : integer :=  6; -- x0040 
 constant c_pinOut9          : integer :=  7; -- x0080 
 constant c_pinOut1          : integer :=  8; -- x0100 
 constant c_pinOut14         : integer :=  9; -- x0200 
 constant c_pinOut16         : integer := 10; -- x0400 
 constant c_pinOut17         : integer := 11; -- x0800 

-- jog control register

 constant jogSize : integer := 2;
 signal jogReg : unsigned(jogSize-1 downto 0);
 --variable jogReg : unsigned(jogSize-1 downto 0);

 alias    jogContinuous      : std_logic is jogReg( 0); -- x0001 jog continuous mode
 alias    jogBacklash        : std_logic is jogReg( 1); -- x0002 jog backlash present

 constant c_jogContinuous    : integer :=  0; -- x0001 jog continuous mode
 constant c_jogBacklash      : integer :=  1; -- x0002 jog backlash present

-- runOut control register

 constant runOutCtlSize : integer := 3;
 signal runOutCtlReg : unsigned(runOutCtlSize-1 downto 0);
 --variable runOutCtlReg : unsigned(runOutCtlSize-1 downto 0);

 alias    runOutInit         : std_logic is runOutCtlReg( 0); -- x0001 runout init
 alias    runOutEna          : std_logic is runOutCtlReg( 1); -- x0002 runout enable
 alias    runOutDir          : std_logic is runOutCtlReg( 2); -- x0004 runout direction

 constant c_runOutInit       : integer :=  0; -- x0001 runout init
 constant c_runOutEna        : integer :=  1; -- x0002 runout enable
 constant c_runOutDir        : integer :=  2; -- x0004 runout direction

-- axis control register

 constant axisCtlSize : integer := 16;
 signal axisCtlReg : unsigned(axisCtlSize-1 downto 0);
 --variable axisCtlReg : unsigned(axisCtlSize-1 downto 0);

 alias    ctlInit            : std_logic is axisCtlReg( 0); -- x0001 'IN' reset flag
 alias    ctlStart           : std_logic is axisCtlReg( 1); -- x0002 'ST' start
 alias    ctlBacklash        : std_logic is axisCtlReg( 2); -- x0004 'BK' backlash move no pos upd
 alias    ctlWaitSync        : std_logic is axisCtlReg( 3); -- x0008 'WS' wait for sync to start
 alias    ctlDir             : std_logic is axisCtlReg( 4); -- x0010 '+-' direction
 alias    ctlSetLoc          : std_logic is axisCtlReg( 5); -- x0020 'SL' set location
 alias    ctlChDirect        : std_logic is axisCtlReg( 6); -- x0040 'CH' ch input direct
 alias    ctlSlave           : std_logic is axisCtlReg( 7); -- x0080 'SL' slave ctl by other axis
 alias    ctlDroEnd          : std_logic is axisCtlReg( 8); -- x0100 'DE' use dro to end move
 alias    ctlDistMode        : std_logic is axisCtlReg( 9); -- x0200 'DM' distance udpdate mode
 alias    ctlJogCmd          : std_logic is axisCtlReg(10); -- x0400 'JC' jog with commands
 alias    ctlJogMpg          : std_logic is axisCtlReg(11); -- x0800 'JM' jog with mpg
 alias    ctlHome            : std_logic is axisCtlReg(12); -- x1000 'HO' homing axis
 alias    ctlHomePol         : std_logic is axisCtlReg(13); -- x2000 'HP' home signal polarity
 alias    ctlProbe           : std_logic is axisCtlReg(14); -- x4000 'PR' probe enable
 alias    ctlUseLimits       : std_logic is axisCtlReg(15); -- x8000 'UL' use limits

 constant c_ctlInit          : integer :=  0; -- x0001 'IN' reset flag
 constant c_ctlStart         : integer :=  1; -- x0002 'ST' start
 constant c_ctlBacklash      : integer :=  2; -- x0004 'BK' backlash move no pos upd
 constant c_ctlWaitSync      : integer :=  3; -- x0008 'WS' wait for sync to start
 constant c_ctlDir           : integer :=  4; -- x0010 '+-' direction
 constant c_ctlSetLoc        : integer :=  5; -- x0020 'SL' set location
 constant c_ctlChDirect      : integer :=  6; -- x0040 'CH' ch input direct
 constant c_ctlSlave         : integer :=  7; -- x0080 'SL' slave ctl by other axis
 constant c_ctlDroEnd        : integer :=  8; -- x0100 'DE' use dro to end move
 constant c_ctlDistMode      : integer :=  9; -- x0200 'DM' distance udpdate mode
 constant c_ctlJogCmd        : integer := 10; -- x0400 'JC' jog with commands
 constant c_ctlJogMpg        : integer := 11; -- x0800 'JM' jog with mpg
 constant c_ctlHome          : integer := 12; -- x1000 'HO' homing axis
 constant c_ctlHomePol       : integer := 13; -- x2000 'HP' home signal polarity
 constant c_ctlProbe         : integer := 14; -- x4000 'PR' probe enable
 constant c_ctlUseLimits     : integer := 15; -- x8000 'UL' use limits

-- axis status register

 constant axisStatusSize : integer := 11;
 signal axisStatusReg : unsigned(axisStatusSize-1 downto 0);
 --variable axisStatusReg : unsigned(axisStatusSize-1 downto 0);

 alias    axDone             : std_logic is axisStatusReg( 0); -- x0001 'DN' axis done
 alias    axDistZero         : std_logic is axisStatusReg( 1); -- x0002 'ZE' axis distance zero
 alias    axDoneDro          : std_logic is axisStatusReg( 2); -- x0004 'DR' axis done dro
 alias    axDoneHome         : std_logic is axisStatusReg( 3); -- x0008 'HO' axis done home
 alias    axDoneLimit        : std_logic is axisStatusReg( 4); -- x0010 'LI' axis done limit
 alias    axDoneProbe        : std_logic is axisStatusReg( 5); -- x0020 'PR' axis done probe
 alias    axInHome           : std_logic is axisStatusReg( 6); -- x0040 'IH' axis home
 alias    axInMinus          : std_logic is axisStatusReg( 7); -- x0080 'I-' axis in minus limit
 alias    axInPlus           : std_logic is axisStatusReg( 8); -- x0100 'I+' axis in plus limit
 alias    axInProbe          : std_logic is axisStatusReg( 9); -- x0200 'IP' axis in probe
 alias    axInFlag           : std_logic is axisStatusReg(10); -- x0400 'IF' axis in flag

 constant c_axDone           : integer :=  0; -- x0001 'DN' axis done
 constant c_axDistZero       : integer :=  1; -- x0002 'ZE' axis distance zero
 constant c_axDoneDro        : integer :=  2; -- x0004 'DR' axis done dro
 constant c_axDoneHome       : integer :=  3; -- x0008 'HO' axis done home
 constant c_axDoneLimit      : integer :=  4; -- x0010 'LI' axis done limit
 constant c_axDoneProbe      : integer :=  5; -- x0020 'PR' axis done probe
 constant c_axInHome         : integer :=  6; -- x0040 'IH' axis home
 constant c_axInMinus        : integer :=  7; -- x0080 'I-' axis in minus limit
 constant c_axInPlus         : integer :=  8; -- x0100 'I+' axis in plus limit
 constant c_axInProbe        : integer :=  9; -- x0200 'IP' axis in probe
 constant c_axInFlag         : integer := 10; -- x0400 'IF' axis in flag

-- configuration control register

 constant cfgCtlSize : integer := 21;
 signal cfgCtlReg : unsigned(cfgCtlSize-1 downto 0);
 --variable cfgCtlReg : unsigned(cfgCtlSize-1 downto 0);

 alias    cfgZDirInv         : std_logic is cfgCtlReg( 0); -- x0001 z dir inverted
 alias    cfgXDirInv         : std_logic is cfgCtlReg( 1); -- x0002 x dir inverted
 alias    cfgZDroInv         : std_logic is cfgCtlReg( 2); -- x0004 z dro dir inverted
 alias    cfgXDroInv         : std_logic is cfgCtlReg( 3); -- x0008 x dro dir inverted
 alias    cfgZMpgInv         : std_logic is cfgCtlReg( 4); -- x0010 z mpg dir inverted
 alias    cfgXMpgInv         : std_logic is cfgCtlReg( 5); -- x0020 x mpg dir inverted
 alias    cfgSpDirInv        : std_logic is cfgCtlReg( 6); -- x0040 spindle dir inverted
 alias    cfgZHomeInv        : std_logic is cfgCtlReg( 7); -- x0080 z home inverted
 alias    cfgZMinusInv       : std_logic is cfgCtlReg( 8); -- x0100 z minus inverted
 alias    cfgZPlusInv        : std_logic is cfgCtlReg( 9); -- x0200 z plus inverted
 alias    cfgXHomeInv        : std_logic is cfgCtlReg(10); -- x0400 x home inverted
 alias    cfgXMinusInv       : std_logic is cfgCtlReg(11); -- x0800 x minus inverted
 alias    cfgXPlusInv        : std_logic is cfgCtlReg(12); -- x1000 x plus inverted
 alias    cfgProbeInv        : std_logic is cfgCtlReg(13); -- x2000 probe inverted
 alias    cfgEncDirInv       : std_logic is cfgCtlReg(14); -- x4000 invert encoder dir
 alias    cfgEStopEna        : std_logic is cfgCtlReg(15); -- x8000 estop enable
 alias    cfgEStopInv        : std_logic is cfgCtlReg(16); -- x10000 estop invert
 alias    cfgEnaEncDir       : std_logic is cfgCtlReg(17); -- x20000 enable encoder dir
 alias    cfgGenSync         : std_logic is cfgCtlReg(18); -- x40000 generate sync pulse
 alias    cfgPwmEna          : std_logic is cfgCtlReg(19); -- x80000 pwm enable
 alias    cfgDroStep         : std_logic is cfgCtlReg(20); -- x100000 step pulse to dro

 constant c_cfgZDirInv       : integer :=  0; -- x0001 z dir inverted
 constant c_cfgXDirInv       : integer :=  1; -- x0002 x dir inverted
 constant c_cfgZDroInv       : integer :=  2; -- x0004 z dro dir inverted
 constant c_cfgXDroInv       : integer :=  3; -- x0008 x dro dir inverted
 constant c_cfgZMpgInv       : integer :=  4; -- x0010 z mpg dir inverted
 constant c_cfgXMpgInv       : integer :=  5; -- x0020 x mpg dir inverted
 constant c_cfgSpDirInv      : integer :=  6; -- x0040 spindle dir inverted
 constant c_cfgZHomeInv      : integer :=  7; -- x0080 z home inverted
 constant c_cfgZMinusInv     : integer :=  8; -- x0100 z minus inverted
 constant c_cfgZPlusInv      : integer :=  9; -- x0200 z plus inverted
 constant c_cfgXHomeInv      : integer := 10; -- x0400 x home inverted
 constant c_cfgXMinusInv     : integer := 11; -- x0800 x minus inverted
 constant c_cfgXPlusInv      : integer := 12; -- x1000 x plus inverted
 constant c_cfgProbeInv      : integer := 13; -- x2000 probe inverted
 constant c_cfgEncDirInv     : integer := 14; -- x4000 invert encoder dir
 constant c_cfgEStopEna      : integer := 15; -- x8000 estop enable
 constant c_cfgEStopInv      : integer := 16; -- x10000 estop invert
 constant c_cfgEnaEncDir     : integer := 17; -- x20000 enable encoder dir
 constant c_cfgGenSync       : integer := 18; -- x40000 generate sync pulse
 constant c_cfgPwmEna        : integer := 19; -- x80000 pwm enable
 constant c_cfgDroStep       : integer := 20; -- x100000 step pulse to dro

-- clock control register

 constant clkCtlSize : integer := 7;
 signal clkCtlReg : unsigned(clkCtlSize-1 downto 0);
 --variable clkCtlReg : unsigned(clkCtlSize-1 downto 0);

 alias    zFreqSel           : unsigned is clkCtlreg(2 downto 0); -- x0001 z clock select
 alias    xFreqSel           : unsigned is clkCtlreg(5 downto 3); -- x0008 x clock select
 alias    clkDbgFreqEna      : std_logic is clkCtlReg( 6); -- x0040 enable debug frequency
 alias    clkDbgSyncEna      : std_logic is clkCtlReg( 6); -- x0040 enable debug sync

 constant c_clkDbgFreqEna    : integer :=  6; -- x0040 enable debug frequency
 constant c_clkDbgSyncEna    : integer :=  6; -- x0040 enable debug sync

-- clock shift values

 constant c_zFreqShift       : integer :=  0; -- x0001 z clock shift
 constant c_xFreqShift       : integer :=  0; -- x0001 x clock shift
 constant c_clkMask          : integer :=  0; -- x0001 clock mask

-- clock selection values

 constant clkNone            : unsigned (2 downto 0) := "000"; -- 
 constant clkFreq            : unsigned (2 downto 0) := "001"; -- 
 constant clkCh              : unsigned (2 downto 0) := "010"; -- 
 constant clkIntClk          : unsigned (2 downto 0) := "011"; -- 
 constant clkSlvFreq         : unsigned (2 downto 0) := "100"; -- 
 constant clkSlvCh           : unsigned (2 downto 0) := "101"; -- 
 constant clkSpindle         : unsigned (2 downto 0) := "110"; -- 
 constant clkDbgFreq         : unsigned (2 downto 0) := "111"; -- 

-- z clock values

 constant zClkNone           : unsigned (2 downto 0) := "000"; -- 
 constant zClkZFreq          : unsigned (2 downto 0) := "001"; -- 
 constant zClkCh             : unsigned (2 downto 0) := "010"; -- 
 constant zClkIntClk         : unsigned (2 downto 0) := "011"; -- 
 constant zClkXFreq          : unsigned (2 downto 0) := "100"; -- 
 constant zClkXCh            : unsigned (2 downto 0) := "101"; -- 
 constant zClkSpindle        : unsigned (2 downto 0) := "110"; -- 
 constant zClkDbgFreq        : unsigned (2 downto 0) := "111"; -- 

-- x clock values

 constant xClkNone           : unsigned (2 downto 0) := "000"; -- 
 constant xClkXFreq          : unsigned (2 downto 0) := "001"; -- 
 constant xClkCh             : unsigned (2 downto 0) := "010"; -- 
 constant xClkIntClk         : unsigned (2 downto 0) := "011"; -- 
 constant xClkZFreq          : unsigned (2 downto 0) := "100"; -- 
 constant xClkZCh            : unsigned (2 downto 0) := "101"; -- 
 constant xClkSpindle        : unsigned (2 downto 0) := "110"; -- 
 constant xClkDbgFreq        : unsigned (2 downto 0) := "111"; -- 

-- sync control register

 constant synCtlSize : integer := 5;
 signal synCtlReg : unsigned(synCtlSize-1 downto 0);
 --variable synCtlReg : unsigned(synCtlSize-1 downto 0);

 alias    synPhaseInit       : std_logic is synCtlReg( 0); -- x0001 init phase counter
 alias    synEncInit         : std_logic is synCtlReg( 1); -- x0002 init encoder
 alias    synEncEna          : std_logic is synCtlReg( 2); -- x0004 enable encoder
 alias    synEncClkSel       : unsigned is synCtlreg(4 downto 3); -- x0008 encoder clk sel

 constant c_synPhaseInit     : integer :=  0; -- x0001 init phase counter
 constant c_synEncInit       : integer :=  1; -- x0002 init encoder
 constant c_synEncEna        : integer :=  2; -- x0004 enable encoder

-- encoder clock shift

 constant c_encClkShift      : integer :=  0; -- x0001 enc clock shift

-- encoder clock values

 constant encClkNone         : unsigned (1 downto 0) := "00"; -- 
 constant encClkCh           : unsigned (1 downto 0) := "01"; -- 
 constant encClkSp           : unsigned (1 downto 0) := "10"; -- 
 constant encClkDbg          : unsigned (1 downto 0) := "11"; -- 

-- encoder clock values shifted

 constant synEncClkNone      : unsigned (1 downto 0) := "00"; -- 
 constant synEncClkCh        : unsigned (1 downto 0) := "01"; -- 
 constant synEncClkSp        : unsigned (1 downto 0) := "10"; -- 
 constant synEncClkDbg       : unsigned (1 downto 0) := "11"; -- 

-- spindle control register

 constant spCtlSize : integer := 3;
 signal spCtlReg : unsigned(spCtlSize-1 downto 0);
 --variable spCtlReg : unsigned(spCtlSize-1 downto 0);

 alias    spInit             : std_logic is spCtlReg( 0); -- x0001 spindle init
 alias    spEna              : std_logic is spCtlReg( 1); -- x0002 spindle enable
 alias    spDir              : std_logic is spCtlReg( 2); -- x0004 spindle direction

 constant c_spInit           : integer :=  0; -- x0001 spindle init
 constant c_spEna            : integer :=  1; -- x0002 spindle enable
 constant c_spDir            : integer :=  2; -- x0004 spindle direction

end FpgaLatheBits;

package body FpgaLatheBits is

end FpgaLatheBits;
