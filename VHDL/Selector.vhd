library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMux8 is
 port (
  clk    : in  std_logic;
  sel    : in  std_logic;
  input  : in  unsigned(2 downto 0);
  selOut : out std_logic_vector(7 downto 0)
  );
end DMux8;

architecture Behavorial of DMux8 is

begin

 muxProc : process(clk)
 begin
  if (rising_edge(clk)) then
    case input is
     when "000" => selOut <= "00000001";
     when "001" => selOut <= "00000010";
     when "010" => selOut <= "00000100";
     when "011" => selOut <= "00001000";
     when "100" => selOut <= "00010000";
     when "101" => selOut <= "00100000";
     when "110" => selOut <= "01000000";
     when "111" => selOut <= "10000000";
     when others => selOut <= (others => '0');
     end case;
   end if;
  end process;

end Behavorial;

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMux16 is
 port (
  clk    : in  std_logic;
  sel    : in  std_logic;
  input  : in  unsigned(3 downto 0);
  selOut : out std_logic_vector(15 downto 0)
  );
end DMux16;

architecture Behavorial of DMux16 is

begin

 muxProc : process(clk)
 begin
  if (rising_edge(clk)) then
    case input is
     when "0000" => selOut <= "0000000000000001";
     when "0001" => selOut <= "0000000000000010";
     when "0010" => selOut <= "0000000000000100";
     when "0011" => selOut <= "0000000000001000";
     when "0100" => selOut <= "0000000000010000";
     when "0101" => selOut <= "0000000000100000";
     when "0110" => selOut <= "0000000001000000";
     when "0111" => selOut <= "0000000010000000";
     when "1000" => selOut <= "0000000100000000";
     when "1001" => selOut <= "0000001000000000";
     when "1010" => selOut <= "0000010000000000";
     when "1011" => selOut <= "0000100000000000";
     when "1100" => selOut <= "0001000000000000";
     when "1101" => selOut <= "0010000000000000";
     when "1110" => selOut <= "0100000000000000";
     when "1111" => selOut <= "1000000000000000";
     when others => selOut <= (others => '0');
     end case;
   end if;
  end process;

end Behavorial;

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OpSel is
 port (
  clk    : in  std_logic;
  input  : in  unsigned(6 downto 0);
  selOut : out std_logic_vector(127 downto 0)
  );
end OpSel;

architecture Behavorial of OpSel is

component DMux16 is
 port (
  clk    : in  std_logic;
  input  : in  unsigned(3 downto 0);
  selOut : out std_logic_vector(15 downto 0)
  );
end component;

component DMux8 is
 port  (
  clk    : in  std_logic;
  sel    : in  std_logic;
  input  : in  unsigned(2 downto 0);
  selOut : out std_logic_vector(7 downto 0)
  );
 end component;

 signal sel : std_logic_vector(15 downto 0);

begin

 muxA : DMux16
 port map (
  clk    => clk,
  input  => input(6 downto 3),
  selOut => sel
  );

 mux0 : DMux8
 port map (
  clk    => clk,
  sel    => sel(0),
  input  => input(2 downto 0),
  selOut => selOut(7 downto 0)
  );

 mux1 : DMux8
 port map (
  clk    => clk,
  sel    => sel(1),
  input  => input(2 downto 0),
  selOut => selOut(15 downto 8)
  );

 mux2 : DMux8
 port map (
  clk    => clk,
  sel    => sel(2),
  input  => input(2 downto 0),
  selOut => selOut(23 downto 16)
  );

 mux3 : DMux8
 port map (
  clk    => clk,
  sel    => sel(3),
  input  => input(2 downto 0),
  selOut => selOut(31 downto 24)
  );

 mux4 : DMux8
 port map (
  clk    => clk,
  sel    => sel(4),
  input  => input(2 downto 0),
  selOut => selOut(39 downto 32)
  );

 mux5 : DMux8
 port map (
  clk    => clk,
  sel    => sel(5),
  input  => input(2 downto 0),
  selOut => selOut(47 downto 40)
  );

 mux6 : DMux8
 port map (
  clk    => clk,
  sel    => sel(6),
  input  => input(2 downto 0),
  selOut => selOut(55 downto 48)
  );

 mux7 : DMux8
 port map (
  clk    => clk,
  sel    => sel(7),
  input  => input(2 downto 0),
  selOut => selOut(63 downto 56)
  );

 mux8 : DMux8
 port map (
  clk    => clk,
  sel    => sel(8),
  input  => input(2 downto 0),
  selOut => selOut(71 downto 64)
  );

 mux9 : DMux8
 port map (
  clk    => clk,
  sel    => sel(9),
  input  => input(2 downto 0),
  selOut => selOut(79 downto 72)
  );

 mux10 : DMux8
 port map (
  clk    => clk,
  sel    => sel(10),
  input  => input(2 downto 0),
  selOut => selOut(87 downto 80)
  );

 mux11 : DMux8
 port map (
  clk    => clk,
  sel    => sel(11),
  input  => input(2 downto 0),
  selOut => selOut(95 downto 88)
  );

 mux12 : DMux8
 port map (
  clk    => clk,
  sel    => sel(12),
  input  => input(2 downto 0),
  selOut => selOut(103 downto 96)
  );

 mux13 : DMux8
 port map (
  clk    => clk,
  sel    => sel(13),
  input  => input(2 downto 0),
  selOut => selOut(111 downto 104)
  );

 mux14 : DMux8
 port map (
  clk    => clk,
  sel    => sel(14),
  input  => input(2 downto 0),
  selOut => selOut(119 downto 112)
  );

 mux15 : DMux8
 port map (
  clk    => clk,
  sel    => sel(15),
  input  => input(2 downto 0),
  selOut => selOut(127 downto 120)
  );
end Behavorial;
