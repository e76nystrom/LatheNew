library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;

entity PWM is
 generic (opBase : unsigned;
          opBits : positive;
          n : positive);
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in boolean;
  op : in unsigned(opBits-1 downto 0);
  ena : in std_logic;
  pwmOut : out std_logic := '0'
  );
end PWM;

architecture behavioral of  PWM is

 signal pwmMax : unsigned(n-1 downto 0);
 signal pwmCounter : unsigned(n-1 downto 0);
 signal pwmTrigIn : unsigned(n-1 downto 0);
 signal pwmTrig : unsigned(n-1 downto 0);

 signal lastEna : std_logic;
 signal trigSel : boolean;

begin

 pwmMaxShift : entity work.ShiftOp
  generic map(opVal => opBase + F_Ld_PWM_Max,
              opBits => opBits,
              n => n)
  port map(
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   data => pwmMax
   );

 pwmTrigShift : entity work.ShiftOpSel
  generic map(opVal => opBase + F_Ld_PWM_Trig,
              opBits => opBits,
              n => n)
  port map(
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   sel => trigSel,
   data => pwmTrigIn
   );

 Proc : process(clk)
 begin
  if (rising_edge(clk)) then
   lastEna <= ena;

   if (ena = '1') then
    if (lastEna = '0') then
     pwmCounter <= pwmMax;
     pwmOut <= '0';
    else
     if (pwmCounter <= pwmTrig) then
      pwmOut <= '1';
     end if;
     
     if (pwmCounter = 0) then
      pwmCounter <= pwmMax;
      pwmOut <= '0';
      if (trigSel) then
       pwmTrig <= PwmTrigIn;
      end if;
     else
      pwmCounter <= pwmCounter - 1;
     end if;

    end if;
   end if;
  end if;
 end process Proc;

end behavioral;
