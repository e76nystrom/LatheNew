--******************************************************************************
LIBRARY ieee;

USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use ieee.math_real.all;

entity Mpg is
 generic (
  mpgDepth : natural := 32;
  mpgWidth : natural := 8
  );
 port (
  clk    : in  std_logic;
  init   : in  std_logic;
  msTick : in  std_logic;
  re     : in  std_logic;
  empty  : out std_logic;
  mpg    : in  std_logic_vector(2-1 downto 0);
  rData  : out std_logic_vector(mpgWidth - 1 downto 0)
  );

end Mpg;

architecture Behavioral of Mpg is

 signal mpgQuadState : std_logic_vector(3 downto 0) := (others => '0');
 signal mpgA         : std_logic_vector(1 downto 0) := (others => '0');
 signal mpgB         : std_logic_vector(1 downto 0) := (others => '0');
 signal mpgUpdate    : std_logic := '0';
 -- signal mpgInvert    : std_logic := '0';
 signal mpgDir       : std_logic := '0';

 constant msMax      : unsigned(mpgWidth-2 downto 0) := (others => '1');

 signal msCounter    : unsigned(mpgWidth-2 downto 0) := (others => '0');
 signal lastTick     : std_logic := '0';

 signal mpgData      : std_logic_vector(mpgWidth-1 downto 0) := (others => '0');

 constant mpgInvert  : std_logic := '0';

begin

 mpgData <= mpgDir & std_logic_vector(msCounter);

 mpgFifo : entity work.Fifo
  generic map(fifoDepth => mpgDepth,
              fifoWidth => mpgWidth)
 port map (
  clk   => clk,
  init  => init,
  we    => mpgUpdate,
  re    => re,
  empty => empty,
  wData =>  mpgData,
  rData => rData
  );

 mpgProc : process(clk)
 begin
  
  if (rising_edge(clk)) then
   
   if (mpgUpdate = '1') then
    msCounter <= (others => '0');
   else
    if ((lastTick = '0') and (msTick = '1')) then
     if (msCounter /= msMax) then
      msCounter <= msCounter + 1;
     end if;
    end if;       
   end if;       

   lastTick <= msTick;

   mpgA <= mpgA(0) & mpg(0);
   mpgB <= mpgB(0) & mpg(1);

   mpgQuadState <= mpgB(1) & mpgA(1) & mpgB(0) & mpgA(0);
   
   case (mpgQuadState) is
    when "0001" => mpgUpdate <= '0'; mpgDir <= mpgInvert;
    when "0111" => mpgUpdate <= '0'; mpgDir <= mpgInvert;
    when "1110" => mpgUpdate <= '1'; mpgDir <= mpgInvert;
    when "1000" => mpgUpdate <= '0'; mpgDir <= mpgInvert;
    when "0010" => mpgUpdate <= '0'; mpgDir <= not mpgInvert; 
    when "1011" => mpgUpdate <= '0'; mpgDir <= not mpgInvert; 
    when "1101" => mpgUpdate <= '1'; mpgDir <= not mpgInvert; 
    when "0100" => mpgUpdate <= '0'; mpgDir <= not mpgInvert; 
    when others => mpgUpdate <= '0';
   end case;                            --end case mpgQuadChange

  end if;

 end process mpgProc;

end Behavioral;
