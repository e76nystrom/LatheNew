library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity systemClk is
 port(
  inClk  : in std_logic;
  outClk : out std_logic
  );
end systemClk;

architecture Behavioral of systemClk is

begin

 outClk <= inClk;

end behavioral;

