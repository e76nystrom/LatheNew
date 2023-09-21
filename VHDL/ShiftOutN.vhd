-- Create Date:    17:02:29 01/24/2015 

library ieee;

use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

use work.RegDef.opb;
use work.IORecord.DataOut;

entity ShiftOutN is
 generic(opVal   : unsigned (opb-1 downto 0);
         n       : positive;
         outBits : positive);
 port (
  clk  : in std_logic;
  oRec : in DataOut;
  data : in unsigned(n-1 downto 0);

  dout : out std_logic := '0'
  );
end ShiftOutN;

architecture Behavioral of ShiftOutN is

 signal shiftSel : boolean := false;
 signal shiftReg : unsigned(n-1 downto 0) := (n-1 downto 0 => '0');
 signal padding :  integer range 0 to outBits-n;

begin

 dout <= shiftReg(n-1) when (shiftSel and (padding = 0)) else
         '0';

 shiftout: process (clk)
 begin
  if (rising_edge(clk)) then
   if (oRec.op = opVal) then
    shiftSel <= true;
   else
    shiftSel <= false;
   end if;
   
   if (shiftSel and (oRec.copy = '1')) then
    shiftReg <= data;
    padding <= 32-n;
   else 
    if (shiftSel and (oRec.shift = '1')) then
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

