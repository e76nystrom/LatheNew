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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ShiftOpLoad is
 generic(opVal : unsigned;
         opBits : positive;
         n : positive);
 port(
  clk : in std_logic;
  din : in std_logic;
  op : in unsigned (opBits-1 downto 0);
  shift : in boolean;
  load : out std_logic;
  data : inout unsigned (n-1 downto 0) := (others => '0')
  );
end ShiftOpLoad;

architecture Behavioral of ShiftOpLoad is

 signal sel : boolean;
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

