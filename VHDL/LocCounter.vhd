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
  dshiftR : in boolean;                 --shift clock in
  opR : in unsigned(opBits-1 downto 0); --operation code
  copyR : in boolean;                   --copy location for output
  setLoc : in std_logic;                --set location
  updLoc : in std_logic;                --location update enabled
  step : in std_logic;                  --input step pulse
  dir : in std_logic;                   --direction
  dout : out std_logic := '0'           --data out
  -- loc : inout unsigned(locBits-1 downto 0) := (others => '0') --cur location
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

 component ShiftOutNS is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive;
          outBits : positive);
  port (
   clk : in std_logic;
   dshift : in boolean;
   op : in unsigned (opBits-1 downto 0);
   copy : in boolean;
   data : in unsigned(n-1 downto 0);
   dout : out std_logic
   );
 end Component;

 signal locVal : unsigned(locBits-1 downto 0); --location input
 signal loc : unsigned(locBits-1 downto 0) := (others => '0'); --cur location
                                             
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

 LocShiftOut : ShiftOutNS
  generic map(opVal => opBase + F_Rd_Loc,
              opBits => opBits,
              n => locBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftR,
   op => opR,
   copy => copyR,
   data => loc,
   dout => locDout
   );

 LocCounter: process(clk)
 begin
  if (rising_edge(clk)) then

   if (setLoc = '1') then
    loc <= locVal;
   -- elsif ((updLoc = '1') and ((step = '1')) then
   elsif (step = '1') then
    if (dir = '1') then
     loc <= loc + 1;
    else
     loc <= loc - 1;
    end if;      
   end if;

  end if;
 end process LocCounter;

end Behavioral;
