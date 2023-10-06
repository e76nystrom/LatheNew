library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock is
 port(
  clockIn  : in std_logic;
  clockOut : out std_logic
  );
end clock;

architecture Behavioral of clock is

begin

 clockOut <= clockIn;
 
end behavioral;

