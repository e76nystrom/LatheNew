--******************************************************************************
LIBRARY ieee;

USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use ieee.math_real.all;

entity Fifo is
 generic (
  fifoDepth : natural := 32;
  fifoWidth : natural := 8
  );
 port (
  clk   : in  std_logic;
  init  : in  std_logic;
  we    : in  std_logic;
  re    : in  std_logic;
  empty : out std_logic;
  -- full  : out std_logic;
  wData : in  std_logic_vector(fifoWidth - 1 downto 0);
  rData : out std_logic_vector(fifoWidth - 1 downto 0)
  
  );
end Fifo;

architecture Behavioral of Fifo is

 constant addrBits : natural := integer(ceil(log2(real(fifoDepth))));

 type fifoData is array (0 to fifoDepth-1) of
  std_logic_vector(fifoWidth-1 downto 0);

 signal data   : fifoData := (others => (others => '0'));
 signal wSave  : std_logic_vector(fifoWidth-1 downto 0) := (others => '0');
 signal wDefer : std_logic := '0';

 signal fil    : unsigned(addrBits-1 downto 0) := (others => '0');
 signal emp    : unsigned(addrBits-1 downto 0) := (others => '0');
 signal count  : unsigned(addrBits-1 downto 0) := (others => '0');

begin

 empty <= '1' when (count = 0) else '0';

 rData <= data(to_integer(emp));
 
 fifoProc : process(clk)
 begin
  if rising_edge(clk) then
   
   if (init = '0') then
    count <= (others => '0');
    fil <= (others => '0');
    emp <= (others => '0');
   else

    if (re = '1') then
     if (count /= 0) then
      emp <= emp + 1;
      count <= count - 1;
     end if;
    end if;

    if (we = '1') then
     if (count < (fifoDepth-1)) then
      fil <= fil + 1;
      count <= count + 1;
     end if;
    end if;

   end if;

  end if;
 end process fifoProc;

 fifoWProc : process(clk)
 begin
  if rising_edge(clk) then
   
   if (count < (fifoDepth-1)) then
    if (we = '1') then
     data(to_integer(fil)) <= wData;
    end if;
   end if;

  end if;
 end process fifoWProc;

end Behavioral;
