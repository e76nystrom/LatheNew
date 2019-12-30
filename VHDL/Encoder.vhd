--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:59:16 04/24/2015 
-- Design Name: 
-- Module Name:    Encoder - Behavioral 
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

use work.regDef.all;

entity Encoder is
 generic(opBase : unsigned := x"00";
         opBits : positive := 8;
         cycleLenBits : positive := 16;
         encClkBits : positive := 24;
         cycleClkbits : positive := 32;
         outBits : positive := 32);
 port(
  clk : in std_logic;                   --system clock
  din : in std_logic;                   --spi data in
  dshift : in std_logic;                --spi shift signal
  op : in unsigned (opBits-1 downto 0); --current operation
  copy : in std_logic;                  --copy for output
  load : in std_logic;                  --load value
  init : in std_logic;                  --init signal
  ena : in std_logic;                   --enable input
  ch : in std_logic;                    --input clock
  dout : out std_logic := '0';          --data out
  intclk : out std_logic := '0'         --output clock
  );
end Encoder;

architecture Behavioral of Encoder is

 component CmpTmr
  generic (opBase : unsigned := x"00";
           opBits : positive := 8;
           cycleLenBits : positive := 16;
           encClkBits : positive := 24;
           cycleClkbits : positive := 32;
           outBits : positive := 32);
  port(
   clk : in std_logic;                   --system clock
   din : in std_logic;                   --spi data in
   dshift : in std_logic;                --spi shift signal
   op: in unsigned (opBits-1 downto 0);  --current operation
   copy: in std_logic;                   --copy for output
   init : in std_logic;                  --init signal
   ena : in std_logic;                   --enable input
   encClk : in std_logic;                --encoder clock
   dout: out std_logic;                  --data out
   encCycleDone: out std_logic;          --encoder cycle done
   cycleClocks: inout unsigned (cycleClkBits-1 downto 0) --cycle counter
   );
 end component;

 component IntTmr is
  generic (opBase : unsigned := x"00";
           opBits : positive := 8;
           cycleLenBits : positive := 16;
           encClkBits : positive := 24;
           cycleClkbits : positive := 32);
  port(
   clk : in std_logic;                  --system clock
   din : in std_logic;                  --spi data in
   dshift : in std_logic;               --spi shift in
   op: in unsigned (opBits-1 downto 0); --current operation
   copy: in std_logic;                  --copy for output
   dout: out std_logic;                 --data out
   init : in std_logic;                 --init signal
   intClk : out std_logic;              --output clock
   encCycleDone: in std_logic;          --encoder cycle done
   cycleClocks: in unsigned (cycleClkBits-1 downto 0) --cycle counter
   );
 end component;

 signal cmpTmrDout : std_logic;
 signal intTmrDout : std_logic;

 signal encCycleDone : std_logic;
 signal cycleClocks : unsigned (cycleClkBits-1 downto 0);

 signal intClkOut : std_logic;

begin

 dout <= cmpTmrDout or intTmrDout;

 cmp_tmr : CmpTmr
  generic map (opBase => opBase + 0,
               opBits => opBits,
               cycleLenBits => cycleLenBits,
               encClkBits => encClkBits,
               cycleClkbits => cycleClkBits,
               outBits => outBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   init => init,
   ena => ena,
   encClk => ch,
   dout => cmpTmrDout,
   encCycleDone => encCycleDone,
   cycleClocks => cycleClocks
   );

 intClk <= intClkOUt;

 int_tmr : IntTmr
  generic map (opBase => opBase + 0,
               opBits => opBits,
               cycleLenBits => cycleLenBits,
               encClkBits => encClkBits,
               cycleClkbits => cycleClkBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   init => init,
   op => op,
   copy => copy,
   dout => intTmrDout,
   intClk => intClkOut,
   encCycleDone => encCycleDone,
   cycleClocks => cycleClocks
   );

end Behavioral;
