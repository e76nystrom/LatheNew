library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;

entity IndexClocks is
 generic (opval : unsigned;
          opBits : positive;
          n : positive;
          outBits : positive);
 port (
  clk : in std_logic;
  dshift : in boolean;
  op : in unsigned (opBits-1 downto 0);
  copy : in boolean;
  ch : in std_logic;
  index : in std_logic;
  dout : out std_logic := '0'
  );
end IndexClocks;

architecture behavioral of  IndexClocks is

 component ShiftOutN is
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

 constant chCtrBits : positive := n-10;

 signal lastIndex : std_logic := '0';
 signal lastCh : std_logic := '0';
 signal active : std_logic := '0';
 signal clockCounter : unsigned(n-1 downto 0) := (others => '0');
 signal clockReg : unsigned(n-1 downto 0) := (others => '0');
 signal chCounter : unsigned(chCtrBits-1 downto 0) := (others => '0');

begin

 dataOut: ShiftOutN
  generic map(opVal => opVal,
              opBits => opBits,
              n => n,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   copy => copy,
   data => clockReg,
   dout => dout
   );

 clockProc: process(clk)
 begin
  if (rising_edge(clk)) then
   lastIndex <= index;
   lastCh <= ch;

   if (active = '1' ) then              --if active

    if (index = '1') and (lastIndex = '0') then
     clockReg <= clockCounter;
     clockCounter <= (others => '0');
    else
     clockCounter <= clockCounter + 1;
    end if;

    if ((ch = '1') and (lastCh = '0')) then
     chCounter <= (others => '0');
    else
     if (chCounter = (chCtrBits-1 downto 0 => '1')) then
      active <= '0';
      chCounter <= (others => '0');
      clockReg <= (others => '0');
      clockCounter <= (others => '0');
     else
      chCounter <= chCounter + 1;
     end if;
    end if;

   else                                 --if not active
    if (index = '1') and (lastIndex = '0') then
     active <= '1';
    end if;
   end if;
  end if;
 end process clockProc;
 
end behavioral;
