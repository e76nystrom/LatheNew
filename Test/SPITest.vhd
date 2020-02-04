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
   copy : out boolean;
   shift : out boolean;
   load : out boolean;
   header : out boolean;
   spiActive : out boolean
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

 component Controller is
  generic (opBase : unsigned;
           opBits : positive;
           addrBits : positive;
           statusBits : positive;
           seqBits : positive;
           outBits : positive
           );
  port (
   clk : in std_logic;
   init : in boolean;
   din : in std_logic;
   dshift : in boolean;
   op : in unsigned(opBits-1 downto 0);
   copy : in boolean;
   load : in boolean;
   ena : in boolean;
   statusReg : in unsigned(statusBits-1 downto 0);

   dout : out std_logic;
   dinOut : out std_logic;
   dshiftOut : out boolean;
   opOut : out unsigned(opBits-1 downto 0);
   loadOut : out boolean;
   empty : out boolean
   );
 end Component;

 constant valBits : positive := 32;
 constant opBits : integer := 8;
 constant byteBits : integer := 8;
 
 constant statusSize : integer := 5;

 --Inputs
 signal clk : std_logic := '0';
 signal dclk : std_logic := '0';
 signal dsel : std_logic := '1';
 signal din : std_logic := '0';

 --BiDirs
 signal op : unsigned(7 downto 0);

 --Outputs
 signal copy : boolean;
 signal shift : boolean;
 signal load : boolean;
 signal header : boolean;
 signal spiActive : boolean;
 --signal info : std_logic_vector(2 downto 0);
 signal clkena1 : std_logic;
 signal dout : std_logic;

 constant opBase : unsigned := x"00";
 constant addrBits : positive := 8;
 constant seqBits : positive := 8;
 constant outBits : positive := 8;

 signal init : boolean := false;
 signal ena : boolean := false;
 signal statusReg : unsigned(statusSize-1 downto 0) := (others => '0');
 signal dinOut : std_logic := '0';
 signal dshiftOut : boolean := false;
 signal opOut : unsigned(opBits-1 downto 0) := (others => '0');
 signal loadOut : boolean := false;
 signal empty : boolean := false;

 -- Clock period definitions
 constant clk_period : time := 10 ns;

 constant testBits : integer := 32;
 --signal test_reg : unsigned(testBits-1 downto 0);
 signal test1_reg : unsigned(testBits-1 downto 0);

 alias zAxisEna   : std_logic is statusreg(0); -- x01 z axis enable flag
 alias zAxisDone  : std_logic is statusreg(1); -- x02 z axis done
 alias xAxisEna   : std_logic is statusreg(2); -- x04 x axis enable flag
 alias xAxisDone  : std_logic is statusreg(3); -- x08 x axis done
 alias queEmpty   : std_logic is statusreg(4); -- x10 controller queue empty

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

 uut1 : Controller
  generic map (opBase => opBase + F_Ctrl_Base,
               opBits => opBits,
               addrBits => addrBits,
               statusBits => statusSize,
               seqBits => seqBits,
               outBits => outBits
               )
  port map (
   clk => clk,
   init => init,
   din => din,
   dshift => shift,
   op => op,
   copy => copy,
   load => load,
   ena => ena,
   statusReg => statusReg,

   dout => dout,
   dinOut => dinOut,
   dshiftOut => dshiftOut,
   opOut => opOut,
   loadOut => loadOut,
   empty => empty
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

  procedure loadValueC(constant value : in integer;
                       constant bits : in natural) is
   variable tmp : integer;
  begin
   tmp := value;
   loadValue(tmp, bits);
  end procedure loadValueC;
  
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

  procedure loadMidC(constant value : in integer;
                     constant bits : in natural) is
   variable tmp : integer;
  begin
   tmp := value;
   loadMid(tmp, bits);
  end procedure loadMidC;
  
  procedure loadEnd is
  begin
   dsel <= '1';                          --end of load
   delay(10);
  end procedure loadEnd;
  
  variable parm : unsigned(opBits-1 downto 0) :=  (opBits-1 downto 0 => '0');
  variable val : integer := 16#12345678#;

 begin		
  -- hold reset state for 100 ns.
  wait for 100 ns;	

  wait for clk_period*10;

  -- insert stimulus here 

  parm := to_unsigned(16#a5#, 8);

  wait for clk_period*2;
  
  delay(5);

  loadParm(parm);
  val := 10;
  loadMid(val, 8);
  delay(10);
  val := 16#12345678#;
  loadValue(val, valBits);

  init <= true;
  delay(10);
  init <= false;

  delay(10);

  parm := F_Ctrl_Base + F_Ld_Ctrl_Data;
  loadParm(parm);

  val := to_integer(F_Ctrl_Base + F_Ld_seq);
  loadMid(val, opBits);
  delay(5);
  val := 3;
  loadMid(val, byteBits);

  val := to_integer(F_Ctrl_Base + F_Ctrl_Cmd);
  loadMid(val, opBits);
  delay(5);
  val := 1;
  loadMid(val, byteBits);

  delay(5);

  val := to_integer(F_ZAxis_Base + F_Sync_Base + F_Ld_D);
  loadMid(val, byteBits);
  delay(5);
  loadMidC(4, byteBits);
  delay(5);
  loadMidC(100000, 32);
  
  delay(5);
  
  val := to_integer(F_ZAxis_Base + F_Sync_Base + F_Ld_Incr1);
  loadMid(val, byteBits);
  delay(5);
  loadMidC(4, byteBits);
  delay(5);
  loadMidC(1000000, 32);

  delay(5);

  val := to_integer(F_Ctrl_Base + F_Ctrl_Cmd);
  loadMid(val, opBits);
  delay(5);
  val := 2;
  loadMid(val, byteBits);

  delay(5);

  val := to_integer(F_XAxis_Base + F_Sync_Base + F_Ld_Incr1);
  loadMid(val, byteBits);
  delay(5);
  loadMidC(4, byteBits);
  delay(5);
  loadValueC(1000000, 32);

  loadEnd;
  
  delay(20);

  zAxisEna <= '1';
  xAxisEna <= '1';
  ena <= true;

  delay(100);

  zAxisDone <= '1';

  delay(100);

  ena <= false;

  delay(100);

  init <= true;
  delay(5);
  init <= false;
  
  wait;
 end process;

end;
