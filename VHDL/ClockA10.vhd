library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clock is
 port (
  clockIn  : in std_logic;
  clockOut : out std_logic
  );
end Clock;

architecture Behavioral of Clock is

 component SystemClock10 is
  port (
   inclk0 : in  std_logic;
   c0     : out std_logic
   );
 end component;

begin

 sysClkA : SystemClock10
  port map (
   inclk0 => clockIn,
   c0     => clockOut
   );

end behavioral;

