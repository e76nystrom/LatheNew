-- Create Date:    17:02:29 01/24/2015 

library ieee;

use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

use work.RegDef.opb;
use work.IORecord.all;

entity ShiftOp is
 generic(opVal : unsigned (opb-1 downto 0);
         n     : positive);
 port(
  clk   : in std_logic;
  inp   : in DataInp;
  data  : inout unsigned (n-1 downto 0) := (others => '0')
  );
end ShiftOp;

architecture Behavioral of ShiftOp is

begin

 shift_reg: process (clk)
 begin
  if (rising_edge(clk)) then
   if ((inp.op = opVal) and (inp.shift = '1')) then
    data <= data(n-2 downto 0) & inp.dIn;
   end if;
  end if;
 end process shift_reg;

end Behavioral;
