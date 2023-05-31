LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 

entity RdMem IS
 port (
  clock: in std_logic;
  data: in std_logic_vector (7 downto 0);
  rdaddress: in std_logic_vector (4 downto 0); --integer range 0 to 31;
  wraddress: in std_logic_vector (4 downto 0); --integer range 0 to 31;
  wren: in std_logic;
  q: out std_logic_vector (7 downto 0)
  );
end RdMem;

architecture behavioral of RdMem is
 type mem is array(0 to 31) of std_logic_vector(7 downto 0);
 
begin
 process (clock)
  variable ram_block: mem;
 begin
  if (rising_edge(clock)) then
   if (wren = '1') then
    ram_block(to_integer(signed(wraddress))) := data;
   end if;
   q <= ram_block(to_integer(signed(rdaddress)));
  end if;
 end process;
end behavioral;
