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
  clk  : in  std_logic;                 --clock
  inp  : in  DataInp;
  data : out std_logic_vector (n-1 downto 0) := (others => '0')); --data reg
end CtlReg;

architecture Behavioral of CtlReg is

signal sreg    : std_logic_vector (n-1 downto 0) := (others => '0');
signal lastSel : std_logic := '0';
begin

ctlreg1: process (clk)
 begin
  if (rising_edge(clk)) then
   if (inp.op = opVal) then
    if (inp.shift = '1') then           --if shift set
     lastSel  <= '1';
     sreg <= sreg(n-2 downto 0) & inp.din; --shift data in
    end if;
   else
    if (lastSel = '1') then
     lastSel <= '0';
     data <= sreg;
    end if;
   end if;
  end if;
 end process ctlreg1;

end Behavioral;
