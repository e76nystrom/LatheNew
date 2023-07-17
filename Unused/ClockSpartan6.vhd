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

 component latheClk is
  Port ( 
   clk_out : out STD_LOGIC;
   reset : in STD_LOGIC;
   locked : out STD_LOGIC;
   clk_in : in STD_LOGIC
   );
 end component;

begin

 sys_Clk : latheClk
  port map (
   reset => '0',
   clk_in  => clockIn,
   clk_out => clockOut,
   locked  => open
   );

end behavioral;

