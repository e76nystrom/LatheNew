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
library ieee;

use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

use work.RegDef.ALL;

entity ShiftOp is
 generic(opVal  : unsigned (opb-1 downto 0) := x"00";
         opBits : positive := 8;
         n      : positive := 8);
 port(
  clk   : in    std_logic;
  din   : in    std_logic;
  op    : in    unsigned (opBits-1 downto 0);
  shift : in    boolean;

  data  : inout unsigned (n-1 downto 0) := (others => '0')
  );
end ShiftOp;

architecture Behavioral of ShiftOp is

begin

 shift_reg: process (clk)
 begin
  if (rising_edge(clk)) then
   if ((op = opVal) and shift) then
    data <= data(n-2 downto 0) & din;
   end if;
  end if;
 end process shift_reg;

end Behavioral;
