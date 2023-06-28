--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:02:29 01/24/2015 
-- Design Name: 
-- Module Name:    ShiftOpLoad - Behavioral 
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

entity ShiftOpLoad is
 generic(opVal :  unsigned (opb-1 downto 0) := x"00";
         opBits : positive := 8;
         n :      positive := 8);
 port(
  clk :   in    std_logic;
  din :   in    std_logic;
  op :    in    unsigned (opBits-1 downto 0);
  shift : in    boolean;

  load :  out   std_logic := '0';
  data :  inout unsigned (n-1 downto 0) := (others => '0')
  );
end ShiftOpLoad;

architecture Behavioral of ShiftOpLoad is

 signal sel :     boolean := false;
 signal lastSel : boolean := false;
begin

 sel <= op = opVal;                     --select flag

 shift_reg: process (clk)
 begin
  if (rising_edge(clk)) then
   if (sel) then                        --if selected
    lastSel <= true;                    --update last value
    if (shift) then                     --if time to shift
     data <= data(n-2 downto 0) & din;  --shift
    end if;
   else                                 --if not selected
    if (lastSel) then                   --if was selected
     load <= '1';                       --set load flag
    else                                --if last not selected
     load <= '0';                       --clear load flag
    end if;
    lastSel <= false;                   --clear last selected
   end if;
  end if;
 end process shift_reg;

end Behavioral;

