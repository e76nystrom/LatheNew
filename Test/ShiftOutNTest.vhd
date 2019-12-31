library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

use work.SimProc.all;
use work.RegDef.all;

entity ShiftOutNTest is
end ShiftOutNTest;
architecture behavior OF ShiftOutNTest is

 component ShiftOutN is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive;
          outBits : positive);
  port (
   clk : in std_logic;
   dshift : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   load : in std_logic;
   data : in unsigned(n-1 downto 0);
   dout : out std_logic
   );
 end Component;

 constant opVal : unsigned := x"05";
 constant opBits : positive := 8;
 constant n : positive := 8;
 constant outBits : positive := 32;

 signal clk : std_logic := '0';
 signal dshift : std_logic := '0';
 signal op : unsigned (opBits-1 downto 0) := (opBits-1 downto 0 => '0');
 signal load : std_logic := '0';
 signal data : unsigned(n-1 downto 0) := (n-1 downto 0 => '0');
 signal dout : std_logic := '0';

 signal result : unsigned (32-1 downto 0) := (others => '0');

begin

 uut : ShiftOutN
  generic map(opVal => opVal,
              opBits => opBits,
              n => n,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   load => load,
   data => data,
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

--variables

 begin

-- hold reset state for 100 ns.

  wait for 100 ns;

  delay(10);

  -- insert stimulus here

  data <= x"aa";
  delay(1);
  op <= opVal;
  load <= '1';
  delay(1);
  load <= '0';
  dshift <= '1';
  for i in 0 to 32-1 loop
   wait until (clk = '1');
   result <= result(32-2 downto 0) & dout;
   wait until (clk = '0');
  end loop;
  dshift <= '0';
  delay(1);o
  op <= x"00";

  wait;
 end process;

end;
