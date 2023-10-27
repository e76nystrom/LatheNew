library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.FpgaLatheBitsRec.all;

package FpgaLatheBitsFunc is

constant riscvCtlSize : integer := 2;
subType riscvCtlVec is std_logic_vector(riscvCtlSize-1 downto 0);
constant riscvCtlZero : riscvCtlVec := (others => '0');

function riscvCtlToVec(val : riscvCtlRec)
 return riscvCtlVec;

function riscvCtlToRec(val : riscvCtlVec)
return riscvCtlRec;

function riscvCtlToRecS(val : std_logic_vector(riscvCtlSize-1 downto 0))
return riscvCtlRec;

constant statusSize : integer := 11;
subType statusVec is std_logic_vector(statusSize-1 downto 0);
constant statusZero : statusVec := (others => '0');

function statusToVec(val : statusRec)
 return statusVec;

function statusToRec(val : statusVec)
return statusRec;

function statusToRecS(val : std_logic_vector(statusSize-1 downto 0))
return statusRec;

constant inputsSize : integer := 13;
subType inputsVec is std_logic_vector(inputsSize-1 downto 0);
constant inputsZero : inputsVec := (others => '0');

function inputsToVec(val : inputsRec)
 return inputsVec;

function inputsToRec(val : inputsVec)
return inputsRec;

function inputsToRecS(val : std_logic_vector(inputsSize-1 downto 0))
return inputsRec;

constant runSize : integer := 3;
subType runVec is std_logic_vector(runSize-1 downto 0);
constant runZero : runVec := (others => '0');

function runToVec(val : runRec)
 return runVec;

function runToRec(val : runVec)
return runRec;

function runToRecS(val : std_logic_vector(runSize-1 downto 0))
return runRec;

constant jogSize : integer := 2;
subType jogVec is std_logic_vector(jogSize-1 downto 0);
constant jogZero : jogVec := (others => '0');

function jogToVec(val : jogRec)
 return jogVec;

function jogToRec(val : jogVec)
return jogRec;

function jogToRecS(val : std_logic_vector(jogSize-1 downto 0))
return jogRec;

constant axisCtlSize : integer := 13;
subType axisCtlVec is std_logic_vector(axisCtlSize-1 downto 0);
constant axisCtlZero : axisCtlVec := (others => '0');

function axisCtlToVec(val : axisCtlRec)
 return axisCtlVec;

function axisCtlToRec(val : axisCtlVec)
return axisCtlRec;

function axisCtlToRecS(val : std_logic_vector(axisCtlSize-1 downto 0))
return axisCtlRec;

constant axisStatusSize : integer := 4;
subType axisStatusVec is std_logic_vector(axisStatusSize-1 downto 0);
constant axisStatusZero : axisStatusVec := (others => '0');

function axisStatusToVec(val : axisStatusRec)
 return axisStatusVec;

function axisStatusToRec(val : axisStatusVec)
return axisStatusRec;

function axisStatusToRecS(val : std_logic_vector(axisStatusSize-1 downto 0))
return axisStatusRec;

constant cfgCtlSize : integer := 21;
subType cfgCtlVec is std_logic_vector(cfgCtlSize-1 downto 0);
constant cfgCtlZero : cfgCtlVec := (others => '0');

function cfgCtlToVec(val : cfgCtlRec)
 return cfgCtlVec;

function cfgCtlToRec(val : cfgCtlVec)
return cfgCtlRec;

function cfgCtlToRecS(val : std_logic_vector(cfgCtlSize-1 downto 0))
return cfgCtlRec;

constant clkCtlSize : integer := 7;
subType clkCtlVec is std_logic_vector(clkCtlSize-1 downto 0);
constant clkCtlZero : clkCtlVec := (others => '0');

function clkCtlToVec(val : clkCtlRec)
 return clkCtlVec;

function clkCtlToRec(val : clkCtlVec)
return clkCtlRec;

function clkCtlToRecS(val : std_logic_vector(clkCtlSize-1 downto 0))
return clkCtlRec;

constant synCtlSize : integer := 3;
subType synCtlVec is std_logic_vector(synCtlSize-1 downto 0);
constant synCtlZero : synCtlVec := (others => '0');

function synCtlToVec(val : synCtlRec)
 return synCtlVec;

function synCtlToRec(val : synCtlVec)
return synCtlRec;

function synCtlToRecS(val : std_logic_vector(synCtlSize-1 downto 0))
return synCtlRec;

constant spCtlSize : integer := 4;
subType spCtlVec is std_logic_vector(spCtlSize-1 downto 0);
constant spCtlZero : spCtlVec := (others => '0');

function spCtlToVec(val : spCtlRec)
 return spCtlVec;

function spCtlToRec(val : spCtlVec)
return spCtlRec;

function spCtlToRecS(val : std_logic_vector(spCtlSize-1 downto 0))
return spCtlRec;

end FpgaLatheBitsFunc;

package body FpgaLatheBitsFunc is

function riscvCtlToVec(val : riscvCtlRec) return riscvCtlVec is
 variable rtnVec : riscvCtlVec;
begin
 rtnVec := val.riscvSPI  & val.riscvData;
 return rtnVec;
end function;

function riscvCtlToRec(val : riscvCtlVec) return riscvCtlRec is
 variable rtnRec : riscvCtlRec;
begin
 rtnRec.riscvSPI  := val(1);
 rtnRec.riscvData := val(0);

 return rtnRec;
end function;

function riscvCtlToRecS(val : std_logic_vector(riscvCtlSize-1 downto 0))
 return riscvCtlRec is
 variable rtnRec : riscvCtlRec;
begin
 rtnRec.riscvSPI  := val(1);
 rtnRec.riscvData := val(0);

 return rtnRec;
end function;

function statusToVec(val : statusRec) return statusVec is
 variable rtnVec : statusVec;
begin
 rtnVec := val.syncActive    & val.ctlBusy       & val.queNotEmpty   &
           val.spindleActive & val.stEStop       & val.xAxisCurDir   &
           val.xAxisDone     & val.xAxisEna      & val.zAxisCurDir   &
           val.zAxisDone     & val.zAxisEna;
 return rtnVec;
end function;

function statusToRec(val : statusVec) return statusRec is
 variable rtnRec : statusRec;
begin
 rtnRec.syncActive    := val(10);
 rtnRec.ctlBusy       := val(9);
 rtnRec.queNotEmpty   := val(8);
 rtnRec.spindleActive := val(7);
 rtnRec.stEStop       := val(6);
 rtnRec.xAxisCurDir   := val(5);
 rtnRec.xAxisDone     := val(4);
 rtnRec.xAxisEna      := val(3);
 rtnRec.zAxisCurDir   := val(2);
 rtnRec.zAxisDone     := val(1);
 rtnRec.zAxisEna      := val(0);

 return rtnRec;
end function;

function statusToRecS(val : std_logic_vector(statusSize-1 downto 0))
 return statusRec is
 variable rtnRec : statusRec;
begin
 rtnRec.syncActive    := val(10);
 rtnRec.ctlBusy       := val(9);
 rtnRec.queNotEmpty   := val(8);
 rtnRec.spindleActive := val(7);
 rtnRec.stEStop       := val(6);
 rtnRec.xAxisCurDir   := val(5);
 rtnRec.xAxisDone     := val(4);
 rtnRec.xAxisEna      := val(3);
 rtnRec.zAxisCurDir   := val(2);
 rtnRec.zAxisDone     := val(1);
 rtnRec.zAxisEna      := val(0);

 return rtnRec;
end function;

function inputsToVec(val : inputsRec) return inputsVec is
 variable rtnVec : inputsVec;
begin
 rtnVec := val.inPin15  & val.inPin13  & val.inPin12  & val.inPin11  &
           val.inPin10  & val.inProbe  & val.inSpare  & val.inXPlus  &
           val.inXMinus & val.inXHome  & val.inZPlus  & val.inZMinus &
           val.inZHome;
 return rtnVec;
end function;

function inputsToRec(val : inputsVec) return inputsRec is
 variable rtnRec : inputsRec;
begin
 rtnRec.inPin15  := val(12);
 rtnRec.inPin13  := val(11);
 rtnRec.inPin12  := val(10);
 rtnRec.inPin11  := val(9);
 rtnRec.inPin10  := val(8);
 rtnRec.inProbe  := val(7);
 rtnRec.inSpare  := val(6);
 rtnRec.inXPlus  := val(5);
 rtnRec.inXMinus := val(4);
 rtnRec.inXHome  := val(3);
 rtnRec.inZPlus  := val(2);
 rtnRec.inZMinus := val(1);
 rtnRec.inZHome  := val(0);

 return rtnRec;
end function;

function inputsToRecS(val : std_logic_vector(inputsSize-1 downto 0))
 return inputsRec is
 variable rtnRec : inputsRec;
begin
 rtnRec.inPin15  := val(12);
 rtnRec.inPin13  := val(11);
 rtnRec.inPin12  := val(10);
 rtnRec.inPin11  := val(9);
 rtnRec.inPin10  := val(8);
 rtnRec.inProbe  := val(7);
 rtnRec.inSpare  := val(6);
 rtnRec.inXPlus  := val(5);
 rtnRec.inXMinus := val(4);
 rtnRec.inXHome  := val(3);
 rtnRec.inZPlus  := val(2);
 rtnRec.inZMinus := val(1);
 rtnRec.inZHome  := val(0);

 return rtnRec;
end function;

function runToVec(val : runRec) return runVec is
 variable rtnVec : runVec;
begin
 rtnVec := val.readerInit & val.runInit    & val.runEna;
 return rtnVec;
end function;

function runToRec(val : runVec) return runRec is
 variable rtnRec : runRec;
begin
 rtnRec.readerInit := val(2);
 rtnRec.runInit    := val(1);
 rtnRec.runEna     := val(0);

 return rtnRec;
end function;

function runToRecS(val : std_logic_vector(runSize-1 downto 0))
 return runRec is
 variable rtnRec : runRec;
begin
 rtnRec.readerInit := val(2);
 rtnRec.runInit    := val(1);
 rtnRec.runEna     := val(0);

 return rtnRec;
end function;

function jogToVec(val : jogRec) return jogVec is
 variable rtnVec : jogVec;
begin
 rtnVec := val.jogBacklash   & val.jogContinuous;
 return rtnVec;
end function;

function jogToRec(val : jogVec) return jogRec is
 variable rtnRec : jogRec;
begin
 rtnRec.jogBacklash   := val(1);
 rtnRec.jogContinuous := val(0);

 return rtnRec;
end function;

function jogToRecS(val : std_logic_vector(jogSize-1 downto 0))
 return jogRec is
 variable rtnRec : jogRec;
begin
 rtnRec.jogBacklash   := val(1);
 rtnRec.jogContinuous := val(0);

 return rtnRec;
end function;

function axisCtlToVec(val : axisCtlRec) return axisCtlVec is
 variable rtnVec : axisCtlVec;
begin
 rtnVec := val.ctlUseLimits & val.ctlHome      & val.ctlJogMpg    &
           val.ctlJogCmd    & val.ctlDroEnd    & val.ctlSlave     &
           val.ctlChDirect  & val.ctlSetLoc    & val.ctlDir       &
           val.ctlWaitSync  & val.ctlBacklash  & val.ctlStart     &
           val.ctlInit;
 return rtnVec;
end function;

function axisCtlToRec(val : axisCtlVec) return axisCtlRec is
 variable rtnRec : axisCtlRec;
begin
 rtnRec.ctlUseLimits := val(12);
 rtnRec.ctlHome      := val(11);
 rtnRec.ctlJogMpg    := val(10);
 rtnRec.ctlJogCmd    := val(9);
 rtnRec.ctlDroEnd    := val(8);
 rtnRec.ctlSlave     := val(7);
 rtnRec.ctlChDirect  := val(6);
 rtnRec.ctlSetLoc    := val(5);
 rtnRec.ctlDir       := val(4);
 rtnRec.ctlWaitSync  := val(3);
 rtnRec.ctlBacklash  := val(2);
 rtnRec.ctlStart     := val(1);
 rtnRec.ctlInit      := val(0);

 return rtnRec;
end function;

function axisCtlToRecS(val : std_logic_vector(axisCtlSize-1 downto 0))
 return axisCtlRec is
 variable rtnRec : axisCtlRec;
begin
 rtnRec.ctlUseLimits := val(12);
 rtnRec.ctlHome      := val(11);
 rtnRec.ctlJogMpg    := val(10);
 rtnRec.ctlJogCmd    := val(9);
 rtnRec.ctlDroEnd    := val(8);
 rtnRec.ctlSlave     := val(7);
 rtnRec.ctlChDirect  := val(6);
 rtnRec.ctlSetLoc    := val(5);
 rtnRec.ctlDir       := val(4);
 rtnRec.ctlWaitSync  := val(3);
 rtnRec.ctlBacklash  := val(2);
 rtnRec.ctlStart     := val(1);
 rtnRec.ctlInit      := val(0);

 return rtnRec;
end function;

function axisStatusToVec(val : axisStatusRec) return axisStatusVec is
 variable rtnVec : axisStatusVec;
begin
 rtnVec := val.axDoneLimit & val.axDoneHome  & val.axDoneDro   &
           val.axDoneDist;
 return rtnVec;
end function;

function axisStatusToRec(val : axisStatusVec) return axisStatusRec is
 variable rtnRec : axisStatusRec;
begin
 rtnRec.axDoneLimit := val(3);
 rtnRec.axDoneHome  := val(2);
 rtnRec.axDoneDro   := val(1);
 rtnRec.axDoneDist  := val(0);

 return rtnRec;
end function;

function axisStatusToRecS(val : std_logic_vector(axisStatusSize-1 downto 0))
 return axisStatusRec is
 variable rtnRec : axisStatusRec;
begin
 rtnRec.axDoneLimit := val(3);
 rtnRec.axDoneHome  := val(2);
 rtnRec.axDoneDro   := val(1);
 rtnRec.axDoneDist  := val(0);

 return rtnRec;
end function;

function cfgCtlToVec(val : cfgCtlRec) return cfgCtlVec is
 variable rtnVec : cfgCtlVec;
begin
 rtnVec := val.cfgDroStep   & val.cfgPwmEna    & val.cfgGenSync   &
           val.cfgEnaEncDir & val.cfgEStopInv  & val.cfgEStopEna  &
           val.cfgEncDirInv & val.cfgProbeInv  & val.cfgXPlusInv  &
           val.cfgXMinusInv & val.cfgXHomeInv  & val.cfgZPlusInv  &
           val.cfgZMinusInv & val.cfgZHomeInv  & val.cfgSpDirInv  &
           val.cfgXJogInv   & val.cfgZJogInv   & val.cfgXDroInv   &
           val.cfgZDroInv   & val.cfgXDirInv   & val.cfgZDirInv;
 return rtnVec;
end function;

function cfgCtlToRec(val : cfgCtlVec) return cfgCtlRec is
 variable rtnRec : cfgCtlRec;
begin
 rtnRec.cfgDroStep   := val(20);
 rtnRec.cfgPwmEna    := val(19);
 rtnRec.cfgGenSync   := val(18);
 rtnRec.cfgEnaEncDir := val(17);
 rtnRec.cfgEStopInv  := val(16);
 rtnRec.cfgEStopEna  := val(15);
 rtnRec.cfgEncDirInv := val(14);
 rtnRec.cfgProbeInv  := val(13);
 rtnRec.cfgXPlusInv  := val(12);
 rtnRec.cfgXMinusInv := val(11);
 rtnRec.cfgXHomeInv  := val(10);
 rtnRec.cfgZPlusInv  := val(9);
 rtnRec.cfgZMinusInv := val(8);
 rtnRec.cfgZHomeInv  := val(7);
 rtnRec.cfgSpDirInv  := val(6);
 rtnRec.cfgXJogInv   := val(5);
 rtnRec.cfgZJogInv   := val(4);
 rtnRec.cfgXDroInv   := val(3);
 rtnRec.cfgZDroInv   := val(2);
 rtnRec.cfgXDirInv   := val(1);
 rtnRec.cfgZDirInv   := val(0);

 return rtnRec;
end function;

function cfgCtlToRecS(val : std_logic_vector(cfgCtlSize-1 downto 0))
 return cfgCtlRec is
 variable rtnRec : cfgCtlRec;
begin
 rtnRec.cfgDroStep   := val(20);
 rtnRec.cfgPwmEna    := val(19);
 rtnRec.cfgGenSync   := val(18);
 rtnRec.cfgEnaEncDir := val(17);
 rtnRec.cfgEStopInv  := val(16);
 rtnRec.cfgEStopEna  := val(15);
 rtnRec.cfgEncDirInv := val(14);
 rtnRec.cfgProbeInv  := val(13);
 rtnRec.cfgXPlusInv  := val(12);
 rtnRec.cfgXMinusInv := val(11);
 rtnRec.cfgXHomeInv  := val(10);
 rtnRec.cfgZPlusInv  := val(9);
 rtnRec.cfgZMinusInv := val(8);
 rtnRec.cfgZHomeInv  := val(7);
 rtnRec.cfgSpDirInv  := val(6);
 rtnRec.cfgXJogInv   := val(5);
 rtnRec.cfgZJogInv   := val(4);
 rtnRec.cfgXDroInv   := val(3);
 rtnRec.cfgZDroInv   := val(2);
 rtnRec.cfgXDirInv   := val(1);
 rtnRec.cfgZDirInv   := val(0);

 return rtnRec;
end function;

function clkCtlToVec(val : clkCtlRec) return clkCtlVec is
 variable rtnVec : clkCtlVec;
begin
 rtnVec := val.clkDbgFreqEna & val.xFreqShift    & val.zFreqShift    &
           val.xFreqSel      & val.zFreqSel;
 return rtnVec;
end function;

function clkCtlToRec(val : clkCtlVec) return clkCtlRec is
 variable rtnRec : clkCtlRec;
begin
 rtnRec.clkDbgFreqEna := val(6);
 rtnRec.xFreqShift    := val(0);
 rtnRec.zFreqShift    := val(0);
 rtnRec.xFreqSel      := val(5 downto 3);
 rtnRec.zFreqSel      := val(2 downto 0);

 return rtnRec;
end function;

function clkCtlToRecS(val : std_logic_vector(clkCtlSize-1 downto 0))
 return clkCtlRec is
 variable rtnRec : clkCtlRec;
begin
 rtnRec.clkDbgFreqEna := val(6);
 rtnRec.xFreqShift    := val(0);
 rtnRec.zFreqShift    := val(0);
 rtnRec.xFreqSel      := val(5 downto 3);
 rtnRec.zFreqSel      := val(2 downto 0);

 return rtnRec;
end function;

function synCtlToVec(val : synCtlRec) return synCtlVec is
 variable rtnVec : synCtlVec;
begin
 rtnVec := val.synEncEna    & val.synEncInit   & val.synPhaseInit;
 return rtnVec;
end function;

function synCtlToRec(val : synCtlVec) return synCtlRec is
 variable rtnRec : synCtlRec;
begin
 rtnRec.synEncEna    := val(2);
 rtnRec.synEncInit   := val(1);
 rtnRec.synPhaseInit := val(0);

 return rtnRec;
end function;

function synCtlToRecS(val : std_logic_vector(synCtlSize-1 downto 0))
 return synCtlRec is
 variable rtnRec : synCtlRec;
begin
 rtnRec.synEncEna    := val(2);
 rtnRec.synEncInit   := val(1);
 rtnRec.synPhaseInit := val(0);

 return rtnRec;
end function;

function spCtlToVec(val : spCtlRec) return spCtlVec is
 variable rtnVec : spCtlVec;
begin
 rtnVec := val.spJogEnable & val.spDir       & val.spEna       &
           val.spInit;
 return rtnVec;
end function;

function spCtlToRec(val : spCtlVec) return spCtlRec is
 variable rtnRec : spCtlRec;
begin
 rtnRec.spJogEnable := val(3);
 rtnRec.spDir       := val(2);
 rtnRec.spEna       := val(1);
 rtnRec.spInit      := val(0);

 return rtnRec;
end function;

function spCtlToRecS(val : std_logic_vector(spCtlSize-1 downto 0))
 return spCtlRec is
 variable rtnRec : spCtlRec;
begin
 rtnRec.spJogEnable := val(3);
 rtnRec.spDir       := val(2);
 rtnRec.spEna       := val(1);
 rtnRec.spInit      := val(0);

 return rtnRec;
end function;

end package body FpgaLatheBitsFunc;
