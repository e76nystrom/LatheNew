--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:52:53 01/29/2015 
-- Design Name: 
-- Module Name:    FreqGen - Behavioral 
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

entity FreqGen is
 generic(opVal : unsigned;
         opBits : positive := 8;
         freqBits : positive);
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in boolean;
  load : in boolean;
  op : in unsigned(opBits-1 downto 0);
  ena : in std_logic;
  pulseOut : out std_logic := '0'
  );
end FreqGen;

architecture Behavioral of FreqGen is

 signal counter : unsigned(freqBits-1 downto 0) := (others =>'0');
 signal freqVal : unsigned(freqBits-1 downto 0);

begin

 freqreg : entity work.ShiftOp
  generic map(opVal => opVal,
              opBits => opBits,
              n => freqBits)
  port map (
   clk => clk,
   shift => dshift,
   op => op,
   din => din,
   data => freqVal);

 FreqGen: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if (ena = '1') then                  --if enabled
    if (counter = (freqBits-1 downto 0 => '0')) then --if counter zero
     counter <= freqVal;               --reload counter
     pulseOut <= '1';                  --activate frequency pulse
    else                                --if counter non zero
     pulseOut <= '0';                  --clear output pulse
     counter <= counter - 1;            --count down
    end if;
   else                                 --if not enabled
    pulseOut <= '0';                   --reset counter pulse
   end if;
  end if;
 end process FreqGen;

end Behavioral;

