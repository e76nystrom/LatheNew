library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RegDef.all;
use work.IORecord.all;

entity Scaler is
 generic (opVal     : unsigned;
          scaleBits : positive := 4);
 port (
  clk      : in std_logic;
  inp      : in DataInp;
  init     : in std_logic;
  inPulse  : in std_logic;
  outPulse : out std_logic := '0'
  );
end Scaler;

architecture Behavioral of Scaler is

 signal lastInPulse : std_logic := '0';

 signal scaleVal    : unsigned(scaleBits-1 downto 0) := (others => '0');
 signal scaleCtr    : unsigned(scaleBits-1 downto 0) := (others => '0');

begin

 spScale : entity work.ShiftOp
  generic map (opVal => opVal,
               n     => scaleBits)
  port map (
   clk  => clk,
   inp  => inp,
   data => scaleVal
   );
 
 SpScaler: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active

   if (init = '1') then
    scaleCtr <= (others => '0');
   else

    if (inPulse = '1' and lastInPulse = '0') then --rising edge
     if (scaleCtr = 0) then
      scaleCtr <= scaleVal;
      outPulse  <= '1';
     else
      scaleCtr <= scaleCtr - 1;
     end if;
    else
    outPulse <= '0';
    end if;

   end if;
   
   lastInPulse <= inPulse;

  end if;
 end process;

end Behavioral;
