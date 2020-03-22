library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

use work.SimProc.all;
use work.RegDef.all;

entity JogTest is
end JogTest;
architecture behavior OF JogTest is

 component Jog is
  generic (opBase : unsigned;
           opBits : positive;
           outBits : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in boolean;
   op : in unsigned(opBits - 1 downto 0);
   load : in boolean;
   dshiftR : in boolean;
   opR : in unsigned(opBits-1 downto 0);
   copyR : in boolean;
   quad : in std_logic_vector(1 downto 0);
   jogStep : out std_logic;
   jogDir : out std_logic;
   jogUpdLoc : out std_logic;
   dout : out std_logic
   );
 end Component;

 constant opBase : unsigned := F_Jog_Base;
 constant opBits : positive := 8;
 constant outBits : positive := 32;

 signal clk : std_logic := '0';
 signal din : std_logic := '0';
 signal dshift : boolean := false;
 signal op : unsigned(opBits - 1 downto 0) := (opBits - 1 downto 0 => '0');
 signal load : boolean := false;
 signal dshiftR : boolean := false;
 signal opR : unsigned(opBits-1 downto 0) := (opBits-1 downto 0 => '0');
 signal copyR : boolean := false;
 signal quad : std_logic_vector(1 downto 0) := (1 downto 0 => '0');
 signal jogStep : std_logic := '0';
 signal jogDir : std_logic := '0';
 signal jogUpdLoc : std_logic := '0';
 signal dout : std_logic := '0';

begin

 uut : Jog
  generic map (opBase => opBase,
               opBits => opBits,
               outBits => outBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   load => load,
   dshiftR => dshiftR,
   opR => opR,
   copyR => copyR,
   quad => quad,
   jogStep => jogStep,
   jogDir => jogDir,
   jogUpdLoc => jogUpdLoc,
   dout => dout
   );

 -- Clock process definitions

 clkProcess :process
 begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
 end process;

 -- Stimulus process

 stimProc: process

  procedure delay(constant n : in integer) is
  begin
   for i in 0 to n-1 loop
    wait until (clk = '1');
    wait until (clk = '0');
   end loop;
  end procedure delay;

  variable count : integer := 0;
  variable forward : boolean := true;

  procedure delayQuad(constant n : in integer) is
  begin
   if (forward) then
    count := count + 1;
    if (count > 3) then
     count := 0;
    end if;
   else
    count := count - 1;
    if (count < 0) then
     count := 3;
    end if;
   end if;
    
   
   case count is
    when 0 =>
     quad(1) <= '0';
    when 1 =>
     quad(0) <= '1';
    when 2 =>
     quad(1) <= '1';
    when 3 =>
     quad(0) <= '0';
    when others =>
     count := 0;
   end case;

   for i in 0 to n-1 loop
    delay(1);
   end loop;

  end procedure delayQuad;

  procedure loadShift(variable value : in integer;
                      constant bits : in natural) is
   variable tmp: std_logic_vector(32-1 downto 0);
  begin
   tmp := conv_std_logic_vector(value, 32);
   dshift <= true;
   for i in 0 to bits-1 loop
    din <= tmp(bits - 1);
    wait until clk = '1';
    tmp := tmp(31-1 downto 0) & tmp(31);
    wait until clk = '0';
   end loop;
   dshift <= false;
   load <= true;
   delay(1);
   load <= false;
  end procedure loadShift;

--variables

  constant jogSize : integer := 2;
  variable jogReg : unsigned(jogSize-1 downto 0);
  alias jogContinuous : std_logic is jogreg(0); -- x01 jog continuous mode
  alias jogBacklash : std_logic is jogreg(1); -- x02 jog backlash present

  constant distBits : positive := 16;

  variable incDist : unsigned(distBits-1 downto 0);
  variable backlashDist : unsigned(distBits-1 downto 0);

 begin

-- hold reset state for 100 ns.

  wait for 100 ns;

  jogReg := (others => '0');
  jogContinuous := '0';
  jogBacklash := '1';
  op <= F_Jog_Base + F_Ld_Jog_Ctl;
  loadShift(to_integer(jogReg), jogSize);

  incDist := to_unsigned(10, distBits);
  op <= F_Jog_Base + F_Ld_Jog_Inc;
  loadShift(to_integer(incDist), distBits);

  backlashDist := to_unsigned(5, distBits);
  op <= F_Jog_Base + F_Ld_Jog_Back;
  loadShift(to_integer(backlashDist), distBits);


  delay(10);

  -- insert stimulus here

  for i in 0 to 3 loop
   delayQuad(2000);
  end loop;
  forward := false;
  for i in 0 to 5 loop
   delayQuad(2000);
  end loop;

  wait;
 end process;

end;
