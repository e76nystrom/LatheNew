--rFile

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package FpgaLatheBitsRec is

-- RiscV control register

type riscvCtlRec is record
 riscvInTest : std_logic;       --  2 0x4 riscv input test
 riscvSPI    : std_logic;       --  1 0x2 riscv spi active
 riscvData   : std_logic;       --  0 0x1 riscv data active
end record riscvCtlRec;

-- status register

type statusRec is record
 syncActive    : std_logic;     --  8 0x100 'SA' sync active
 spindleActive : std_logic;     --  7 0x080 'S+' spindle active
 stEStop       : std_logic;     --  6 0x040 'ES' emergency stop
 xAxisCurDir   : std_logic;     --  5 0x020 'Xd' x axis current dir
 xAxisDone     : std_logic;     --  4 0x010 'XD' x axis done
 xAxisEna      : std_logic;     --  3 0x008 'XE' x axis enable flag
 zAxisCurDir   : std_logic;     --  2 0x004 'Zd' z axis current dir
 zAxisDone     : std_logic;     --  1 0x002 'ZD' z axis done
 zAxisEna      : std_logic;     --  0 0x001 'ZE' z axis enable flag
end record statusRec;

-- input register

type inputsRec is record
 inSpare  : std_logic;          -- 12 0x1000 'SP' spare input
 inProbe  : std_logic;          -- 11 0x0800 'PR' probe input
 inXPlus  : std_logic;          -- 10 0x0400 'X+' x Limit Plus
 inXMinus : std_logic;          --  9 0x0200 'X-' x limit minus
 inXHome  : std_logic;          --  8 0x0100 'XH' x home switch
 inZPlus  : std_logic;          --  7 0x0080 'Z+' z Limit Plus
 inZMinus : std_logic;          --  6 0x0040 'Z-' z limit minus
 inZHome  : std_logic;          --  5 0x0020 'ZH' z home switch
 inPin15  : std_logic;          --  4 0x0010 '15' pin 15
 inPin13  : std_logic;          --  3 0x0008 '13' pin 13
 inPin12  : std_logic;          --  2 0x0004 '12' pin 12
 inPin11  : std_logic;          --  1 0x0002 '11' pin 11
 inPin10  : std_logic;          --  0 0x0001 '10' pin 10
end record inputsRec;

-- axis inputs

type axisInRec is record
 axProbe : std_logic;           --  3 0x8 axis probe
 axPlus  : std_logic;           --  2 0x4 axis plus limit
 axMinus : std_logic;           --  1 0x2 axis minus limit
 axHome  : std_logic;           --  0 0x1 axis home
end record axisInRec;

-- output register

type outputsRec is record
 outPin17 : std_logic;          --  2 0x4 pin 17
 outPin14 : std_logic;          --  1 0x2 pin 14
 outPin1  : std_logic;          --  0 0x1 pin 1
end record outputsRec;

-- pin out signals

type pinOutRec is record
 pinOut17 : std_logic;          -- 11 0x800 
 pinOut16 : std_logic;          -- 10 0x400 
 pinOut14 : std_logic;          --  9 0x200 
 pinOut1  : std_logic;          --  8 0x100 
 pinOut9  : std_logic;          --  7 0x080 
 pinOut8  : std_logic;          --  6 0x040 
 pinOut7  : std_logic;          --  5 0x020 
 pinOut6  : std_logic;          --  4 0x010 
 pinOut5  : std_logic;          --  3 0x008 x step
 pinOut4  : std_logic;          --  2 0x004 x dir
 pinOut3  : std_logic;          --  1 0x002 z step
 pinOut2  : std_logic;          --  0 0x001 z dir
end record pinOutRec;

-- jog control register

type jogRec is record
 jogBacklash   : std_logic;     --  1 0x2 jog backlash present
 jogContinuous : std_logic;     --  0 0x1 jog continuous mode
end record jogRec;

-- runOut control register

type runOutCtlRec is record
 runOutDir  : std_logic;        --  2 0x4 runout direction
 runOutEna  : std_logic;        --  1 0x2 runout enable
 runOutInit : std_logic;        --  0 0x1 runout init
end record runOutCtlRec;

-- axis control register

type axisCtlRec is record
 ctlUseLimits : std_logic;      -- 15 0x8000 'UL' use limits
 ctlProbe     : std_logic;      -- 14 0x4000 'PR' probe enable
 ctlHomePol   : std_logic;      -- 13 0x2000 'HP' home signal polarity
 ctlHome      : std_logic;      -- 12 0x1000 'HO' homing axis
 ctlJogMpg    : std_logic;      -- 11 0x0800 'JM' jog with mpg
 ctlJogCmd    : std_logic;      -- 10 0x0400 'JC' jog with commands
 ctlDistMode  : std_logic;      --  9 0x0200 'DM' distance udpdate mode
 ctlDroEnd    : std_logic;      --  8 0x0100 'DE' use dro to end move
 ctlSlave     : std_logic;      --  7 0x0080 'SL' slave ctl by other axis
 ctlChDirect  : std_logic;      --  6 0x0040 'CH' ch input direct
 ctlSetLoc    : std_logic;      --  5 0x0020 'SL' set location
 ctlDir       : std_logic;      --  4 0x0010 '+-' direction
 ctlWaitSync  : std_logic;      --  3 0x0008 'WS' wait for sync to start
 ctlBacklash  : std_logic;      --  2 0x0004 'BK' backlash move no pos upd
 ctlStart     : std_logic;      --  1 0x0002 'ST' start
 ctlInit      : std_logic;      --  0 0x0001 'IN' reset flag
end record axisCtlRec;

-- axis status register

type axisStatusRec is record
 axInFlag    : std_logic;       -- 10 0x400 'IF' axis in flag
 axInProbe   : std_logic;       --  9 0x200 'IP' axis in probe
 axInPlus    : std_logic;       --  8 0x100 'I+' axis in plus limit
 axInMinus   : std_logic;       --  7 0x080 'I-' axis in minus limit
 axInHome    : std_logic;       --  6 0x040 'IH' axis home
 axDoneProbe : std_logic;       --  5 0x020 'PR' axis done probe
 axDoneLimit : std_logic;       --  4 0x010 'LI' axis done limit
 axDoneHome  : std_logic;       --  3 0x008 'HO' axis done home
 axDoneDro   : std_logic;       --  2 0x004 'DR' axis done dro
 axDistZero  : std_logic;       --  1 0x002 'ZE' axis distance zero
 axDone      : std_logic;       --  0 0x001 'DN' axis done
end record axisStatusRec;

-- configuration control register

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
 cfgXMpgInv   : std_logic;      --  5 0x000020 x mpg dir inverted
 cfgZMpgInv   : std_logic;      --  4 0x000010 z mpg dir inverted
 cfgXDroInv   : std_logic;      --  3 0x000008 x dro dir inverted
 cfgZDroInv   : std_logic;      --  2 0x000004 z dro dir inverted
 cfgXDirInv   : std_logic;      --  1 0x000002 x dir inverted
 cfgZDirInv   : std_logic;      --  0 0x000001 z dir inverted
end record cfgCtlRec;

-- clock control register

type clkCtlRec is record
 clkDbgFreqEna : std_logic;     --  6 0x40 enable debug frequency
 xFreqSel      : std_logic_vector(2 downto 0);-- 5-3 x clock select
 zFreqSel      : std_logic_vector(2 downto 0);-- 2-0 z clock select
end record clkCtlRec;

-- clock shift values

 constant zFreqShift     : integer :=  0; -- x0001 z clock shift
 constant xFreqShift     : integer :=  0; -- x0001 x clock shift
 constant clkMask        : integer :=  0; -- x0001 clock mask

-- clock selection values

 constant clkNone        : std_logic_vector (2 downto 0) := "000"; -- 
 constant clkFreq        : std_logic_vector (2 downto 0) := "001"; -- 
 constant clkCh          : std_logic_vector (2 downto 0) := "010"; -- 
 constant clkIntClk      : std_logic_vector (2 downto 0) := "011"; -- 
 constant clkSlvFreq     : std_logic_vector (2 downto 0) := "100"; -- 
 constant clkSlvCh       : std_logic_vector (2 downto 0) := "101"; -- 
 constant clkSpindle     : std_logic_vector (2 downto 0) := "110"; -- 
 constant clkDbgFreq     : std_logic_vector (2 downto 0) := "111"; -- 

-- z clock values

 constant zClkNone       : std_logic_vector (2 downto 0) := "000"; -- 
 constant zClkZFreq      : std_logic_vector (2 downto 0) := "001"; -- 
 constant zClkCh         : std_logic_vector (2 downto 0) := "010"; -- 
 constant zClkIntClk     : std_logic_vector (2 downto 0) := "011"; -- 
 constant zClkXFreq      : std_logic_vector (2 downto 0) := "100"; -- 
 constant zClkXCh        : std_logic_vector (2 downto 0) := "101"; -- 
 constant zClkSpindle    : std_logic_vector (2 downto 0) := "110"; -- 
 constant zClkDbgFreq    : std_logic_vector (2 downto 0) := "111"; -- 

-- x clock values

 constant xClkNone       : std_logic_vector (2 downto 0) := "000"; -- 
 constant xClkXFreq      : std_logic_vector (2 downto 0) := "001"; -- 
 constant xClkCh         : std_logic_vector (2 downto 0) := "010"; -- 
 constant xClkIntClk     : std_logic_vector (2 downto 0) := "011"; -- 
 constant xClkZFreq      : std_logic_vector (2 downto 0) := "100"; -- 
 constant xClkZCh        : std_logic_vector (2 downto 0) := "101"; -- 
 constant xClkSpindle    : std_logic_vector (2 downto 0) := "110"; -- 
 constant xClkDbgFreq    : std_logic_vector (2 downto 0) := "111"; -- 

-- sync control register

type synCtlRec is record
 synEncClkSel : std_logic_vector(1 downto 0);-- 4-3 encoder clk sel
 synEncEna    : std_logic;      --  2 0x04 enable encoder
 synEncInit   : std_logic;      --  1 0x02 init encoder
 synPhaseInit : std_logic;      --  0 0x01 init phase counter
 clkMask      : std_logic;      --  0 0x01 clock mask
 xFreqShift   : std_logic;      --  0 0x01 x clock shift
 zFreqShift   : std_logic;      --  0 0x01 z clock shift
end record synCtlRec;

-- encoder clock shift

 constant encClkShift    : integer :=  0; -- x0001 enc clock shift

-- encoder clock values

 constant encClkNone     : std_logic_vector (1 downto 0) := "00"; -- 
 constant encClkCh       : std_logic_vector (1 downto 0) := "01"; -- 
 constant encClkSp       : std_logic_vector (1 downto 0) := "10"; -- 
 constant encClkDbg      : std_logic_vector (1 downto 0) := "11"; -- 

-- encoder clock values shifted

 constant synEncClkNone  : std_logic_vector (1 downto 0) := "00"; -- 
 constant synEncClkCh    : std_logic_vector (1 downto 0) := "01"; -- 
 constant synEncClkSp    : std_logic_vector (1 downto 0) := "10"; -- 
 constant synEncClkDbg   : std_logic_vector (1 downto 0) := "11"; -- 

-- spindle control register

type spCtlRec is record
 spJogEnable : std_logic;       --  3 0x08 spindle jog enable
 spDir       : std_logic;       --  2 0x04 spindle direction
 spEna       : std_logic;       --  1 0x02 spindle enable
 spInit      : std_logic;       --  0 0x01 spindle init
 encClkShift : std_logic;       --  0 0x01 enc clock shift
end record spCtlRec;

end package FpgaLatheBitsRec;
