library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package FpgaLatheBits is

-- status register

 constant statusSize : integer := 2;
 signal statusReg : unsigned(statusSize-1 downto 0);
 alias zAxisDone  : std_logic is statusreg(0); -- x01 z axis done
 alias xAxisDone  : std_logic is statusreg(1); -- x02 x axis done

-- axis control register

 constant axisCtlSize : integer := 8;
 signal axisCtlReg : unsigned(axisCtlSize-1 downto 0);
 alias ctlInit    : std_logic is axisCtlreg(0); -- x01 reset flag
 alias ctlStart   : std_logic is axisCtlreg(1); -- x02 start
 alias ctlBacklash : std_logic is axisCtlreg(2); -- x04 backlash move no pos upd
 alias ctlWaitSync : std_logic is axisCtlreg(3); -- x08 wait for sync to start
 alias ctlDir     : std_logic is axisCtlreg(4); -- x10 direction
 alias ctlDirPos  : std_logic is axisCtlreg(4); -- x10 move in positive dir
 alias ctlSetLoc  : std_logic is axisCtlreg(5); -- x20 set location
 alias ctlChDirect : std_logic is axisCtlreg(6); -- x40 ch input direct
 alias ctlSlave   : std_logic is axisCtlreg(7); -- x80 slave controlled by other axis

-- configuration control register

 constant cfgCtlSize : integer := 6;
 signal cfgCtlReg : unsigned(cfgCtlSize-1 downto 0);
 alias cfgZDir    : std_logic is cfgCtlreg(0); -- x01 z direction inverted
 alias cfgXDir    : std_logic is cfgCtlreg(1); -- x02 x direction inverted
 alias cfgSpDir   : std_logic is cfgCtlreg(2); -- x04 spindle directiion inverted
 alias cfgEncDir  : std_logic is cfgCtlreg(3); -- x08 invert encoder direction
 alias cfgEnaEncDir : std_logic is cfgCtlreg(4); -- x10 enable encoder direction
 alias cfgGenSync : std_logic is cfgCtlreg(5); -- x20 no encoder generate sync pulse

-- clock control register

 constant clkCtlSize : integer := 7;
 signal clkCtlReg : unsigned(clkCtlSize-1 downto 0);
 alias zFreqSel   : std_logic is clkCtlreg(0); -- x01 z Frequency select
 alias zClkZFreq  : std_logic is clkCtlreg(0); -- x01 
 alias zClkCh     : std_logic is clkCtlreg(0); -- x01 
 alias zClkIntClk : std_logic is clkCtlreg(0); -- x01 
 alias zClkXStep  : std_logic is clkCtlreg(0); -- x01 
 alias zClkXFreq  : std_logic is clkCtlreg(0); -- x01 
 alias zClkDbgFreq : std_logic is clkCtlreg(0); -- x01 
 alias xFreqSel   : std_logic is clkCtlreg(3); -- x08 x Frequency select
 alias xClkXFreq  : std_logic is clkCtlreg(3); -- x08 
 alias xClkCh     : std_logic is clkCtlreg(3); -- x08 
 alias xClkIntClk : std_logic is clkCtlreg(3); -- x08 
 alias xClkZStep  : std_logic is clkCtlreg(3); -- x08 
 alias xClkZFreq  : std_logic is clkCtlreg(3); -- x08 
 alias xClkDbgFreq : std_logic is clkCtlreg(3); -- x08 
 alias clkDbgFreqEna : std_logic is clkCtlreg(6); -- x40 enable debug frequency

-- sync control register

 constant synCtlSize : integer := 3;
 signal synCtlReg : unsigned(synCtlSize-1 downto 0);
 alias synPhaseInit : std_logic is synCtlreg(0); -- x01 init phase counter
 alias synEncInit : std_logic is synCtlreg(1); -- x02 init encoder
 alias synEncEna  : std_logic is synCtlreg(2); -- x04 enable encoder

end FpgaLatheBits;

package body FpgaLatheBits is

end FpgaLatheBits;
