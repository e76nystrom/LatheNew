--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:30:00 04/05/2015 
-- Design Name: 
-- Module Name:    CtlReg - Behavioral 
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

-- library RegDef
-- use RegDef.all;

entity CtlReg is
 generic(opVal : unsigned;
         opb : positive := 8;
         n : positive);
 port (
  clk : in std_logic;                   --clock
  din : in std_logic;                   --data in
  op : in unsigned(opb-1 downto 0);     --current reg address
  shift : in boolean;                   --shift data
  load : in boolean;                    --load to data register
  data : inout unsigned (n-1 downto 0) := (others => '0')); --data register
end CtlReg;

architecture Behavioral of CtlReg is

signal sreg : unsigned (n-1 downto 0) := (others => '0');

begin

ctlreg1: process (clk)
 begin
  if (rising_edge(clk)) then
   if (op = opVal) then
    if (load) then                   --if load set
     data <= sreg;                   --copy from shift reg to data reg
    else                             --if load not set
     if (shift) then                 --if shift set
      sreg <= sreg(n-2 downto 0) & din; --shift data in
     end if;
    end if;
   end if;
  end if;
 end process ctlreg1;

end Behavioral;

