-- Create Date:    17:02:29 01/24/2015 

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RegDef.opb;
use work.IORecord.all;

entity ShiftOpSel is
 generic (opVal : unsigned (opb-1 downto 0);
          n :    positive);
 port (
  clk  : in   std_logic;
  inp  : in   DataInp;
  sel  : out  std_logic := '0';
  data : inout unsigned (n-1 downto 0) := (others => '0')
  );
end ShiftOpSel;

architecture Behavioral of ShiftOpSel is

begin

 shift_reg: process (clk)
  variable opSel : std_logic;
 begin
  if (rising_edge(clk)) then
   if (inp.op = opVal) then
    opSel := '1';
   else
    opSel := '0';
   end if;

   sel <= opSel;

   if ((opSel = '1') and (inp.shift = '1')) then
    data <= data(n-2 downto 0) & inp.din;
   end if;
  end if;
 end process shift_reg;

end Behavioral;

