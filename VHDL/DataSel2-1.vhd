--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:00:00 12/19/2019
-- Design Name: 
-- Module Name:    DataSel2_1 - Behavioral 
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

entity DataSel2_1 is
 port (
  sel : in std_logic;
  a : in std_logic;
  b : in std_logic;
  y : out std_logic
  );
end DataSel2_1;

architecture Behavioral of DataSel2_1 is

begin

 DataSel2_1: process(sel, a, b)
 begin
  if (sel = '0') then
   y <= a;
  else
   y <= b;
  end if;
 end process DataSel2_1;

end Behavioral;

