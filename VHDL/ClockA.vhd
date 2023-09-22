library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clock is
 port(
  clockIn  : in std_logic;
  clockOut : out std_logic
  );
end Clock;

architecture Behavioral of Clock is

 component SystemClk is
  port(
   inclk  : in std_logic;
   outclk : out std_logic
   );
 end component;

begin

 sysClk : SystemClk
  port map (
   inclk  => clockIn,
   outClk => clockOut
   );

end behavioral;

