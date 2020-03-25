library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package FpgaLatheBits is

-- status register

 constant statusSize : integer := 7;
 signal statusReg : unsigned(statusSize-1 downto 0);
 alias zAxisEna     : std_logic is statusreg(0); -- x01 z axis enable flag
 alias zAxisDone    : std_logic is statusreg(1); -- x02 z axis done
 alias xAxisEna     : std_logic is statusreg(2); -- x04 x axis enable flag
 alias xAxisDone    : std_logic is statusreg(3); -- x08 x axis done
 alias queEmpty     : std_logic is statusreg(4); -- x10 controller queue empty
 alias ctlIdle      : std_logic is statusreg(5); -- x20 controller idle
 alias syncActive   : std_logic is statusreg(6); -- x40 sync active

 constant c_zAxisEna     : integer :=  0; -- x01 z axis enable flag
 constant c_zAxisDone    : integer :=  1; -- x02 z axis done
 constant c_xAxisEna     : integer :=  2; -- x04 x axis enable flag
 constant c_xAxisDone    : integer :=  3; -- x08 x axis done
 constant c_queEmpty     : integer :=  4; -- x10 controller queue empty
 constant c_ctlIdle      : integer :=  5; -- x20 controller idle
 constant c_syncActive   : integer :=  6; -- x40 sync active

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

 constant axisCtlSize : integer := 9;
 signal axisCtlReg : unsigned(axisCtlSize-1 downto 0);
 alias ctlInit      : std_logic is axisCtlreg(0); -- x01 reset flag
 alias ctlStart     : std_logic is axisCtlreg(1); -- x02 start
 alias ctlBacklash  : std_logic is axisCtlreg(2); -- x04 backlash move no pos upd
 alias ctlWaitSync  : std_logic is axisCtlreg(3); -- x08 wait for sync to start
 alias ctlDir       : std_logic is axisCtlreg(4); -- x10 direction
 alias ctlDirPos    : std_logic is axisCtlreg(4); -- x10 move in positive dir
 alias ctlSetLoc    : std_logic is axisCtlreg(5); -- x20 set location
 alias ctlChDirect  : std_logic is axisCtlreg(6); -- x40 ch input direct
 alias ctlSlave     : std_logic is axisCtlreg(7); -- x80 slave controlled by other axis
 alias ctlDroEnd    : std_logic is axisCtlreg(8); -- x100 use dro to end move

 constant c_ctlInit      : integer :=  0; -- x01 reset flag
 constant c_ctlStart     : integer :=  1; -- x02 start
 constant c_ctlBacklash  : integer :=  2; -- x04 backlash move no pos upd
 constant c_ctlWaitSync  : integer :=  3; -- x08 wait for sync to start
 constant c_ctlDir       : integer :=  4; -- x10 direction
 constant c_ctlDirPos    : integer :=  4; -- x10 move in positive dir
 constant c_ctlSetLoc    : integer :=  5; -- x20 set location
 constant c_ctlChDirect  : integer :=  6; -- x40 ch input direct
 constant c_ctlSlave     : integer :=  7; -- x80 slave controlled by other axis
 constant c_ctlDroEnd    : integer :=  8; -- x100 use dro to end move

-- configuration control register

 constant cfgCtlSize : integer := 8;
 signal cfgCtlReg : unsigned(cfgCtlSize-1 downto 0);
 alias cfgZDir      : std_logic is cfgCtlreg(0); -- x01 z direction inverted
 alias cfgXDir      : std_logic is cfgCtlreg(1); -- x02 x direction inverted
 alias cfgZDro      : std_logic is cfgCtlreg(2); -- x04 z dro direction inverted
 alias cfgXDro      : std_logic is cfgCtlreg(3); -- x08 x dro direction inverted
 alias cfgSpDir     : std_logic is cfgCtlreg(4); -- x10 spindle directiion inverted
 alias cfgEncDir    : std_logic is cfgCtlreg(5); -- x20 invert encoder direction
 alias cfgEnaEncDir : std_logic is cfgCtlreg(6); -- x40 enable encoder direction
 alias cfgGenSync   : std_logic is cfgCtlreg(7); -- x80 no encoder generate sync pulse

 constant c_cfgZDir      : integer :=  0; -- x01 z direction inverted
 constant c_cfgXDir      : integer :=  1; -- x02 x direction inverted
 constant c_cfgZDro      : integer :=  2; -- x04 z dro direction inverted
 constant c_cfgXDro      : integer :=  3; -- x08 x dro direction inverted
 constant c_cfgSpDir     : integer :=  4; -- x10 spindle directiion inverted
 constant c_cfgEncDir    : integer :=  5; -- x20 invert encoder direction
 constant c_cfgEnaEncDir : integer :=  6; -- x40 enable encoder direction
 constant c_cfgGenSync   : integer :=  7; -- x80 no encoder generate sync pulse

-- clock control register

 constant clkCtlSize : integer := 7;
 signal clkCtlReg : unsigned(clkCtlSize-1 downto 0);
 alias clkFreq      : std_logic is clkCtlreg(0); -- x01 
 alias clkCh        : std_logic is clkCtlreg(0); -- x01 
 alias clkIntClk    : std_logic is clkCtlreg(0); -- x01 
 alias clkSlvFreq   : std_logic is clkCtlreg(0); -- x01 
 alias clkSlvCh     : std_logic is clkCtlreg(0); -- x01 
 alias clkSpare     : std_logic is clkCtlreg(0); -- x01 
 alias clkDbgFreq   : std_logic is clkCtlreg(0); -- x01 
 alias zFreqSel     : std_logic is clkCtlreg(0); -- x01 z Frequency select
 alias zClkZFreq    : std_logic is clkCtlreg(0); -- x01 
 alias zClkCh       : std_logic is clkCtlreg(0); -- x01 
 alias zClkIntClk   : std_logic is clkCtlreg(0); -- x01 
 alias zClkXFreq    : std_logic is clkCtlreg(0); -- x01 
 alias zClkXCh      : std_logic is clkCtlreg(0); -- x01 
 alias zClkSpare    : std_logic is clkCtlreg(0); -- x01 
 alias zClkDbgFreq  : std_logic is clkCtlreg(0); -- x01 
 alias xFreqSel     : std_logic is clkCtlreg(3); -- x08 x Frequency select
 alias xClkXFreq    : std_logic is clkCtlreg(3); -- x08 
 alias xClkCh       : std_logic is clkCtlreg(3); -- x08 
 alias xClkIntClk   : std_logic is clkCtlreg(3); -- x08 
 alias xClkZFreq    : std_logic is clkCtlreg(3); -- x08 
 alias xClkZCh      : std_logic is clkCtlreg(3); -- x08 
 alias xClkSpare    : std_logic is clkCtlreg(3); -- x08 
 alias xClkDbgFreq  : std_logic is clkCtlreg(3); -- x08 
 alias clkDbgFreqEna : std_logic is clkCtlreg(6); -- x40 enable debug frequency

 constant c_clkFreq      : integer :=  0; -- x01 
 constant c_clkCh        : integer :=  0; -- x01 
 constant c_clkIntClk    : integer :=  0; -- x01 
 constant c_clkSlvFreq   : integer :=  0; -- x01 
 constant c_clkSlvCh     : integer :=  0; -- x01 
 constant c_clkSpare     : integer :=  0; -- x01 
 constant c_clkDbgFreq   : integer :=  0; -- x01 
 constant c_zFreqSel     : integer :=  0; -- x01 z Frequency select
 constant c_zClkZFreq    : integer :=  0; -- x01 
 constant c_zClkCh       : integer :=  0; -- x01 
 constant c_zClkIntClk   : integer :=  0; -- x01 
 constant c_zClkXFreq    : integer :=  0; -- x01 
 constant c_zClkXCh      : integer :=  0; -- x01 
 constant c_zClkSpare    : integer :=  0; -- x01 
 constant c_zClkDbgFreq  : integer :=  0; -- x01 
 constant c_xFreqSel     : integer :=  3; -- x08 x Frequency select
 constant c_xClkXFreq    : integer :=  3; -- x08 
 constant c_xClkCh       : integer :=  3; -- x08 
 constant c_xClkIntClk   : integer :=  3; -- x08 
 constant c_xClkZFreq    : integer :=  3; -- x08 
 constant c_xClkZCh      : integer :=  3; -- x08 
 constant c_xClkSpare    : integer :=  3; -- x08 
 constant c_xClkDbgFreq  : integer :=  3; -- x08 
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

end FpgaLatheBits;

package body FpgaLatheBits is

end FpgaLatheBits;
