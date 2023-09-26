-- Create Date:    05:59:16 04/24/2015 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.all;

entity Encoder is
 generic(opBase       : unsigned := x"00";
         cycleLenBits : positive := 16;
         encClkBits   : positive := 24;
         cycleClkbits : positive := 32;
         outBits      : positive := 32);
 port(
  clk    : in std_logic;                --system clock
  inp    : DataInp;
  oRec   : DataOut;
  init   : in std_logic;                --init signal
  ena    : in std_logic;                --enable input
  ch     : in std_logic;                --input clock
  dout   : out std_logic := '0';        --data out
  active : out std_logic := '0';        --active
  intclk : out std_logic := '0'         --output clock
  );
end Encoder;

architecture Behavioral of Encoder is

 signal cmpTmrDout : std_logic;
 signal intTmrDout : std_logic;

 signal encCycleDone : std_logic;
 signal cycleClocks : unsigned (cycleClkBits-1 downto 0);

 signal intClkOut : std_logic;
 signal intActive : std_logic;

begin

 dout <= cmpTmrDout or intTmrDout;

 cmp_tmr : entity work.CmpTmrNewMem
  generic map (opBase       => opBase + 0,
               cycleLenBits => cycleLenBits,
               encClkBits   => encClkBits,
               cycleClkbits => cycleClkBits,
               outBits      => outBits)
  port map (
   clk          => clk,
   inp          => inp,
   init         => init,
   dout         => cmpTmrDout,
   oRec         => oRec,
   ena          => ena,
   encClk       => ch,
   encCycleDone => encCycleDone,
   cycleClocks  => cycleClocks
   );

 active <= intActive;
 intClk <= intClkOUt;

 int_tmr : entity work.IntTmrNew
  generic map (opBase       => opBase + 0,
               cycleLenBits => cycleLenBits,
               encClkBits   => encClkBits,
               cycleClkbits => cycleClkBits)
  port map (
   clk         => clk,
   inp         => inp,
   init         => init,
   dout         => intTmrDout,
   intClk       => intClkOut,
   Active       => intActive,
   encCycleDone => encCycleDone,
   cycleClocks  => cycleClocks
   );

end Behavioral;
