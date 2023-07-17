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

 component clk_wiz_0 is
  Port ( 
   clk_out1 : out STD_LOGIC;
   reset : in STD_LOGIC;
   locked : out STD_LOGIC;
   clk_in1 : in STD_LOGIC
   );
 end component;

begin

 sys_Clk : clk_wiz_0
  port map (
   reset => '0',
   clk_in1  => clockIn,
   clk_out1 => clockOut,
   locked  => open
   );

end behavioral;

