--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:34:36 01/24/2015 
-- Design Name: 
-- Module Name:    Accumulator - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Accumulator is
 generic (n : positive);
 port ( clk : in std_logic;
        ena : in std_logic;
        clr : in std_logic;
        func : in std_logic;
        a : in  unsigned (n-1 downto 0);
        sum : inout unsigned (n-1 downto 0) := (n-1 downto 0 => '0');
        zero : inout std_logic := '0');
end Accumulator;

architecture Behavioral of Accumulator is

begin

 accumulator: process(clk)
  variable sel : std_logic_vector(1 downto 0);
 begin
  if (rising_edge(clk)) then
   if (ena = '1') then
    sel := clr & func;
    case sel is
     when "00" =>
      if (zero = '0') then
       sum <= sum - a;
      end if;
     when "01" => sum <= sum + a;
     when "10" => sum <= (n-1 downto 0 => '0');
     when "11" => sum <= (n-1 downto 0 => '0');
     when others => sum <= (n-1 downto 0 => '0');
    end case;
   else
    if (sum = 0) then
     zero <= '1';
    else
     zero <= '0';
    end if;
   end if;
  end if;
 end process accumulator;

end Behavioral;

