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
  -- din : in std_logic;                    --spi data in
  -- dshift : in boolean;                   --spi shift signal
  -- op : in unsigned (opBits-1 downto 0);  --current operation
  -- load : in boolean;                     --load value

  oRec   : DataOut;
  -- dshiftR : in boolean;                  --spi shift signal
  -- opR : in unsigned (opBits-1 downto 0); --current operation
  -- copyR : in boolean;                    --copy for output

  init   : in std_logic;                --init signal
  ena    : in std_logic;                 --enable input
  ch     : in std_logic;                 --input clock
  dout   : out std_logic := '0';         --data out
  active : out std_logic := '0';         --active
  intclk : out std_logic := '0'          --output clock
  );
end Encoder;

architecture Behavioral of Encoder is

 -- component CmpTmrNewMem
 --  generic (opBase : unsigned := x"00";
 --           opBits : positive := 8;
 --           cycleLenBits : positive := 16;
 --           encClkBits : positive := 24;
 --           cycleClkbits : positive := 32;
 --           outBits : positive := 32);
 --  port(
 --   clk : in std_logic;                  --system clock
 --   din : in std_logic;                  --spi data in
 --   dshift : in boolean;                 --spi shift signal
 --   op: in unsigned (opBits-1 downto 0);  --current operation
 --   dshiftR : in boolean;                --spi shift signal
 --   opR: in unsigned (opBits-1 downto 0);  --current operation
 --   copyR: in boolean;                   --copy for output
 --   init : in std_logic;                 --init signal
 --   ena : in std_logic;                  --enable input
 --   encClk : in std_logic;               --encoder clock
 --   dout: out std_logic;                 --data out
 --   encCycleDone: out std_logic;         --encoder cycle done
 --   cycleClocks: inout unsigned (cycleClkBits-1 downto 0) --cycle counter
 --   );
 -- end component;

 -- component IntTmrNew is
 --  generic (opBase : unsigned := x"00";
 --           opBits : positive := 8;
 --           cycleLenBits : positive := 16;
 --           encClkBits : positive := 24;
 --           cycleClkbits : positive := 32);
 --  port(
 --   clk : in std_logic;                  --system clock
 --   din : in std_logic;                  --spi data in
 --   dshift : in boolean;                 --spi shift in
 --   op: in unsigned (opBits-1 downto 0); --current operation
 --   dout: out std_logic;                 --data out
 --   init : in std_logic;                 --init signal
 --   intClk : out std_logic;              --output clock
 --   active : out std_logic;              --active
 --   encCycleDone: in std_logic;          --encoder cycle done
 --   cycleClocks: in unsigned (cycleClkBits-1 downto 0) --cycle counter
 --   );
 -- end component;

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
   -- din => din,
   -- dshift => dshift,
   -- op => op,

   init         => init,
   dout         => cmpTmrDout,
   oRec         => oRec,
   -- dshiftR => dshiftR,
   -- opR => opR,
   -- copyR => copyR,

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
   -- din => din,
   -- dshift => dshift,
   -- op => op,

   init         => init,
   dout         => intTmrDout,
   intClk       => intClkOut,
   Active       => intActive,
   encCycleDone => encCycleDone,
   cycleClocks  => cycleClocks
   );

end Behavioral;
