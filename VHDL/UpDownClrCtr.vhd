--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:58:16 01/28/2015 
-- Design Name: 
-- Module Name:    UpDownClrCtr - Behavioral 
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

entity UpDownClrCtr is
 generic(n : positive);
 port (
  clk : in std_logic;
  ena : in std_logic;
  inc : in std_logic;
  clr : in std_logic;
  counter : inout unsigned(n-1 downto 0) := (n-1 downto 0 => '0'));
end UpDownClrCtr;

architecture Behavioral of UpDownClrCtr is

begin

 UpDownClrCtr: process(clk)
 begin
  if (rising_edge(clk)) then
   if (clr = '1') then
    counter <= (n-1 downto 0 => '0');
   elsif (ena = '1') then
    if (inc = '1') then
     counter <= counter + 1;
    else
     counter <= counter - 1;
    end if;      
   end if;
  end if;
 end process UpDownClrCtr;

end Behavioral;

