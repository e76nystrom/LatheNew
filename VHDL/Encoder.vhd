-- Create Date:    05:59:16 04/24/2015 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.all;
use work.DbgRecord.all;

entity Encoder is
 generic (opBase        : unsigned := x"00";
          preScalerBits : positive := 16;
          cycleLenBits  : positive := 16;
          encClkBits    : positive := 24;
          cycleClkbits  : positive := 32;
          outBits       : positive := 32);
 port (
  clk    : in std_logic;                --system clock
  inp    : in DataInp;
  oRec   : in DataOut;
  
  init   : in std_logic;                --init signal
  ena    : in std_logic;                --enable input
  ch     : in std_logic;                --input clock

  dbg    : out EncScaleDbg;
  dout   : out EncoderData;
  active : out std_logic := '0';        --active
  intclk : out std_logic := '0'         --output clock
  );
end Encoder;

architecture Behavioral of Encoder is

 signal encCycleDone : std_logic;
 signal cycleClocks  : unsigned (cycleClkBits-1 downto 0);

 signal intClkOut    : std_logic;
 signal intActive    : std_logic;

 signal preScalerVal : unsigned(preScalerBits-1 downto 0) := (others => '0');
 signal preScalerCtr : unsigned(preScalerBits-1 downto 0) := (others => '0');

 signal lastCh       : std_logic := '0';
 signal scaleCh      : std_logic := '0';

 signal usePreScaler : std_logic := '0';
 signal encCh        : std_logic := '0';

 signal cmpUpd       : std_logic := '0';

begin

 preScaler : entity work.ShiftOp
  generic map (opVal  => opBase + F_Ld_Enc_Prescale,
               n      => preScalerBits)
  port map (
   clk   => clk,
   inp   => inp,
   data  => preScalerVal);

 usePreScaler <= '1' when preScalerVal /= 0 else '0';
 encCh <= ch when usePreScaler = '0' else scaleCh;

 dbg.cycleDone <= encCycleDone;
 dbg.cmpUpd    <= cmpUpd;
 dbg.intClk    <= intClkOut;

 cmp_tmr : entity work.CmpTmrNewMem
  generic map (opBase       => opBase + 0,
               cycleLenBits => cycleLenBits,
               encClkBits   => encClkBits,
               cycleClkbits => cycleClkBits,
               outBits      => outBits)
  port map (
   clk          => clk,
   init         => init,
   inp          => inp,
   oRec         => oRec,
   ena          => ena,
   encClk       => encCh,
   cmpUpd       => cmpUpd,
   dout         => dout.cmpTmr,
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
   clk          => clk,
   init         => init,
   inp          => inp,
   oRec         => oRec,
   intClk       => intClkOut,
   dout         => dout.intTmr,
   active       => intActive,
   encCycleDone => encCycleDone,
   cycleClocks  => cycleClocks
   );

 enc_process: process(clk)

 begin
  
  if (rising_edge(clk)) then            --if clock active

   if (init = '1') then                 --if init
    preScalerCtr <= (others => '0');
   else

    if (ena = '1' and usePreScaler = '1') then --if enabled

     if (lastCh = '0' and ch = '1') then
      if (preScalerCtr = 0) then
       preScalerCtr <= preScalerVal;
       scaleCh      <= '1';
      else
       preScalerCtr <= preScalerCtr - 1;
      end if;
     else
       scaleCh <= '0';
     end if;

    end if;                             --enabled

    lastCh <= ch;
    
   end if;                              --init
   
  end if;                               --end rising_edge
 end process;

end Behavioral;
