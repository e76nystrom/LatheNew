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
          freqBits  : positive;
          scaleBits : positive := 4;
          outBits   : positive);
 port (
  clk       : in  std_logic;
  inp       : in  DataInp;
  oRec      : in  DataOut;
  eStop     : in  std_logic;
  spActive  : out std_logic := '0';
  preStep   : out std_logic := '0';
  stepOut   : out std_logic := '0';
  dirOut    : out std_logic := '0';
  dout      : out SpindleData
  );
end Spindle;

architecture Behavioral of Spindle is

 type fsm is (idle, run, doneWait);
 signal state : fsm;

 signal syncInit   : std_logic := '0';
 signal syncEna    : std_logic := '0';

 signal spStep     : std_logic;
 -- signal lastSpStep : std_logic := '0';

 signal ch         : std_logic;

 signal decelDone  : std_logic;

 signal decel      : std_logic := '0';

 signal spCtlReg   : spCtlVec;
 signal spCtlR     : spCtlRec;

begin
 
 spindleCtlReg : entity work.CtlReg
  generic map (opVal => opBase + F_Ld_Sp_Ctl,
               n     => spCtlSize)
  port map (
   clk  => clk,
   inp  => inp,
   data => spCtlReg
   );

 spCtlR <= spCtlToRec(spCtlReg);

 spFreqProc : entity work.FreqGen
  generic map (opVal    => opBase + F_Ld_Sp_Freq,
               freqBits => freqBits)
  port map (
   clk      => clk,
   inp      => inp,
   ena      => syncEna,
   pulseOut => ch
   );

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
   ch           => ch,
   dout         => dout,
   decelDone    => decelDone,
   synStep      => spStep
   );

 spActive  <= '1' when state /= idle else '0';
 dirOut    <= spCtlR.spDir;
 preStep <= spStep;

 SpindleScale : entity work.Scaler
  generic map (opVal     => opBase + F_Ld_Sp_Scale,
               scaleBits => 4)
  port map (
   clk      => clk,
   inp      => inp,
   init     => spCtlR.spInit,
   inPulse  => spStep,
   outPulse => stepOut
   );

 SpRun: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active

   if (eStop = '1') then
    syncInit <= '0';
    syncEna  <= '0';
    decel    <= '0';
    state    <= idle;
   elsif (spCtlR.spInit = '1') then
    syncInit <= '1';
    state    <= idle;
   else

    case state is
     when idle =>
      syncInit <= '0';
      if (spCtlR.spEna = '1') then
       syncInit <= '1';
       state    <= run;
      end if;

     when run =>
      syncInit <= '0';
      syncEna  <= '1';
      if (spCtlR.spEna = '0') then
       decel <= '1';
       state <= doneWait;
      end if;

     when doneWait =>
      if (decelDone = '1') then
       decel   <= '0';
       syncEna <= '0';
       state   <= idle;
      end if;
      
     when others =>
      state <= idle;
    end case;
    
   end if;

  end if;
 end process;

end Behavioral;
