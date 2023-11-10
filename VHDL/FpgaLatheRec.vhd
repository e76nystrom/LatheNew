library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package FpgaLatheBitsRec is

type riscvCtlRec is record
 riscvSPI  : std_logic;         --  1 0x2 riscv spi active
 riscvData : std_logic;         --  0 0x1 riscv data active
end record riscvCtlRec;

type statusRec is record
 syncActive    : std_logic;     -- 10 0x400 'SA' sync active
 ctlBusy       : std_logic;     --  9 0x200 'CB' controller busy
 queNotEmpty   : std_logic;     --  8 0x100 'Q+' ctl queue not empty
 spindleActive : std_logic;     --  7 0x080 'S+' spindle active
 stEStop       : std_logic;     --  6 0x040 'ES' emergency stop
 xAxisCurDir   : std_logic;     --  5 0x020 'Xd' x axis current dir
 xAxisDone     : std_logic;     --  4 0x010 'XD' x axis done
 xAxisEna      : std_logic;     --  3 0x008 'XE' x axis enable flag
 zAxisCurDir   : std_logic;     --  2 0x004 'Zd' z axis current dir
 zAxisDone     : std_logic;     --  1 0x002 'ZD' z axis done
 zAxisEna      : std_logic;     --  0 0x001 'ZE' z axis enable flag
end record statusRec;

type inputsRec is record
 inPin15  : std_logic;          -- 12 0x1000 pin 15
 inPin13  : std_logic;          -- 11 0x0800 pin 13
 inPin12  : std_logic;          -- 10 0x0400 pin 12
 inPin11  : std_logic;          --  9 0x0200 pin 11
 inPin10  : std_logic;          --  8 0x0100 pin 10
 inProbe  : std_logic;          --  7 0x0080 probe input
 inSpare  : std_logic;          --  6 0x0040 spare input
 inXPlus  : std_logic;          --  5 0x0020 x Limit Plus
 inXMinus : std_logic;          --  4 0x0010 x limit minus
 inXHome  : std_logic;          --  3 0x0008 x home switch
 inZPlus  : std_logic;          --  2 0x0004 z Limit Plus
 inZMinus : std_logic;          --  1 0x0002 z limit minus
 inZHome  : std_logic;          --  0 0x0001 z home switch
end record inputsRec;

type runRec is record
 readerInit : std_logic;        --  2 0x4 initialize reader
 runInit    : std_logic;        --  1 0x2 initialize controller
 runEna     : std_logic;        --  0 0x1 run from controller data
end record runRec;

type jogRec is record
 jogBacklash   : std_logic;     --  1 0x2 jog backlash present
 jogContinuous : std_logic;     --  0 0x1 jog continuous mode
end record jogRec;

type axisCtlRec is record
 ctlUseLimits : std_logic;      -- 13 0x2000 use limits
 ctlHome      : std_logic;      -- 12 0x1000 homing axis
 ctlJogMpg    : std_logic;      -- 11 0x0800 jog with mpg
 ctlJogCmd    : std_logic;      -- 10 0x0400 jog with commands
 ctlDistMode  : std_logic;      --  9 0x0200 distance udpdate mode
 ctlDroEnd    : std_logic;      --  8 0x0100 use dro to end move
 ctlSlave     : std_logic;      --  7 0x0080 slave ctl by other axis
 ctlChDirect  : std_logic;      --  6 0x0040 ch input direct
 ctlSetLoc    : std_logic;      --  5 0x0020 set location
 ctlDir       : std_logic;      --  4 0x0010 direction
 ctlWaitSync  : std_logic;      --  3 0x0008 wait for sync to start
 ctlBacklash  : std_logic;      --  2 0x0004 backlash move no pos upd
 ctlStart     : std_logic;      --  1 0x0002 start
 ctlInit      : std_logic;      --  0 0x0001 reset flag
end record axisCtlRec;

type axisStatusRec is record
 axDoneLimit : std_logic;       --  3 0x8 axis done limit
 axDoneHome  : std_logic;       --  2 0x4 axis done home
 axDoneDro   : std_logic;       --  1 0x2 axis done dro
 axDoneDist  : std_logic;       --  0 0x1 axis done distance
end record axisStatusRec;

type cfgCtlRec is record
 cfgDroStep   : std_logic;      -- 20 0x100000 step pulse to dro
 cfgPwmEna    : std_logic;      -- 19 0x080000 pwm enable
 cfgGenSync   : std_logic;      -- 18 0x040000 generate sync pulse
 cfgEnaEncDir : std_logic;      -- 17 0x020000 enable encoder dir
 cfgEStopInv  : std_logic;      -- 16 0x010000 estop invert
 cfgEStopEna  : std_logic;      -- 15 0x008000 estop enable
 cfgEncDirInv : std_logic;      -- 14 0x004000 invert encoder dir
 cfgProbeInv  : std_logic;      -- 13 0x002000 probe inverted
 cfgXPlusInv  : std_logic;      -- 12 0x001000 x plus inverted
 cfgXMinusInv : std_logic;      -- 11 0x000800 x minus inverted
 cfgXHomeInv  : std_logic;      -- 10 0x000400 x home inverted
 cfgZPlusInv  : std_logic;      --  9 0x000200 z plus inverted
 cfgZMinusInv : std_logic;      --  8 0x000100 z minus inverted
 cfgZHomeInv  : std_logic;      --  7 0x000080 z home inverted
 cfgSpDirInv  : std_logic;      --  6 0x000040 spindle dir inverted
 cfgXJogInv   : std_logic;      --  5 0x000020 x jog dir inverted
 cfgZJogInv   : std_logic;      --  4 0x000010 z jog dir inverted
 cfgXDroInv   : std_logic;      --  3 0x000008 x dro dir inverted
 cfgZDroInv   : std_logic;      --  2 0x000004 z dro dir inverted
 cfgXDirInv   : std_logic;      --  1 0x000002 x dir inverted
 cfgZDirInv   : std_logic;      --  0 0x000001 z dir inverted
end record cfgCtlRec;

type clkCtlRec is record
 clkDbgFreqEna : std_logic;     --  6 0x40 enable debug frequency
 xFreqShift    : std_logic;     --  0 0x01 x Frequency shift
 zFreqShift    : std_logic;     --  0 0x01 z Frequency shift
 xFreqSel      : std_logic_vector(2 downto 0);-- 5-3 x Frequency select
 zFreqSel      : std_logic_vector(2 downto 0);-- 2-0 z Frequency select
end record clkCtlRec;

 constant clkNone      : std_logic_vector (2 downto 0) := "000"; -- 
 constant clkFreq      : std_logic_vector (2 downto 0) := "001"; -- 
 constant clkCh        : std_logic_vector (2 downto 0) := "010"; -- 
 constant clkIntClk    : std_logic_vector (2 downto 0) := "011"; -- 
 constant clkSlvFreq   : std_logic_vector (2 downto 0) := "100"; -- 
 constant clkSlvCh     : std_logic_vector (2 downto 0) := "101"; -- 
 constant clkSpindle   : std_logic_vector (2 downto 0) := "110"; -- 
 constant clkDbgFreq   : std_logic_vector (2 downto 0) := "111"; -- 
 constant zClkNone     : std_logic_vector (2 downto 0) := "000"; -- 
 constant zClkZFreq    : std_logic_vector (2 downto 0) := "001"; -- 
 constant zClkCh       : std_logic_vector (2 downto 0) := "010"; -- 
 constant zClkIntClk   : std_logic_vector (2 downto 0) := "011"; -- 
 constant zClkXFreq    : std_logic_vector (2 downto 0) := "100"; -- 
 constant zClkXCh      : std_logic_vector (2 downto 0) := "101"; -- 
 constant zClkSpindle  : std_logic_vector (2 downto 0) := "110"; -- 
 constant zClkDbgFreq  : std_logic_vector (2 downto 0) := "111"; -- 
 constant xClkNone     : std_logic_vector (2 downto 0) := "000"; -- 
 constant xClkXFreq    : std_logic_vector (2 downto 0) := "001"; -- 
 constant xClkCh       : std_logic_vector (2 downto 0) := "010"; -- 
 constant xClkIntClk   : std_logic_vector (2 downto 0) := "011"; -- 
 constant xClkZFreq    : std_logic_vector (2 downto 0) := "100"; -- 
 constant xClkZCh      : std_logic_vector (2 downto 0) := "101"; -- 
 constant xClkSpindle  : std_logic_vector (2 downto 0) := "110"; -- 
 constant xClkDbgFreq  : std_logic_vector (2 downto 0) := "111"; -- 

type synCtlRec is record
 synEncEna    : std_logic;      --  2 0x4 enable encoder
 synEncInit   : std_logic;      --  1 0x2 init encoder
 synPhaseInit : std_logic;      --  0 0x1 init phase counter
end record synCtlRec;

type spCtlRec is record
 spJogEnable : std_logic;       --  3 0x8 spindle jog enable
 spDir       : std_logic;       --  2 0x4 spindle direction
 spEna       : std_logic;       --  1 0x2 spindle enable
 spInit      : std_logic;       --  0 0x1 spindle init
end record spCtlRec;

end package FpgaLatheBitsRec;
