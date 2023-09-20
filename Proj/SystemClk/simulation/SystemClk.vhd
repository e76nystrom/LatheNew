-- SystemClk.vhd

-- Generated using ACDS version 22.1 917

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SystemClk is
	port (
		inclk  : in  std_logic := '0'; --  altclkctrl_input.inclk
		outclk : out std_logic         -- altclkctrl_output.outclk
	);
end entity SystemClk;

architecture rtl of SystemClk is
	component SystemClk_altclkctrl_0 is
		port (
			inclk  : in  std_logic := 'X'; -- inclk
			outclk : out std_logic         -- outclk
		);
	end component SystemClk_altclkctrl_0;

begin

	altclkctrl_0 : component SystemClk_altclkctrl_0
		port map (
			inclk  => inclk,  --  altclkctrl_input.inclk
			outclk => outclk  -- altclkctrl_output.outclk
		);

end architecture rtl; -- of SystemClk