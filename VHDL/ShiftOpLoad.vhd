-- Create Date:    17:02:29 01/24/2015 

library ieee;

use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

use work.RegDef.opb;
use work.IORecord.DataInp;

entity ShiftOpLoad is
 generic(opVal  : unsigned (opb-1 downto 0);
         n      : positive);
 port(
  clk   : in    std_logic;
  inp   : in    DataInp;
  load  : out   std_logic := '0';
  data  : inout unsigned (n-1 downto 0) := (others => '0')
  );
end ShiftOpLoad;

  -- regX : entity work.ShiftOpLoad
  -- generic map (opVal => ,
  --              n     => )
  -- port map (
  --  clk  => ,
  --  inp  => ,
  --  load => ,
  --  data =>
  --  );

architecture Behavioral of ShiftOpLoad is

 signal lastSel : boolean := false;
begin

 shift_reg: process (clk)
 begin
  if (rising_edge(clk)) then
   if (inp.op = opVal) then             --if selected
    lastSel <= true;                    --update last value
    if (inp.shift = '1') then           --if time to shift
     data <= data(n-2 downto 0) & inp.din; --shift
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

