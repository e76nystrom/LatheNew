-- fFile

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.FpgaLatheBitsRec.all;

package FpgaLatheBitsFunc is

constant riscvCtlSize : integer := 3;
subType riscvCtlVec is std_logic_vector(riscvCtlSize-1 downto 0);
constant riscvCtlZero : riscvCtlVec := (others => '0');

function riscvCtlToVec(val : riscvCtlRec)
 return riscvCtlVec;

function riscvCtlToRec(val : riscvCtlVec)
return riscvCtlRec;

function riscvCtlToRecS(val : std_logic_vector(riscvCtlSize-1 downto 0))
return riscvCtlRec;

constant statusSize : integer := 10;
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

constant axisInSize : integer := 4;
subType axisInVec is std_logic_vector(axisInSize-1 downto 0);
constant axisInZero : axisInVec := (others => '0');

function axisInToVec(val : axisInRec)
 return axisInVec;

function axisInToRec(val : axisInVec)
return axisInRec;

function axisInToRecS(val : std_logic_vector(axisInSize-1 downto 0))
return axisInRec;

constant outputsSize : integer := 2;
subType outputsVec is std_logic_vector(outputsSize-1 downto 0);
constant outputsZero : outputsVec := (others => '0');

function outputsToVec(val : outputsRec)
 return outputsVec;

function outputsToRec(val : outputsVec)
return outputsRec;

function outputsToRecS(val : std_logic_vector(outputsSize-1 downto 0))
return outputsRec;

constant pinOutSize : integer := 12;
subType pinOutVec is std_logic_vector(pinOutSize-1 downto 0);
constant pinOutZero : pinOutVec := (others => '0');

function pinOutToVec(val : pinOutRec)
 return pinOutVec;

function pinOutToRec(val : pinOutVec)
return pinOutRec;

function pinOutToRecS(val : std_logic_vector(pinOutSize-1 downto 0))
return pinOutRec;

constant jogSize : integer := 2;
subType jogVec is std_logic_vector(jogSize-1 downto 0);
constant jogZero : jogVec := (others => '0');

function jogToVec(val : jogRec)
 return jogVec;

function jogToRec(val : jogVec)
return jogRec;

function jogToRecS(val : std_logic_vector(jogSize-1 downto 0))
return jogRec;

constant runOutCtlSize : integer := 3;
subType runOutCtlVec is std_logic_vector(runOutCtlSize-1 downto 0);
constant runOutCtlZero : runOutCtlVec := (others => '0');

function runOutCtlToVec(val : runOutCtlRec)
 return runOutCtlVec;

function runOutCtlToRec(val : runOutCtlVec)
return runOutCtlRec;

function runOutCtlToRecS(val : std_logic_vector(runOutCtlSize-1 downto 0))
return runOutCtlRec;

constant axisCtlSize : integer := 16;
subType axisCtlVec is std_logic_vector(axisCtlSize-1 downto 0);
constant axisCtlZero : axisCtlVec := (others => '0');

function axisCtlToVec(val : axisCtlRec)
 return axisCtlVec;

function axisCtlToRec(val : axisCtlVec)
return axisCtlRec;

function axisCtlToRecS(val : std_logic_vector(axisCtlSize-1 downto 0))
return axisCtlRec;

constant axisStatusSize : integer := 11;
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

constant spCtlSize : integer := 3;
subType spCtlVec is std_logic_vector(spCtlSize-1 downto 0);
constant spCtlZero : spCtlVec := (others => '0');

function spCtlToVec(val : spCtlRec)
 return spCtlVec;

function spCtlToRec(val : spCtlVec)
return spCtlRec;

function spCtlToRecS(val : std_logic_vector(spCtlSize-1 downto 0))
return spCtlRec;

constant synCtlSize : integer := 5;
subType synCtlVec is std_logic_vector(synCtlSize-1 downto 0);
constant synCtlZero : synCtlVec := (others => '0');

function synCtlToVec(val : synCtlRec)
 return synCtlVec;

function synCtlToRec(val : synCtlVec)
return synCtlRec;

function synCtlToRecS(val : std_logic_vector(synCtlSize-1 downto 0))
return synCtlRec;

constant clkCtlSize : integer := 9;
subType clkCtlVec is std_logic_vector(clkCtlSize-1 downto 0);
constant clkCtlZero : clkCtlVec := (others => '0');

function clkCtlToVec(val : clkCtlRec)
 return clkCtlVec;

function clkCtlToRec(val : clkCtlVec)
return clkCtlRec;

function clkCtlToRecS(val : std_logic_vector(clkCtlSize-1 downto 0))
return clkCtlRec;

end FpgaLatheBitsFunc;

package body FpgaLatheBitsFunc is

function riscvCtlToVec(val : riscvCtlRec) return riscvCtlVec is
 variable rtnVec : riscvCtlVec;
begin
 rtnVec := val.riscvInTest & val.riscvSPI    & val.riscvData;
 return rtnVec;
end function;

function riscvCtlToRec(val : riscvCtlVec) return riscvCtlRec is
 variable rtnRec : riscvCtlRec;
begin
 rtnRec.riscvInTest := val(2);
 rtnRec.riscvSPI    := val(1);
 rtnRec.riscvData   := val(0);

 return rtnRec;
end function;

function riscvCtlToRecS(val : std_logic_vector(riscvCtlSize-1 downto 0))
 return riscvCtlRec is
 variable rtnRec : riscvCtlRec;
begin
 rtnRec.riscvInTest := val(2);
 rtnRec.riscvSPI    := val(1);
 rtnRec.riscvData   := val(0);

 return rtnRec;
end function;


-- end

function statusToVec(val : statusRec) return statusVec is
 variable rtnVec : statusVec;
begin
 rtnVec := val.encoderDir    & val.syncActive    & val.spindleActive &
           val.stEStop       & val.xAxisCurDir   & val.xAxisDone     &
           val.xAxisEna      & val.zAxisCurDir   & val.zAxisDone     &
           val.zAxisEna;
 return rtnVec;
end function;

function statusToRec(val : statusVec) return statusRec is
 variable rtnRec : statusRec;
begin
 rtnRec.encoderDir    := val(9);
 rtnRec.syncActive    := val(8);
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
 rtnRec.encoderDir    := val(9);
 rtnRec.syncActive    := val(8);
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


-- end

function inputsToVec(val : inputsRec) return inputsVec is
 variable rtnVec : inputsVec;
begin
 rtnVec := val.inSpare  & val.inProbe  & val.inXPlus  & val.inXMinus &
           val.inXHome  & val.inZPlus  & val.inZMinus & val.inZHome  &
           val.inPin15  & val.inPin13  & val.inPin12  & val.inPin11  &
           val.inPin10;
 return rtnVec;
end function;

function inputsToRec(val : inputsVec) return inputsRec is
 variable rtnRec : inputsRec;
begin
 rtnRec.inSpare  := val(12);
 rtnRec.inProbe  := val(11);
 rtnRec.inXPlus  := val(10);
 rtnRec.inXMinus := val(9);
 rtnRec.inXHome  := val(8);
 rtnRec.inZPlus  := val(7);
 rtnRec.inZMinus := val(6);
 rtnRec.inZHome  := val(5);
 rtnRec.inPin15  := val(4);
 rtnRec.inPin13  := val(3);
 rtnRec.inPin12  := val(2);
 rtnRec.inPin11  := val(1);
 rtnRec.inPin10  := val(0);

 return rtnRec;
end function;

function inputsToRecS(val : std_logic_vector(inputsSize-1 downto 0))
 return inputsRec is
 variable rtnRec : inputsRec;
begin
 rtnRec.inSpare  := val(12);
 rtnRec.inProbe  := val(11);
 rtnRec.inXPlus  := val(10);
 rtnRec.inXMinus := val(9);
 rtnRec.inXHome  := val(8);
 rtnRec.inZPlus  := val(7);
 rtnRec.inZMinus := val(6);
 rtnRec.inZHome  := val(5);
 rtnRec.inPin15  := val(4);
 rtnRec.inPin13  := val(3);
 rtnRec.inPin12  := val(2);
 rtnRec.inPin11  := val(1);
 rtnRec.inPin10  := val(0);

 return rtnRec;
end function;


-- end

function axisInToVec(val : axisInRec) return axisInVec is
 variable rtnVec : axisInVec;
begin
 rtnVec := val.axProbe & val.axPlus  & val.axMinus & val.axHome;
 return rtnVec;
end function;

function axisInToRec(val : axisInVec) return axisInRec is
 variable rtnRec : axisInRec;
begin
 rtnRec.axProbe := val(3);
 rtnRec.axPlus  := val(2);
 rtnRec.axMinus := val(1);
 rtnRec.axHome  := val(0);

 return rtnRec;
end function;

function axisInToRecS(val : std_logic_vector(axisInSize-1 downto 0))
 return axisInRec is
 variable rtnRec : axisInRec;
begin
 rtnRec.axProbe := val(3);
 rtnRec.axPlus  := val(2);
 rtnRec.axMinus := val(1);
 rtnRec.axHome  := val(0);

 return rtnRec;
end function;


-- end

function outputsToVec(val : outputsRec) return outputsVec is
 variable rtnVec : outputsVec;
begin
 rtnVec := val.outPin14 & val.outPin1;
 return rtnVec;
end function;

function outputsToRec(val : outputsVec) return outputsRec is
 variable rtnRec : outputsRec;
begin
 rtnRec.outPin14 := val(1);
 rtnRec.outPin1  := val(0);

 return rtnRec;
end function;

function outputsToRecS(val : std_logic_vector(outputsSize-1 downto 0))
 return outputsRec is
 variable rtnRec : outputsRec;
begin
 rtnRec.outPin14 := val(1);
 rtnRec.outPin1  := val(0);

 return rtnRec;
end function;


-- end

function pinOutToVec(val : pinOutRec) return pinOutVec is
 variable rtnVec : pinOutVec;
begin
 rtnVec := val.pinOut17 & val.pinOut16 & val.pinOut14 & val.pinOut1  &
           val.pinOut9  & val.pinOut8  & val.pinOut7  & val.pinOut6  &
           val.pinOut5  & val.pinOut4  & val.pinOut3  & val.pinOut2;
 return rtnVec;
end function;

function pinOutToRec(val : pinOutVec) return pinOutRec is
 variable rtnRec : pinOutRec;
begin
 rtnRec.pinOut17 := val(11);
 rtnRec.pinOut16 := val(10);
 rtnRec.pinOut14 := val(9);
 rtnRec.pinOut1  := val(8);
 rtnRec.pinOut9  := val(7);
 rtnRec.pinOut8  := val(6);
 rtnRec.pinOut7  := val(5);
 rtnRec.pinOut6  := val(4);
 rtnRec.pinOut5  := val(3);
 rtnRec.pinOut4  := val(2);
 rtnRec.pinOut3  := val(1);
 rtnRec.pinOut2  := val(0);

 return rtnRec;
end function;

function pinOutToRecS(val : std_logic_vector(pinOutSize-1 downto 0))
 return pinOutRec is
 variable rtnRec : pinOutRec;
begin
 rtnRec.pinOut17 := val(11);
 rtnRec.pinOut16 := val(10);
 rtnRec.pinOut14 := val(9);
 rtnRec.pinOut1  := val(8);
 rtnRec.pinOut9  := val(7);
 rtnRec.pinOut8  := val(6);
 rtnRec.pinOut7  := val(5);
 rtnRec.pinOut6  := val(4);
 rtnRec.pinOut5  := val(3);
 rtnRec.pinOut4  := val(2);
 rtnRec.pinOut3  := val(1);
 rtnRec.pinOut2  := val(0);

 return rtnRec;
end function;


-- end

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


-- end

function runOutCtlToVec(val : runOutCtlRec) return runOutCtlVec is
 variable rtnVec : runOutCtlVec;
begin
 rtnVec := val.runOutDir  & val.runOutEna  & val.runOutInit;
 return rtnVec;
end function;

function runOutCtlToRec(val : runOutCtlVec) return runOutCtlRec is
 variable rtnRec : runOutCtlRec;
begin
 rtnRec.runOutDir  := val(2);
 rtnRec.runOutEna  := val(1);
 rtnRec.runOutInit := val(0);

 return rtnRec;
end function;

function runOutCtlToRecS(val : std_logic_vector(runOutCtlSize-1 downto 0))
 return runOutCtlRec is
 variable rtnRec : runOutCtlRec;
begin
 rtnRec.runOutDir  := val(2);
 rtnRec.runOutEna  := val(1);
 rtnRec.runOutInit := val(0);

 return rtnRec;
end function;


-- end

function axisCtlToVec(val : axisCtlRec) return axisCtlVec is
 variable rtnVec : axisCtlVec;
begin
 rtnVec := val.ctlUseLimits & val.ctlProbe     & val.ctlHomePol   &
           val.ctlHome      & val.ctlJogMpg    & val.ctlJogCmd    &
           val.ctlDistMode  & val.ctlDroEnd    & val.ctlSlave     &
           val.ctlChDirect  & val.ctlSetLoc    & val.ctlDir       &
           val.ctlWaitSync  & val.ctlBacklash  & val.ctlStart     &
           val.ctlInit;
 return rtnVec;
end function;

function axisCtlToRec(val : axisCtlVec) return axisCtlRec is
 variable rtnRec : axisCtlRec;
begin
 rtnRec.ctlUseLimits := val(15);
 rtnRec.ctlProbe     := val(14);
 rtnRec.ctlHomePol   := val(13);
 rtnRec.ctlHome      := val(12);
 rtnRec.ctlJogMpg    := val(11);
 rtnRec.ctlJogCmd    := val(10);
 rtnRec.ctlDistMode  := val(9);
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
 rtnRec.ctlUseLimits := val(15);
 rtnRec.ctlProbe     := val(14);
 rtnRec.ctlHomePol   := val(13);
 rtnRec.ctlHome      := val(12);
 rtnRec.ctlJogMpg    := val(11);
 rtnRec.ctlJogCmd    := val(10);
 rtnRec.ctlDistMode  := val(9);
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


-- end

function axisStatusToVec(val : axisStatusRec) return axisStatusVec is
 variable rtnVec : axisStatusVec;
begin
 rtnVec := val.axInFlag    & val.axInProbe   & val.axInPlus    &
           val.axInMinus   & val.axInHome    & val.axDoneProbe &
           val.axDoneLimit & val.axDoneHome  & val.axDoneDro   &
           val.axDistZero  & val.axDone;
 return rtnVec;
end function;

function axisStatusToRec(val : axisStatusVec) return axisStatusRec is
 variable rtnRec : axisStatusRec;
begin
 rtnRec.axInFlag    := val(10);
 rtnRec.axInProbe   := val(9);
 rtnRec.axInPlus    := val(8);
 rtnRec.axInMinus   := val(7);
 rtnRec.axInHome    := val(6);
 rtnRec.axDoneProbe := val(5);
 rtnRec.axDoneLimit := val(4);
 rtnRec.axDoneHome  := val(3);
 rtnRec.axDoneDro   := val(2);
 rtnRec.axDistZero  := val(1);
 rtnRec.axDone      := val(0);

 return rtnRec;
end function;

function axisStatusToRecS(val : std_logic_vector(axisStatusSize-1 downto 0))
 return axisStatusRec is
 variable rtnRec : axisStatusRec;
begin
 rtnRec.axInFlag    := val(10);
 rtnRec.axInProbe   := val(9);
 rtnRec.axInPlus    := val(8);
 rtnRec.axInMinus   := val(7);
 rtnRec.axInHome    := val(6);
 rtnRec.axDoneProbe := val(5);
 rtnRec.axDoneLimit := val(4);
 rtnRec.axDoneHome  := val(3);
 rtnRec.axDoneDro   := val(2);
 rtnRec.axDistZero  := val(1);
 rtnRec.axDone      := val(0);

 return rtnRec;
end function;


-- end

function cfgCtlToVec(val : cfgCtlRec) return cfgCtlVec is
 variable rtnVec : cfgCtlVec;
begin
 rtnVec := val.cfgDroStep   & val.cfgPwmEna    & val.cfgGenSync   &
           val.cfgEnaEncDir & val.cfgEStopInv  & val.cfgEStopEna  &
           val.cfgEncDirInv & val.cfgProbeInv  & val.cfgXPlusInv  &
           val.cfgXMinusInv & val.cfgXHomeInv  & val.cfgZPlusInv  &
           val.cfgZMinusInv & val.cfgZHomeInv  & val.cfgSpDirInv  &
           val.cfgXMpgInv   & val.cfgZMpgInv   & val.cfgXDroInv   &
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
 rtnRec.cfgXMpgInv   := val(5);
 rtnRec.cfgZMpgInv   := val(4);
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
 rtnRec.cfgXMpgInv   := val(5);
 rtnRec.cfgZMpgInv   := val(4);
 rtnRec.cfgXDroInv   := val(3);
 rtnRec.cfgZDroInv   := val(2);
 rtnRec.cfgXDirInv   := val(1);
 rtnRec.cfgZDirInv   := val(0);

 return rtnRec;
end function;


-- end

function spCtlToVec(val : spCtlRec) return spCtlVec is
 variable rtnVec : spCtlVec;
begin
 rtnVec := val.spDir  & val.spEna  & val.spInit;
 return rtnVec;
end function;

function spCtlToRec(val : spCtlVec) return spCtlRec is
 variable rtnRec : spCtlRec;
begin
 rtnRec.spDir  := val(2);
 rtnRec.spEna  := val(1);
 rtnRec.spInit := val(0);

 return rtnRec;
end function;

function spCtlToRecS(val : std_logic_vector(spCtlSize-1 downto 0))
 return spCtlRec is
 variable rtnRec : spCtlRec;
begin
 rtnRec.spDir  := val(2);
 rtnRec.spEna  := val(1);
 rtnRec.spInit := val(0);

 return rtnRec;
end function;


-- end

function synCtlToVec(val : synCtlRec) return synCtlVec is
 variable rtnVec : synCtlVec;
begin
 rtnVec := val.synEncClkSel & val.synEncEna    & val.synEncInit   &
           val.synPhaseInit;
 return rtnVec;
end function;

function synCtlToRec(val : synCtlVec) return synCtlRec is
 variable rtnRec : synCtlRec;
begin
 rtnRec.synEncClkSel := val(4 downto 3);
 rtnRec.synEncEna    := val(2);
 rtnRec.synEncInit   := val(1);
 rtnRec.synPhaseInit := val(0);

 return rtnRec;
end function;

function synCtlToRecS(val : std_logic_vector(synCtlSize-1 downto 0))
 return synCtlRec is
 variable rtnRec : synCtlRec;
begin
 rtnRec.synEncClkSel := val(4 downto 3);
 rtnRec.synEncEna    := val(2);
 rtnRec.synEncInit   := val(1);
 rtnRec.synPhaseInit := val(0);

 return rtnRec;
end function;


-- end

function clkCtlToVec(val : clkCtlRec) return clkCtlVec is
 variable rtnVec : clkCtlVec;
begin
 rtnVec := val.clkDbgAxisEna & val.clkDbgSyncEna & val.clkDbgFreqEna &
           val.xFreqSel      & val.zFreqSel;
 return rtnVec;
end function;

function clkCtlToRec(val : clkCtlVec) return clkCtlRec is
 variable rtnRec : clkCtlRec;
begin
 rtnRec.clkDbgAxisEna := val(8);
 rtnRec.clkDbgSyncEna := val(7);
 rtnRec.clkDbgFreqEna := val(6);
 rtnRec.xFreqSel      := val(5 downto 3);
 rtnRec.zFreqSel      := val(2 downto 0);

 return rtnRec;
end function;

function clkCtlToRecS(val : std_logic_vector(clkCtlSize-1 downto 0))
 return clkCtlRec is
 variable rtnRec : clkCtlRec;
begin
 rtnRec.clkDbgAxisEna := val(8);
 rtnRec.clkDbgSyncEna := val(7);
 rtnRec.clkDbgFreqEna := val(6);
 rtnRec.xFreqSel      := val(5 downto 3);
 rtnRec.zFreqSel      := val(2 downto 0);

 return rtnRec;
end function;


-- end

end package body FpgaLatheBitsFunc;
