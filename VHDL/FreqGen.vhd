-- Create Date:    05:52:53 01/29/2015 

library ieee;

use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

use work.RegDef.opb;
use work.IORecord.all;

entity FreqGen is
 generic (opVal    : unsigned;
          freqBits : positive);
 port (
  clk      : in  std_logic;
  inp      : in  DataInp;
  ena      : in  std_logic;
  pulseOut : out std_logic := '0'
  );
end FreqGen;

architecture Behavioral of FreqGen is

 signal counter : unsigned(freqBits-1 downto 0) := (others =>'0');
 signal freqVal : unsigned(freqBits-1 downto 0);

begin

 freqreg : entity work.ShiftOp
  generic map (opVal => opVal,
               n     => freqBits)
  port map (
   clk  => clk,
   inp  => inp,
   data => freqVal);

 FreqGen: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if (ena = '1') then                  --if enabled
    if (counter = (freqBits-1 downto 0 => '0')) then --if counter zero
     counter <= freqVal;                --reload counter
     pulseOut <= '1';                   --activate frequency pulse
    else                                --if counter non zero
     pulseOut <= '0';                   --clear output pulse
     counter <= counter - 1;            --count down
    end if;
   else                                 --if not enabled
    pulseOut <= '0';                   --reset counter pulse
   end if;
  end if;
 end process FreqGen;

end Behavioral;
