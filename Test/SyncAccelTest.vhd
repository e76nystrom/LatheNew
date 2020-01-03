--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:56:06 01/26/2015
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6/SyncAccelTest.vhd
-- Project Name:  Spartan6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Synchronizer
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
use work.RegDef.all;

ENTITY SyncAccelTest IS
END SyncAccelTest;

ARCHITECTURE behavior OF SyncAccelTest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component SyncAccel is
  generic (opBase : unsigned;
           opBits : positive;
           synBits : positive;
           posBits : positive;
           countBits : positive;
           outBits : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   copy : in std_logic;
   load : in std_logic;
   init : in std_logic;                  --reset
   ena : in std_logic;                   --enable operation
   decel : in std_logic;
   ch : in std_logic;
   dir : in std_logic;
   dout : out std_logic;
   accelActive : out std_logic;
   accelFlag : out std_logic;
   synStep : out std_logic
   );
 end Component;

 component DistCounter is
  generic (opBase : unsigned;
           opBits : positive;
           distBits : positive;
           outBits :  positive);
  Port (
   clk : in  std_logic;
   din : in std_logic;
   dshift : in std_logic;
   op : in unsigned(opBits-1 downto 0);  --current reg address
   copy : in std_logic;
   init : in std_logic;                  --reset
   step : in std_logic;                  --all steps
   accelFlag : in std_logic;             --acceleration step
   dout : out std_logic;                 --data output
   decel : inout std_logic;              --dist le acceleration steps
   distZero : out std_logic              --distance zero
   );
 end Component;

 constant opBits : positive := 8;
 constant synBits : positive := 32;
 constant posBits : positive := 18;
 constant distBits : positive := 18;
 constant countBits : positive := 18;
 constant outBits : positive := 32;

 --Inputs
 -- signal clk : std_logic := '0';
 signal init : std_logic := '0';
 signal ena : std_logic := '0';
 signal decel : std_logic := '0';
 signal ch : std_logic := '0';
 signal dir : std_logic := '0';
 signal din : std_logic := '0';
 signal dshift : std_logic := '0';
 signal op : unsigned(opBits-1 downto 0) := (opBits-1 downto 0 => '0');
 signal copy : std_logic := '0';
 signal load : std_logic := '0';

 signal dist_sel : std_logic := '0';

 signal distCtr : unsigned(distBits-1 downto 0);
 signal aclSteps : unsigned(distBits-1 downto 0);

 --Outputs
 signal dout : std_logic;
 signal accelFlag : std_logic;
 signal accelActive : std_logic;
 signal synstp : std_logic;

 signal distZero : std_logic;
 
 signal tmp : signed(synBits-1 downto 0);
 signal tmp1 : signed(countBits-1 downto 0);
 signal tmp2 : signed(distBits-1 downto 0);

 signal syncEna : std_logic;

BEGIN

 syncEna <= ena and not distZero;

 -- Instantiate the Unit Under Test (UUT)
 uut : SyncAccel
  generic map (opBase => F_ZAxis_Base,
               opBits => opBits,
               synBits => synBits,
               posBits => posBits,
               countBits => countBits,
               outBits => outBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   load => load,
   init => init,
   ena => syncEna,
   decel => decel,
   ch => ch,
   dir => dir,
   dout => dout,
   accelActive => accelActive,
   accelFlag => accelFlag,
   synStep => synStp
   );

 AxisDistCounter : DistCounter
  generic map (opBase => F_ZAxis_Base + F_Dist_Base,
               opBits => opBits,
               distBits => distBits,
               outBits => outBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   init => init,
   step => synStp,
   accelFlag => accelFlag,
   dout => dout,
   decel => decel,
   distZero => distZero
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

  variable count : integer;

  variable dx : integer;
  variable dy : integer;
  variable d  : integer;
  variable incr1 : integer;
  variable incr2 : integer;
  variable accelVal : integer;
  variable accelCount : integer;
  variable dist : integer;

 begin		
  -- hold reset state for 100 ns.
  wait for 100 ns;	

  wait for clk_period*10;

  -- insert stimulus here

  dx := 2540 * 8;
  dy := 600;

  --dx := 87381248;
  --dy := 341258;

  dist := 20;

  incr1 := 2 * dy;
  incr2 := 2 * (dy - dx);
  d := incr1 - dx;

  accelVal := 8;
  accelCount := 99;

  op <= F_ZAxis_Base + F_Ld_D;
  loadShift(d, synBits, dshift, din);

  delay(1);

  op <= F_ZAxis_Base + F_Ld_Incr1;
  loadShift(incr1, synBits, dshift, din);

  delay(1);

  op <= F_ZAxis_Base + F_Ld_Incr2;
  loadShift(incr2, synBits, dshift, din);

  delay(1);

  op <= F_ZAxis_Base + F_Ld_Accel_Val;
  loadShift(accelVal, synBits, dshift, din);

  delay(1);

  op <= F_ZAxis_Base + F_Ld_Accel_Count;
  loadShift(accelCount, countBits, dshift, din);
  
  delay(1);

  op <= F_ZAxis_Base + F_Dist_Base + F_Ld_Dist;
  loadShift(dist, distBits, dshift, din);

  delay(5);
    
  init <= '1';
  delay(5);
  init <= '0';

  ena <= '1';
  
  delay(5);

  dir <= '1';
  for j in 0 to 10000 loop
   ch <= '1';
   delay(4);
   ch <= '0';
   delay(4);
  end loop;

  wait;
 end process;

END;
