--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:02:00 12/17/2019 
-- Design Name: 
-- Module Name:    DataSel8_1 - Behavioral 
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

entity DataSelSynN_1 is
 port (
  clk : in std_logic;
  sel : in unsigned (2 downto 0);
  d0 : in std_logic;
  d1 : in std_logic;
  d2 : in std_logic;
  d3 : in std_logic;
  d4 : in std_logic;
  d5 : in std_logic;
  d6 : in std_logic;
  d7 : in std_logic;
  dout : out std_logic);
end DataSelSynN_1;

architecture Behavioral of DataSelSynN_1 is

begin

 dataSel8: process(clk)
 begin
  case sel is
   when "111" => dout <= d7;
   when "110" => dout <= d6;
   when "101" => dout <= d5;
   when "100" => dout <= d4;
   when "011" => dout <= d3;
   when "010" => dout <= d2;
   when "001" => dout <= d1;
   when "000" => dout <= d0;
   when others => dout <= '0';                 
  end case;
 end process;

end Behavioral;
