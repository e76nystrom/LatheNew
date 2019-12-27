--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:12:01 04/22/2015 
-- Design Name: 
-- Module Name:    DistCounter - Behavioral 
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

use work.regdef.all;

entity DistCounter is
 generic (opBase : unsigned;
          opBits : positive := 8;
          distBits : positive);
 Port (
  clk : in  std_logic;
  din : in std_logic;
  dshift : in std_logic;
  op : in unsigned(opBits-1 downto 0);  --current reg address
  copy : in std_logic;
  init : in std_logic;                  --reset
  step : in std_logic;                  --all steps
  accelFlag : in std_logic;             --acceleration step
  dout : out std_logic := '0';          --data output
  decel : inout std_logic;              --dist le acceleration steps
  distZero : out std_logic              --distance zero
  );
end DistCounter;

architecture Behavioral of DistCounter is

 component Compare is
  generic (n : positive);
  port (
   a : in  unsigned (n-1 downto 0);
   b : in  unsigned (n-1 downto 0);
   cmp_ge : in std_logic;
   cmp : out std_logic);
 end component;

 component UpCounter is
  generic (n : positive);
  port (
   clk : in std_logic;
   ena : in std_logic;
   clr : in std_logic;
   counter : inout  unsigned (n-1 downto 0));
 end component;

 component ShiftOut is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive);
  port (
   clk : in std_logic;
   dshift : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   load : in std_logic;
   data : in unsigned(n-1 downto 0);
   dout : out std_logic
   );
 end Component;

 component RegCtr is
  generic (n : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in std_logic;
   ena : in std_logic;
   load : in std_logic;
   data : inout  unsigned (n-1 downto 0);
   zero : inout std_logic);
 end component;

 signal accelStep : std_logic;

 signal distShift : std_logic;
 signal zero : std_logic;

 signal distCtr : unsigned(distBits-1 downto 0);
 signal aclSteps : unsigned(distBits-1 downto 0);

 signal distDout : std_logic;
 
begin

 dout <= distDout;

 accelStep <= '1' when ((accelFlag = '1') and (step = '1') and (decel = '0'))
              else '0';

 DistAccelCtr: UpCounter
  generic map(n => distBits)
  port map (
   clk => clk,
   ena => accelStep,
   clr => init,
   counter => aclSteps);

 distShift <= '1' when ((op = opBase + F_Ld_Axis_Dist) and (dshift = '1')) else '0';
 distZero <= zero;

 DistRegCtr: RegCtr
  generic map(n => distBits)
  port map (
   clk => clk,
   din => din,
   dshift => distShift,
   ena => step,
   load => init,
   data => distCtr,
   zero => zero);

 DistAclCmp: Compare
  generic map(n => distBits)
  port map (
   a => distCtr,
   b => aclSteps,
   cmp_ge => '0',
   cmp => decel);

 DistShiftOUt: ShiftOut
  generic map(opVal => opBase + F_Rd_Axis_Dist,
              opBits => opBits,
              n => distBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   load => copy,
   data => distCtr,
   dout => distDout);

end Behavioral;
