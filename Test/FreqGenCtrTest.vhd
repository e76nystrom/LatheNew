--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:39:32 12/12/2019
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6Encoder/FreqGenCtrTest.vhd
-- Project Name:  Spartan6Encoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FreqGenCtr
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
use ieee.std_logic_arith.conv_std_logic_vector;

use work.RegDef.all;
use work.SimProc.all;
 
entity FreqGenCtrTest IS
END FreqGenCtrTest;
 
ARCHITECTURE behavior OF FreqGenCtrTest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component FreqGenCtr
  generic(opBase : unsigned;
          opBits : positive := 8;
          freqBits : positive;
          countBits: positive);
  port(
   clk : in std_logic;
   din : in std_logic;
   dshift : in std_logic;
   op : in unsigned(opBits-1 downto 0);
   load : in std_logic;
   ena : in std_logic;
   pulseOut : out std_logic
   );
 end component;

 constant opBits : positive := 8;
 constant opBase : unsigned (opBits-1 downto 0) := x"01";
 constant freqBits : integer := 4;
 constant countBits : integer := 5;

 --Inputs
 signal clk : std_logic := '0';
 signal din : std_logic := '0';
 signal dshift : std_logic := '0';
 signal op : unsigned(opBits-1 downto 0) := (others => '0');
 signal load : std_logic := '0';
 signal ena : std_logic := '0';

 --Outputs
 signal pulseOut : std_logic;

begin
 
 -- Instantiate the Unit Under Test (UUT)
 uut: FreqGenCtr
  generic map(opBase => opBase,
              opBits => opb,
              freqBits => freqBits,
              countBits => countBits)
  port map (
  clk => clk,
  din => din,
  dshift => dshift,
  op => op,
  load => load,
  ena => ena,
  pulseOut => pulseOut
  );

 -- Clock process definitions
 clk_process :process
 begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
 end process;
 

 -- Stimulus process
 stim_proc: process

 procedure delay(constant n : in integer) is
 begin
  for i in 0 to n-1 loop
   wait until (clk = '1');
   wait until (clk = '0');
  end loop;
 end procedure delay;

 procedure loadShift(variable value : in integer;
                     constant bits : in natural) is
  variable tmp: std_logic_vector(32-1 downto 0);
 begin
  tmp := conv_std_logic_vector(value, 32);
  dshift <= '1';
  for i in 0 to bits-1 loop
   din <= tmp(bits - 1);
   wait until clk = '1';
   tmp := tmp(31-1 downto 0) & tmp(31);
   wait until clk = '0';
  end loop;
  dshift <= '0';
  load <= '1';
  delay(1);
  load <= '0';
 end procedure loadShift;

 variable freqVal : natural;
 variable countVal : natural;

 begin		
  -- hold reset state for 100 ns.
  wait for 100 ns;	

  wait for clk_period*10;

  -- insert stimulus here

  op <= opBase + F_Ld_Dbg_Freq;
  freqVal := 3;
  loadShift(freqVal, freqBits);
  
  op <= opBase + F_Ld_Dbg_Count;
  countVal := 4;
  loadShift(countVal, countBits);

  op <= F_Noop;
  ena <= '1';
  delay(50);

  op <= opBase + F_Ld_Dbg_Count;
  countVal := 1;
  loadShift(countVal, countBits);

  op <= F_Noop;
  delay(50);
  ena <= '0';

  op <= opBase + F_Ld_Dbg_Count;
  countVal := 0;
  loadShift(countVal, countBits);

  ena <= '1';
  op <= F_Noop;
  delay(100);
  ena <= '0';

  wait;
 end process;

END;
