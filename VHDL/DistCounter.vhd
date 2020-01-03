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
          distBits : positive;
          outBits : positive);
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
  decel : inout std_logic := '0';       --dist le acceleration steps
  distZero : out std_logic              --distance zero
  );
end DistCounter;

architecture Behavioral of DistCounter is

 component ShiftOp is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive);
  port(
   clk : in std_logic;
   din : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   shift : in std_logic;
   data : inout unsigned (n-1 downto 0)
   );
 end Component;

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

 signal active : std_logic := '0';
 signal zero : std_logic := '0';

 signal distVal : unsigned(distBits-1 downto 0);
 signal distCtr : unsigned(distBits-1 downto 0) := (others => '0');
 signal aclSteps : unsigned(distBits-1 downto 0) := (others => '0');

 signal distDout : std_logic;
 signal aclStepsDout : std_logic;
 
begin

 dout <= distDout or aclStepsDout;

 distShiftOp : ShiftOp
  generic map(opVal => opBase + F_Ld_Dist,
              opBits => opBits,
              n => distBits)
  port map(
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   data => distVal
   );

 distZero <= zero;

 distanceProc : process(clk)
 begin
  if (rising_edge(clk)) then
   if (init = '1') then                 --if load
    distCtr <= distVal;
    aclSteps <= (others => '0');
    zero <= '0';
    decel <= '0';
    active <= '1';
   elsif (step = '1') then              --if time to step
    if (zero = '0') then               --if distance non zero
     distCtr <= distCtr - 1;           --decrement distance counter
     if ((accelFlag = '1') and (decel = '0')) then --if accel ok
      aclSteps <= aclSteps + 1;         --increment accel steps
     end if;
    end if;
   elsif (active = '1') then            --if active

    if distCtr = 0 then                 --if distance zero
     zero <= '1';                       --set zero distance flag
     active <= '0';                     --set to inactive
    end if;
    
    if (decel = '0') then               --if decel not set yet
     if (aclSteps >= distCtr) then      --if accel ge dist left
      decel <= '1';                     --set decel flag
     end if;
    end if;

   end if;
  end if;
 end process distanceProc;

 DistShiftOut: ShiftOutN
  generic map(opVal => opBase + F_Rd_Dist,
              opBits => opBits,
              n => distBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   load => copy,
   data => distCtr,
   dout => distDout);

 AclShiftOut: ShiftOutN
  generic map(opVal => opBase + F_Rd_Acl_Steps,
              opBits => opBits,
              n => distBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   load => copy,
   data => aclSteps,
   dout => aclStepsDout);

end Behavioral;
