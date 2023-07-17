--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:02:29 01/24/2015 
-- Design Name: 
-- Module Name:    ShiftOut - Behavioral 
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

entity ShiftOut is
 generic(opVal : unsigned;
         opBits : positive;
         n : positive);
 port (
  clk : in std_logic;
  dshift : in boolean;
  op : in unsigned (opBits-1 downto 0);
  copy : in boolean;
  data : in unsigned(n-1 downto 0);
  dout : out std_logic := '0'
  );
end ShiftOut;

architecture Behavioral of ShiftOut is

 signal shiftSel : boolean := false;
 signal shiftReg : unsigned(n-1 downto 0) := (others => '0');

begin

 -- shiftSel <= '1' when op = opVal else '0';
 dout <= shiftReg(n-1) when shiftSel else '0';

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
   else 
    if (shiftSel and dShift) then
     shiftReg <= shiftReg(n-2 downto 0) & shiftReg(n-1);
    end if;
   end if;
  end if;
 end process shiftout;

end Behavioral;

