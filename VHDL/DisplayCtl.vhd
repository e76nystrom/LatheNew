library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;

entity DisplayCtl is
 generic (opVal : unsigned;
          opBits : positive;
          displayBits : positive;
          outBits : positive
          );
 port (
  clk : in std_logic;
  dsel : in Std_logic;
  din : in std_logic;
  shift : in std_logic;
  op : in unsigned (opBits-1 downto 0);
  dout : in std_logic;
  dspCopy : out std_logic := '0';
  dspShift : out std_logic := '0';
  dspOp : inout unsigned (opBits-1 downto 0) := (others => '0');
  dspreg : inout unsigned (displayBits-1 downto 0) := (others => '0')
  );
end DisplayCtl;

architecture behavioral of  DisplayCtl is

 component ShiftOp is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive);
  port(
   clk : in std_logic;
   din : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   shift : in std_logic;
   data : inout unsigned (n-1 downto 0)
   );
 end Component;

 type ctlFSM is (idle, shiftVal);
 signal state : ctlFSM := idle;

 signal lastDsel : std_logic := '1';
 signal count : integer range 0 to outBits;

begin

 opReg : ShiftOp
  generic map(opVal => opVal,
              opBits => opBits,
              n => opBits)
  port map(
   clk => clk,
   din => din,
   op => op,
   shift => shift,
   data => dspOp
   );

 dspProc: process(clk)
 begin
  if (rising_edge(clk)) then
   lastDsel <= dsel;
   case state is
    when idle =>
     if ((dspOp /= x"00") and (lastDsel = '0') and (dsel = '1')) then
      dspCopy <= '1';
      count <= 32;
      state <= shiftVal;
     end if;

    when shiftVal =>
     dspReg <= dspReg(displayBits-2 downto 0) & dout;
     dspCopy <= '0';
     if (count = 0) then
      dspShift <= '0';
      state <= idle;
     else
      dspShift <= '1';
      count <= count - 1;
     end if;
   end case;
  end if;
 end process;
 
end behavioral;
