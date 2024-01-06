library ieee;

use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

use work.RegDef.all;
use work.IORecord.all;
use work.FpgaLatheBitsRec.all;
use work.FpgaLatheBitsFunc.all;

entity RunOutSync is
 generic(opBase        : unsigned (opb-1 downto 0);
         runOutCtrBits : positive := 18);
 port(
  clk     : in std_logic;
  inp     : in DataInp;
  enable  : in std_logic;
  step    : in std_logic;
  rEnable : out std_logic := '0'
  );
end RunOutSync;

architecture Behavioral of RunOutSync is

 signal runOutCtlReg : runOutCtlVec;
 signal runOutCtlR   : runOutCtlRec;

 signal runOutCtlRdReg : unsigned(runOutCtlSize-1 downto 0);

 signal counter   : unsigned(runOutCtrBits-1 downto 0) := (others => '0');
 signal loadLimit : std_logic := '0';
 signal limitVal  : unsigned(runOutCtrBits-1 downto 0) := (others => '0');
 signal limit     : unsigned(runOutCtrBits-1 downto 0) := (others => '0');

 signal runOutEna : std_logic := '0';

begin

 runOutReg : entity work.CtlReg
  generic map(opVal => opBase + F_Ld_RunOut_Ctl,
              n     => RunOutCtlSize)
  port map (
   clk  => clk,
   inp  => inp,
   data => runOutCtlReg);

  runOutCtlR <= runOutCtlToRec(runOutCtlReg);

  runLimit : entity work.ShiftOpLoad
  generic map(opVal  => opBase + F_Ld_Run_Limit,
              n      => runOutCtrBits)
  port map(
   clk   => clk,
   inp   => inp,
   load  => loadLimit,
   data  => limitVal
   );

 rEnable <= enable when runOutCtlR.runOutEna = '0' else runOutEna;
 
 runOut_proc: process (clk)
 begin
  if (rising_edge(clk)) then

   if (loadLimit = '1') then
    limit <= limitVal;
   end if;

   if (runOutCtlR.runOutInit = '1') then
    counter <= (others => '0');
    runOutEna <= '0';
   else

    if ((runOutCtlR.runOutEna and enable) = '1') then

     if ((step = '1') and (runOutEna = '0')) then
      counter <= counter + 1;
     else

      if (runOutCtlR.runOutDir = '1') then --direction
       if (counter > limit) then
        runOutEna <= '1';
       else
        runOutEna <= '0';
       end if;
      else                              --direction
       if (counter < limit) then
        runOutEna <= '1';
       else
        runOutEna <= '0';
       end if;
       
      end if;                           --direction

     end if;                            --ch

    end if;                             --enable

   end if;                              --init

  end if;                               --rising_edge
  
 end process runOut_proc;

end Behavioral;
