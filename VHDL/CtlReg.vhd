-- Create Date:    17:30:00 04/05/2015 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.DataInp;

entity CtlReg is
 generic(opVal : unsigned;
         n :     positive);
 port (
  clk  : in std_logic;                  --clock
  inp  : DataInp;
  data : out std_logic_vector (n-1 downto 0) := (others => '0')); --data reg
end CtlReg;

architecture Behavioral of CtlReg is

signal sreg : std_logic_vector (n-1 downto 0) := (others => '0');

begin

ctlreg1: process (clk)
 begin
  if (rising_edge(clk)) then
   if (inp.op = opVal) then
    if (inp.load = '1') then         --if load set
     data <= sreg;                   --copy from shift reg to data reg
    else                             --if load not set
     if (inp.shift = '1') then       --if shift set
      sreg <= sreg(n-2 downto 0) & inp.din; --shift data in
     end if;
    end if;
   end if;
  end if;
 end process ctlreg1;

end Behavioral;

