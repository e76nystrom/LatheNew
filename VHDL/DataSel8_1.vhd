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

entity DataSel8_1 is
 port (
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
end DataSel8_1;

architecture Behavioral of DataSel8_1 is

begin

 dout <= d7 when (sel = "111") else
         d6 when (sel = "110") else
         d5 when (sel = "101") else
         d4 when (sel = "100") else
         d3 when (sel = "011") else
         d2 when (sel = "010") else
         d1 when (sel = "001") else
         d0 when (sel = "000") else
         '0';

end Behavioral;
