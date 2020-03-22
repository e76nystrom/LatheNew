library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.regdef.all;

entity QuadDro is
 generic (opBase : unsigned;
          opBits : positive;
          droBits : positive;
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
  pos : out unsigned(droBits-1 downto 0) := (others => '0');
  dout : out std_logic
  );
end QuadDro;

architecture Behavioral of QuadDro is

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

 alias a : std_logic is quad(0);
 alias b : std_logic is quad(1);

 signal lastA : std_logic_vector(1 downto 0) := (others => '0');
 signal lastB : std_logic_vector(1 downto 0) := (others => '0');
 signal dir : std_logic := '0';

 signal ch : std_logic := '0';
 signal update : std_logic := '0';

 signal posInput : unsigned(droBits-1 downto 0);
 signal posVal : unsigned(droBits-1 downto 0) := (others => '0');

 signal posDout : std_logic;

begin

 droPosReg: ShiftOp
  generic map(opVal => opBase + F_Ld_Dro,
              opBits => opBits,
              n => droBits)
  port map ( clk => clk,
             din => din,
             op => op,
             shift => dshift,
             data => posInput);

 dout <= posDout;

 LocShiftOut : ShiftOutNS
  generic map(opVal => opBase + F_Rd_Dro,
              opBits => opBits,
              n => droBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftR,
   op => opR,
   copy => copyR,
   data => posVal,
   dout => posDout
   );

 delay_proc: process(clk)
 begin
  if (rising_edge(clk)) then
   lastA <= lastA(0) & a;
   lastB <= lastB(0) & b;
  end if;
 end process;

 -- calculate direction based upon a and b inputs
 
 directionProcess : process(clk)
  variable quadState : std_logic_vector(3 downto 0);
  variable ch : std_logic;
 begin
  if (rising_edge(clk)) then
   ch := (lastA(1) xor lastA(0)) or (lastB(1) xor lastB(0)); --input change
   update <= ch;
   if (ch = '1') then
    quadState := lastB(1) & lastA(1) & lastB(0) & lastA(0); --direction
    case (quadState) is
     when "0001" => dir <= '0';
     when "0111" => dir <= '0';
     when "1110" => dir <= '0';
     when "1000" => dir <= '0';
     when "0010" => dir <= '1';
     when "1011" => dir <= '1';
     when "1101" => dir <= '1';
     when "0100" => dir <= '1';
     when others => null;
    end case;
   end if;
  end if;
 end process;

 pos <= posVal;

 droPorcess : process(clk)
 begin
  if (rising_edge(clk)) then
   if (load) then
    posVal <= posInput;
   elsif (update = '1') then
    if (dir = '1') then
     posVal <= posVal + 1;
    else
     posVal <= posVal - 1;
    end if;
   end if;
  end if;
 end process;

end Behavioral;

