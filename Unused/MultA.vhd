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

 component Multiplier is
  port (
   aclr	: IN STD_LOGIC ;
   clken : IN STD_LOGIC ;
   clock : IN STD_LOGIC ;
   dataa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
   datab : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
   result : OUT STD_LOGIC_VECTOR (39 DOWNTO 0)
   );
 end component;

begin

 sys_Clk : multiplier
  port map (
   aclr => clr,
   clken => clkEna,
   clock => clk,
   dataa => aIn,
   datab => bIn,
   result => rslt
   );

end behavioral;

