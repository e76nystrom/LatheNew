--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:02:29 01/24/2015 
-- Design Name: 
-- Module Name:    ShiftOp - Behavioral 
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

entity ShiftOp is
 generic(opVal : unsigned;
         opBits : positive;
         n : positive);
 port(
  clk : in std_logic;
  din : in std_logic;
  op : in unsigned (opBits-1 downto 0);
  shift : in std_logic;
  data : inout unsigned (n-1 downto 0) := (others => '0')
  );
end ShiftOp;

architecture Behavioral of ShiftOp is

begin

shift_reg: process (clk)
 begin
  if (rising_edge(clk)) then
   if ((op = opVal) and (shift = '1')) then
    data <= data(n-2 downto 0) & din;
   end if;
  end if;
 end process shift_reg;

end Behavioral;

