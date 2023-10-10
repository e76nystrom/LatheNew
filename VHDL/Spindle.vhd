
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RegDef.all;
use work.IORecord.all;
use work.FpgaLatheBitsRec.all;
use work.FpgaLatheBitsFunc.all;

entity Spindle is
 generic (opBase    : unsigned;
          synBits   : positive;
          posBits   : positive;
          countBits : positive;
          outBits   : positive);
 port (
  clk       : in std_logic;

  inp       : in  DataInp;
  oRec      : in  DataOut;

  ch        : in  std_logic;
  mpgQuad   : in  std_logic_vector(1 downto 0);
  jogInvert : in  std_logic;
  eStop     : in  std_logic;
  spActive  : out std_logic := '0';
  stepOut   : out std_logic := '0';
  dirOut    : out std_logic := '0';
  dout      : out SpindleData
  -- dout      : out std_logic := '0'
  );
end Spindle;

architecture Behavioral of Spindle is

 type fsm is (idle, run, done);
 signal state : fsm;

 signal syncInit : std_logic := '0';
 signal syncEna : std_logic := '0';

 signal synStep : std_logic;
 signal jogStep : std_logic;

 signal jogDir : std_logic;
 signal jogEnable : std_logic;

 signal decelDone : boolean;

 signal decel : std_logic;

 -- signal doutSync : std_logic;
 -- signal doutJog : std_logic;

 signal spCtlReg : spCtlVec;
 signal spCtlR   : spCtlRec;

begin
 
 -- dOut <= doutSync or doutJog;
 
 spindleCtlReg : entity work.CtlReg
  generic map(opVal => opBase + F_Ld_Sp_Ctl,
              n => spCtlSize)
  port map (
   clk  => clk,
   inp  => inp,
   data => spCtlReg
   );

   spCtlR <= spCtlToRec(spCtlReg);

 SpindleSyncAccel : entity work.SyncAccelNew
  generic map (opBase    => opBase + F_Sp_Sync_Base,
               synBits   => synBits,
               posBits   => posBits,
               countBits => countBits)
  port map (
   clk          => clk,

   inp          => inp,
   oRec         => oRec,

   init         => syncInit,
   ena          => syncEna,
   decel        => decel,
   decelDisable => false,
   ch           => ch,
   dir          => '0',
   -- dout         => doutSync,
   dout         => dout,
   accelActive  => open,
   decelDone    => decelDone,
   synStep      => synStep
   );

 SpindleJog : entity work.Jog
  generic map (opBase  => opBase + F_Sp_Jog_Base,
               outBits => outBits)
  port map (
   clk        => clk,

   inp        => inp,
   oRec       => oRec,

   quad       => mpgQuad,
   enable     => jogEnable,
   jogInvert  => jogInvert,
   currentDir => jogDir,
   jogStep    => jogStep,
   jogDir     => jogDir,
   jogUpdLoc  => open
   -- dout       => doutJog
   );

 jogEnable <= '1' when (eStop = '0') and (spCtlR.spJogEnable = '1') else '0';
 spActive  <= '1' when state /= idle else '0';
 stepOut   <= jogStep when spCtlR.spJogEnable = '1' else synstep;
 dirOut    <= jogDir  when spCtlR.spJogEnable = '1' else spCtlR.spDir;

 spindleRun: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active

   if (eStop = '1') then
    syncInit <= '0';
    syncEna <= '0';
    state <= idle;
   elsif (spCtlR.spInit = '1') then
    syncInit <= '1';
    state <= idle;
   else

    case state is
     when idle =>
      syncInit <= '0';
      if (spCtlR.spEna = '1') then
       syncInit <= '1';
       state <= run;
      end if;

     when run =>
      syncInit <= '0';
      syncEna <= '1';
      if (spCtlR.spEna = '0') then
       decel <= '1';
       state <= done;
      end if;

      when done =>
      if (decelDone) then
       syncEna <= '0';
       state <= idle;
      end if;
      
     when others =>
      state <= idle;
    end case;
   end if;

  end if;
 end process;

end Behavioral;
