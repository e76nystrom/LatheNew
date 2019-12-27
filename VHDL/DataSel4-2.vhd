--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:13:33 01/24/2015 
-- Design Name: 
-- Module Name:    DataSel4_2 - Behavioral 
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

entity DataSel4_2 is
 port ( sel : in std_logic;
        a0 : in std_logic;
        a1 : in std_logic;
        a2 : in std_logic;
        a3 : in std_logic;
        b0 : in std_logic;
        b1 : in std_logic;
        b2 : in std_logic;
        b3 : in std_logic;
        y0 : out std_logic;
        y1 : out std_logic;
        y2 : out std_logic;
        y3 : out std_logic
        );
end DataSel4_2;

architecture Behavioral of DataSel4_2 is

begin

 mux: process(sel, a0, a1, a2, a3, b0, b1, b2, b3)
 begin
  if (sel = '0') then
    y0 <= a0;
    y1 <= a1;
    y2 <= a2;
    y3 <= a3;
  else
    y0 <= b0;
    y1 <= b1;
    y2 <= b2;
    y3 <= b3;
  end if;
 end process mux;

end Behavioral;

