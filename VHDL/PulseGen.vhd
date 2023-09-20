--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:43:37 01/29/2015 
-- Design Name: 
-- Module Name:    PulseGen - Behavioral 
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

entity PulseGen is
 generic(pulseWidth : positive := 400);
 port ( clk : in std_logic;
        pulseIn : in std_logic;
        pulseOut : out std_logic := '0');
end PulseGen;

architecture Behavioral of PulseGen is

 signal counter : integer range 0 to pulseWidth-1 := 0; --z step width counter

 signal clkena : std_logic;

begin

 clk_ena : entity work.ClockEnableN
  port map (
   clk => clk,
   ena => pulseIn,
   clkena => clkena);

 PulseGen: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if ((clkena = '1')) then             --if time to start step pulse
    counter <= pulseWidth-1;            --set step width counter
    pulseOut <= '1';                    --set step output
   else                                 --if not time to start pulse
    if (counter /= 0) then              --if counter is non zero
     counter <= counter - 1;            --count down
    else                                --if counter is zero
     pulseOut <= '0';                   --clear step pulse
    end if;
   end if;
  end if;
 end process PulseGen;

end Behavioral;
