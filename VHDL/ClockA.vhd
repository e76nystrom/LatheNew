library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clock is
 port(
  clockIn : in std_logic;
  clockOut : out std_logic
  );
end Clock;

architecture Behavioral of Clock is

 component SystemClk is
  port(
   areset : in std_logic;
   inclk0 : in std_logic;
   c0 : out std_logic;
   locked : out std_logic
   );
 end component;

begin

 sys_Clk : SystemClk
  port map (
   areset  => '0',
   inclk0  => clockIn,
   c0      => clockOut,
   locked  => open
   );

end behavioral;

