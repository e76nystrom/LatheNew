library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mult is
 port(
  clr : in std_logic;
  clkEna : in std_logic;
  clk : in std_logic;
  aIn : in std_logic_vector(15 downto 0);
  bIn : in std_logic_vector(23 downto 0);
  rslt : out std_logic_vector(39 downto 0)
 );
end Mult;

architecture Behavioral of Mult is

 component mult_gen_0 is
  port (
   CLK : in STD_LOGIC;
   A : in STD_LOGIC_VECTOR ( 15 downto 0 );
   B : in STD_LOGIC_VECTOR ( 23 downto 0 );
   CE : in STD_LOGIC;
   SCLR : in STD_LOGIC;
   P : out STD_LOGIC_VECTOR ( 39 downto 0 )
   );
 end component;

begin

 sys_Clk : mult_gen_0
  port map (
   sclr => clr,
   ce => clkEna,
   clk => clk,
   a => aIn,
   b => bIn,
   p => rslt
   );

end behavioral;

