LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 

entity CmpTmrMem2 IS
 port (
  clock: in std_logic;
  data: in std_logic_vector (23 downto 0);
  rdaddress: in std_logic_vector (10 downto 0); --integer range 0 to 31;
  wraddress: in std_logic_vector (10 downto 0); --integer range 0 to 31;
  wren: in std_logic;
  q: out std_logic_vector (23 downto 0)
  );
end CmpTmrMem2;

architecture rtl of CmpTmrMem2 is
 type mem is array(0 to 2047) of std_logic_vector(23 downto 0);
 
begin
 process (clock)
  variable ram_block: mem;
 begin
  if (rising_edge(clock)) then
   if (wren = '1') then
    ram_block(to_integer(unsigned(wraddress))) := data;
   end if;
   q <= ram_block(to_integer(unsigned(rdaddress)));
  end if;
 end process;
end rtl;
