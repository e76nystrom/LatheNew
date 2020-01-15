library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

use work.SimProc.all;
use work.RegDef.all;

entity DisplayCtlTest is
end DisplayCtlTest;
architecture behavior OF DisplayCtlTest is

 component DisplayCtl is
  generic (opVal : unsigned;
           opBits : positive;
           displayBits : positive;
           outBits : positive
           );
  port (
   clk : in std_logic;
   dsel : in Std_logic;
   din : in std_logic;
   shift : in boolean;
   op : in unsigned (opBits-1 downto 0);
   dout : in std_logic;
   dspCopy : out boolean;
   dspShift : out boolean;
   dspOp : inout unsigned (opBits-1 downto 0);
   dspreg : inout unsigned (displayBits-1 downto 0)
   );
 end Component;

 component SPI is
  generic (opBits : positive);
  port (
   clk : in std_logic;                    --system clock
   dclk : in std_logic;                   --spi clk
   dsel : in std_logic;                   --spi select
   din : in std_logic;                    --spi data in
   op : out unsigned(opBits-1 downto 0); --op code
   copy : out boolean;          --copy data to be shifted out
   shift : out boolean;         --shift data
   load : out boolean;          --load data shifted in
   header : inout boolean
   --info : out std_logic_vector(2 downto 0) --state info
   );
 end Component;

 component ShiftOutN is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive;
          outBits : positive);
  port (
   clk : in std_logic;
   dshift : in boolean;
   op : in unsigned (opBits-1 downto 0);
   load : in boolean;
   data : in unsigned(n-1 downto 0);
   dout : out std_logic
   );
 end Component;

 constant opVal : unsigned := x"05";
 constant opBits : positive := 8;
 constant displayBits : positive := 16;
 constant outBits : positive := 32;
 
 signal clk : std_logic := '0';
 signal dsel : Std_logic := '1';
 signal din : std_logic := '0';
 signal shift : boolean := false;
 signal op : unsigned (opBits-1 downto 0) := (others => '0');
 signal dout : std_logic := '0';
 signal dspCopy : boolean := false;
 signal dspShift : boolean := false;
 signal dspOp : unsigned (opBits-1 downto 0) := (others => '0');
 signal dspreg : unsigned (displayBits-1 downto 0) := (others => '0');

 signal dclk : std_logic := '0';
 signal testReg : unsigned (displayBits-1 downto 0) := (others => '0');

 constant opDisplay : unsigned := x"0a";

begin

 uut : DisplayCtl
  generic map (opVal => opVal,
               opBits => opBits,
               displayBits => displayBits,
               outBits => outBits
               )
  port map (
   clk => clk,
   dsel => dsel,
   din => din,
   shift => shift,
   op => op,
   dout => dout,
   dspCopy => dspCopy,
   dspShift => dspShift,
   dspOp => dspOp,
   dspreg => dspreg
   );

 spiProc : SPI
  generic map (opBits => opBits)
  port map (
   clk => clk,
   dclk => dclk,
   dsel => dsel,
   din => din,
   op => op,
   copy => open,
   shift => shift,
   load => open,
   header => open
   );

 shiftProc : ShiftOutN
  generic map(opVal => opDisplay,
              opBits => opBits,
              n => displayBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => DSPsHIFT,
   op => dspOp,
   load => dspCopy,
   data =>  testReg,
   dout => dout
   );

 -- Clock process definitions

 clkProcess :process
 begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
 end process;

 -- Stimulus process

 stimProc: process

  procedure delay(constant n : in integer) is
  begin
   for i in 0 to n-1 loop
    wait until (clk = '1');
    wait until (clk = '0');
   end loop;
  end procedure delay;

  procedure loadParm(
   constant parmIdx : in unsigned (opbx-1 downto 0)) is
   variable i : integer := 0;
   variable tmp : unsigned (opbx-1 downto 0);
  begin
   dsel <= '0';                          --start of load
   delay(10);

   tmp := parmIdx;
   for i in 0 to opbx-1 loop             --load parameter
    dclk <= '0';
    din <= tmp(opbx-1);
    tmp := shift_left(tmp, 1);
    delay(2);
    dclk <= '1';
    delay(6);
   end loop;
   din <= '0';
   dclk <= '0';

   delay(10);
  end procedure loadParm;

  procedure loadValue(constant value : in integer;
                      constant bits : in natural) is
   variable tmp : unsigned (32-1 downto 0);
  begin
   tmp := to_unsigned(value, 32);
   for i in 0 to bits-1 loop             --load value
    dclk <= '0';
    din <= tmp(bits-1);
    delay(6);
    dclk <= '1';
    tmp := shift_left(tmp, 1);
    delay(6);
   end loop;
   din <= '0';
   dclk <= '0';

   dsel <= '1';                          --end of load
   delay(10);
  end procedure loadValue;

  --variables

 begin

  -- hold reset state for 100 ns.

  wait for 100 ns;

  delay(10);

  -- insert stimulus here

  dsel <= '1';
  delay(20);
  testReg <= x"aaaa";
  loadParm(opVal);
  loadValue(to_integer(opDisplay), opBits);
  delay(40);

  wait;
 end process;

end;
