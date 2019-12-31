--------------------------------------------------------------------------------<
-- Company: 
-- Engineer:
--
-- Create Date:   05:31:53 02/01/2015
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6/PhaseCtrTest.vhd
-- Project Name:  Spartan6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PhaseCounter
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

use work.SimProc.all;

ENTITY PhaseCtrTest IS
END PhaseCtrTest;

ARCHITECTURE behavior OF PhaseCtrTest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component PhaseCounter
  generic (opBase : unsigned;
           opBits : positive := 8;
           phaseBits : positive := 16;
           totalBits : positive := 32;
           outBits : positive := 32);
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in std_logic;
  op : in unsigned (opBits-1 downto 0);
  copy : in std_logic;
  load : in std_logic;
  init : in std_logic;
  genSync : in std_logic;
  ch : in std_logic;
  sync : in std_logic;
  dir : in std_logic;
  dout : out std_logic  := '0';
  syncOut : out std_logic := '0');
 end component;
 
 constant opBase : unsigned := x"01";
 constant opBits : positive := 8;
 constant phaseBits : positive := 16;
 constant totalBits : positive := 16;
 constant outBits : positive := 32;

 --Inputs
 signal din : std_logic := '0';
 signal dshift : std_logic := '0';
 signal op : unsigned (opBits-1 downto 0) := (opBits-1 downto 0 => '0');
 signal copy : std_logic := '0';
 signal load : std_logic := '0';
 signal init : std_logic := '0';
 signal genSync : std_logic := '0';
 signal ch : std_logic := '0';
 signal sync : std_logic := '0';
 signal dir : std_logic := '0';

 --Outputs
 signal dout : std_logic;
 signal syncOut : std_logic;

begin
 
 -- Instantiate the Unit Under Test (UUT)
 phase_counter: PhaseCounter
  generic map (opBase => opBase,
               opBits => opBits,
               phaseBits => phaseBits,
               totalBits => totalBits,
               outBits => outBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   load => load,
   init => init,
   genSync => genSync,
   ch => ch,
   sync => sync,
   dir => dir,
   dout => dout,
   syncOut => syncOut
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

  variable phaseVal : integer;

 begin		
  -- hold reset state for 100 ns.
  wait for 100 ns;

  wait for clk_period*10;

  delay(5);

  -- insert stimulus here 

  phaseVal := 15;

  op <= opBase;
  loadShift(phaseVal, phaseBits, dshift, din);
  op <= x"00";

  init <= '1';
  delay(3);
  init <= '0';
  delay(1);

  genSync <= '1';
  dir <= '0';

  delayCh(30, ch);

  dir <= '1';

  delayCh(30, ch);

  genSync <= '0';

  for i in 0 to 5 loop
   delayCh(phaseVal-3, ch);
   sync <= '1';
   delayCh(3+1, ch);
   sync <= '0';
  end loop;
  
  delayCh(30, ch);

  delay(3);
  dir <= '0';
  delay(3);

  delayCh(30, ch);

  op <= opBase+1;
  readShift(phaseBits, copy, dShift, dout);

  wait;
 end process;

end;
