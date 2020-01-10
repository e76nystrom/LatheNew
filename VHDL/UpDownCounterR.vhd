--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:58:16 01/28/2015 
-- Design Name: 
-- Module Name:    UpDownCounterRng - Behavioral 
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

entity UpDownCounterRng is
 generic(n : positive);
 port ( clk : in std_logic;
        load : in std_logic;
        ena : in std_logic;
        inc : in std_logic;
        preset : in unsigned(n-1 downto 0);
        counter : inout unsigned(n-1 downto 0) := (others => '0');
        limit : out std_logic := '0'
        );
end UpDownCounterRng;

architecture Behavioral of UpDownCounterRng is

signal atMax : std_logic := '0';
signal atMin : std_logic := '0';
signal lastEna : std_logic := '0';

begin

 limit <= atMax when inc = '1' else atMin;
 
 UpDownCounter: process(clk)
 begin
  if (rising_edge(clk)) then
   if (load = '1') then                 --if load
    counter <= preset;                  --set to preseet
   elsif ((ena = '1') and (lastEna = '0')) then --if enabled to count
    if (inc = '1') then                 --if increment
     if (atMax = '0') then              --if not at maximum
      counter <= counter + 1;           --increment counter
     end if;
    else                                --if decrement
     if (atMin = '0') then              --if not at minimum
      counter <= counter - 1;           --decrement counter
     end if;
    end if;      
   else                                 --if not load or enable
    if (counter = preset) then         --if coutner at preset
     atMax <= '1';                     --set at maximum
    else
     atMax <= '0';                     --clear at maximum
    end if;

    if counter = (n-1 downto 0 => '0') then  --if counter zero
     atMin <= '1';                     --set at minimum
    else
     atMin <= '0';                     --clear at minimum
    end if;
   end if;
   lastEna <= ena;                      --update last enable
  end if;
 end process UpDownCounter;

end Behavioral;
