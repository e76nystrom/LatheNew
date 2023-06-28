--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:02:29 01/24/2015 
-- Design Name: 
-- Module Name:    ShiftOutN - Behavioral 
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

entity ShiftOutN is
 generic(opVal :   unsigned (opb-1 downto 0) := x"00";
         opBits :  positive := 8;
         n :       positive := 8;
         outBits : positive := 16);
 port (
  clk :    in  std_logic;
  dshift : in  boolean;
  op :     in  unsigned (opBits-1 downto 0);
  copy :   in  boolean;
  data :   in  unsigned(n-1 downto 0);

  dout :   out std_logic := '0'
  );
end ShiftOutN;

architecture Behavioral of ShiftOutN is

 signal shiftSel : boolean := false;
 signal shiftReg : unsigned(n-1 downto 0) := (n-1 downto 0 => '0');
 signal padding :  integer range 0 to outBits-n;

begin

 -- shiftSel <= '1' when op = opVal else '0';
 dout <= shiftReg(n-1) when (shiftSel and (padding = 0)) else
         '0';

 shiftout: process (clk)
 begin
  if (rising_edge(clk)) then
   if (op = opVal) then
    shiftSel <= true;
   else
    shiftSel <= false;
   end if;
   
   if (shiftSel and copy) then
    shiftReg <= data;
    padding <= 32-n;
   else 
    if (shiftSel and dShift) then
     if (padding = 0) then
      shiftReg <= shiftReg(n-2 downto 0) & shiftReg(n-1);
     else
      padding <= padding - 1;
     end if;
    end if;
   end if;
  end if;
 end process shiftout;

end Behavioral;

