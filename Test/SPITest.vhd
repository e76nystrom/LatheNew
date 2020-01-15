--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:56:52 04/05/2015
-- Design Name:   
-- Module Name:   C:/Development/Xilinx/Spartan6/SPITest.vhd
-- Project Name:  Spartan6
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SPI
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
use ieee.std_logic_arith.conv_std_logic_vector;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

use work.SimProc.all;
use work.RegDef.all;

ENTITY SPITest IS
END SPITest;

ARCHITECTURE behavior OF SPITest IS 
 
 -- Component Declaration for the Unit Under Test (UUT)
 
 component SPI
  generic (opBits : positive := 8);
  PORT(
   clk : in std_logic;
   dclk : in std_logic;
   dsel : in std_logic;
   din : in std_logic;
   op : out unsigned(opBits-1 downto 0);
   copy : out std_logic;
   shift : out std_logic;
   load : out std_logic;
   header : inout std_logic;
   spiActive : out std_logic
   --info : out std_logic_vector(2 downto 0) --state info
   );
 end component;

 component ClockEnableN is
  generic (n : positive);
  Port (
   clk : in  std_logic;
   ena : in  std_logic;
   clkena : out std_logic);
 end component;

 constant valBits : positive := 32;
 constant opBits : integer := 8;
 
 --Inputs
 signal clk : std_logic := '0';
 signal dclk : std_logic := '0';
 signal dsel : std_logic := '1';
 signal din : std_logic := '0';

 --BiDirs
 signal op : unsigned(7 downto 0);

 --Outputs
 signal copy : std_logic;
 signal shift : std_logic;
 signal load : std_logic;
 signal header : std_logic;
 signal spiActive : std_logic;
 --signal info : std_logic_vector(2 downto 0);
 signal clkena1 : std_logic;

 -- Clock period definitions
 constant clk_period : time := 10 ns;

 constant testBits : integer := 32;
 --signal test_reg : unsigned(testBits-1 downto 0);
 signal test1_reg : unsigned(testBits-1 downto 0);

begin
 
 -- Instantiate the Unit Under Test (UUT)
 uut: SPI port MAP (
  clk => clk,
  dclk => dclk,
  dsel => dsel,
  din => din,
  op => op,
  copy => copy,
  shift => shift,
  load => load,
  header => header,
  spiActive => spiActive
  --info => info
  );

 clk_ena: ClockEnableN
  generic map(n => 3)
  port map (
   clk => clk,
   ena => dclk,
   clkena =>clkena1);

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

  procedure loadParm(constant parmIdx : in unsigned (opbx-1 downto 0)) is
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

  procedure loadValue(variable value : in integer;
                      constant bits : in natural) is
   variable tmp : std_logic_vector (32-1 downto 0);
  begin
   tmp := conv_std_logic_vector(value, 32);
   for i in 0 to bits-1 loop             --load value
    dclk <= '0';
    din <= tmp(bits-1);
    delay(2);
    dclk <= '1';
    tmp := tmp(31-1 downto 0) & tmp(31);
    delay(6);
   end loop;
   din <= '0';
   dclk <= '0';
   dsel <= '1';                          --end of load
   delay(10);
  end procedure loadValue;

  procedure loadMid(variable value : in integer;
                    constant bits : in natural) is
   variable tmp : std_logic_vector (32-1 downto 0);
  begin
   tmp := conv_std_logic_vector(value, 32);
   for i in 0 to bits-1 loop             --load value
    dclk <= '0';
    din <= tmp(bits-1);
    delay(2);
    dclk <= '1';
    tmp := tmp(31-1 downto 0) & tmp(31);
    delay(6);
   end loop;
   din <= '0';
   dclk <= '0';
  end procedure loadMid;

  variable parm : unsigned(opBits-1 downto 0) :=  (opBits-1 downto 0 => '0');
  variable value : unsigned(31 downto 0) :=  (31 downto 0 => '0');
  variable val : integer := 16#12345678#;

 begin		
  -- hold reset state for 100 ns.
  wait for 100 ns;	

  wait for clk_period*10;

  -- insert stimulus here 

  parm := to_unsigned(16#a5#, 8);
  value := to_unsigned(16#12345678#, valBits);

  wait for clk_period*2;
  
  -- dsel <= '0';
  -- delay(10);
  -- for i in 0 to 7 loop
  --  dclk <= '0';
  --  din <= parm(7);
  --  parm := shift_left(parm,1);
  --  delay(6);
  --  dclk <= '1';
  --  delay(6);
  -- end loop;

  -- dsel <= '1';
  -- delay(20);
  -- dsel <= '0';

  -- for i in 0 to 31 loop
  --  dclk <= '0';
  --  din <= value(31);
  --  value := shift_left(value,1);
  --  delay(6);
  --  dclk <= '1';
  --  delay(6);
  -- end loop;
  -- dsel <= '1';

  delay(5);

  loadParm(parm);
  val := 10;
  loadMid(val, 8);
  delay(10);
  val := 16#12345678#;
  loadValue(val, valBits);

  delay(20);
  
  wait;
 end process;

end;
