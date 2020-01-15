--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:00:30 04/11/2015 
-- Design Name: 
-- Module Name:    LocCounter - Behavioral 
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

entity LocCounter is
 generic(opBase : unsigned;
         opBits : positive := 8;
         locBits : positive;
         outBits : positive);
 Port (
  clk : in  std_logic;
  din : in std_logic;                   --shift data in

  dshift : in boolean;                  --shift clock in
  op : in unsigned(opBits-1 downto 0);  --operation code
  copy : in boolean;                    --copy location for output
  setLoc : in std_logic;                --set location
  updLoc : in std_logic;                --location update enabled
  step : in std_logic;                  --input step pulse
  dir : in std_logic;                   --direction
  dout : out std_logic;                 --data out
  loc : inout unsigned(locBits-1 downto 0) --current location
  );
end LocCounter;

architecture Behavioral of LocCounter is

 component ShiftOp is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive);
  port(
   clk : in std_logic;
   din : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   shift : in boolean;
   data : inout unsigned (n-1 downto 0)
   );
 end Component;

 component UpDownCounter is
  generic(n : positive);
  port ( clk : in std_logic;
         ena : in std_logic;
         inc : in std_logic;
         load : in std_logic;
         ini_val : in unsigned(n-1 downto 0);
         counter : inout unsigned(n-1 downto 0));
 end component;

 component ShiftOutNS is
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

 signal updStep : std_logic;
 signal locVal : unsigned(locBits-1 downto 0); --location input

 signal locDOut : std_logic;

begin

 dout <= locDout;
 
 LocValReg: ShiftOp
  generic map(opVal => opBase + F_Ld_Loc,
              opBits => opBits,
              n => locBits)
  port map ( clk => clk,
             din => din,
             op => op,
             shift => dshift,
             data => locVal);

 updStep <= '1' when ((step = '1') and (updLoc = '1')) else '0';
 
 LocCounter: UpDownCounter
  generic map(n => locBits)
  port map ( clk => clk,
             ena => updStep,
             inc => dir,
             load => setLoc,
             ini_val => locVal,
             counter => loc);

 LocShiftOut : ShiftOutNS
  generic map(opVal => opBase + F_Rd_Loc,
              opBits => opBits,
              n => locBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   load => copy,
   data => loc,
   dout => locDout
   );

end Behavioral;

