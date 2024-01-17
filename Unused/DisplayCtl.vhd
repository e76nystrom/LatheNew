library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.DataInp;

entity DisplayCtl is
 generic (opVal       : unsigned(opb-1 downto 0);
          displayBits : positive;
          outBits     : positive
          );
 port (
  clk      : in  std_logic;
  dsel     : in  std_logic;
  inp      : in  DataInp;
  dspCopy  : out std_logic := '0';
  dspShift : out std_logic := '0';
  dspOp    : inout unsigned (opb-1 downto 0) := (others => '0');
  dspreg   : inout unsigned (displayBits-1 downto 0) := (others => '0')
  );
end DisplayCtl;

architecture behavioral of  DisplayCtl is

 type ctlFSM is (idle, shiftVal);
 signal state : ctlFSM := idle;

 signal lastDsel : std_logic := '1';
 signal count : integer range 0 to outBits;

begin

 opReg : entity work.ShiftOp
  generic map(opVal => opVal,
              n     => opb)
  port map(
   clk   => clk,
   inp   => inp,
   data  => dspOp
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
     dspReg <= dspReg(displayBits-2 downto 0) & inp.dIn;
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
