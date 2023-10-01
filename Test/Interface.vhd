-- Create Date: 09/27/2023 04:00:50 AM

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith;

use work.SimProc.all;
use work.RegDef.all;
use work.IORecord.all;
use work.ExtDataRec.all;

entity InterfaceTest is
end InterfaceTest;

architecture Behavioral of InterfaceTest is
 
 signal sysClk : std_logic := '0';

 signal clk     : std_logic := '0';
 signal re      : std_ulogic := '0';
 signal we      : std_ulogic := '0'; 
 signal reg     : std_ulogic_vector(1 downto 0) := (others => '0');

 signal cfsDataIn   : std_ulogic_vector(31 downto 0) := (others => '0');
 signal cfsDdataOut : std_ulogic_vector(31 downto 0) := (others => '0');

 signal latheData  : ExtDataRcv := extDataRcvInit;
 signal latheCtl   : ExtDataCtl := extDataCtlInit;

begin

 uut : entity work.CFSInterface
  port (
   clk     => clk,
   re      => re,
   we      => we,
   reg     => reg,

   CFSdataIn  => cfsDataIn,
   CFSdataOut => cfsDataOut,

   latheData  => latheData,
   latheCtl   => latheCtl
   );

 -- Clock process definitions

 clkProcess : process
 begin
  sysClk <= '0';
  wait for clk_period/2;
  sysClk <= '1';
  wait for clk_period/2;
 end process;

 -- Stimulus process

 stimProc : process
 
  procedure delay(constant n : in integer) is
  begin
   for i in 0 to n-1 loop
    wait until (sysClk = '1');
    wait until (sysClk = '0');
   end loop;
  end procedure delay;

 begin

 end process;

end Behavioral;
