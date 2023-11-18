library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

use work.regDef.all;
use work.IORecord.all;
use work.DbgRecord.all;
use work.conversion.all;
use work.FpgaLatheBitsRec.all;
use work.FpgaLatheBitsFunc.all;

entity LatheCtl is
 generic (dbgPins       : positive := 8;
          synBits       : positive := 32;
          posBits       : positive := 24;
          countBits     : positive := 18;
          distBits      : positive := 18;
          locBits       : positive := 18;
          dbgBits       : positive := 4;
          synDbgBits    : positive := 4;
          rdAddrBits    : positive := 5;
          outBits       : positive := 32;
          opBits        : positive := 8;
          addrBits      : positive := 8;
          seqBits       : positive := 8;
          phaseBits     : positive := 16;
          totalBits     : positive := 32;
          idxClkBits    : positive := 28;
          freqBits      : positive := 16;
          freqCountBits : positive := 32;
          cycleLenBits  : positive := 11;
          encClkBits    : positive := 24;
          cycleClkBits  : positive := 32;
          pwmBits       : positive := 16;
          stepWidth     : positive := 50);
 port (
  clk      : in  std_logic;
  
  -- spiW     : in  DataInp;
  curW     : in  DataInp;

  dout     : out latheCtlData;

  -- spiR     : in  DataOut;
  curR     : in  DataOut;

  aIn      : in  std_logic;
  bIn      : in  std_logic;
  syncIn   : in  std_logic;

  zDro     : in  std_logic_vector(1 downto 0);
  xDro     : in  std_logic_vector(1 downto 0);
  zMpg     : in  std_logic_vector(1 downto 0);
  xMpg     : in  std_logic_vector(1 downto 0);

  pinIn    : in  std_logic_vector(4 downto 0);

  statusR  : out statusRec := statusToRec(statusZero);

  dbg      : out controlDbg;
  -- aux      : out std_logic_vector(7 downto 0) := (others => '0');
  pinOut   : out std_logic_vector(11 downto 0) := (others => '0');
  extOut   : out std_logic_vector(2 downto 0) := (others => '0');
  bufOut   : out std_logic_vector(3 downto 0) := (others => '0');

  zDoneInt : out std_logic := '0';
  xDoneInt : out std_logic := '0'
  
  );
end LatheCtl;

architecture Behavioral of LatheCtl is

 -- control registers

 signal inputsR   : inputsRec;
 signal inputsReg : unsigned(inputsSize-1 downto 0);

 -- signal runReg : runVec;
 -- signal runR   : runRec;

 signal synCtlReg : synCtlVec;
 signal synCtlR   : synCtlRec;

 signal clkCtlReg : clkCtlVec;
 signal clkCtlR   : clkCtlRec;

 signal cfgCtlReg : cfgCtlVec;
 signal cfgCtlR   : cfgCtlRec;

 signal spCtlReg : spCtlVec;
 signal spCtlR   : spCtlRec;

 -- quadrature encoder

 signal ch        : std_logic;
 signal encDir    : std_logic;
 signal direction : std_logic;
 
 -- frequency generator

 signal zFreqGen   : std_logic;
 signal xFreqGen   : std_logic;
 signal dbgFreqGen : std_logic;
 signal spFreqGen  : std_logic;

 signal sync      : std_logic;

 signal intActive : std_logic;
 signal intClk    : std_logic;
 signal xCh       : std_logic;
 signal zCh       : std_logic;
 signal xInit     : std_logic;
 signal zInit     : std_logic;

 signal zAxisStep : std_logic;
 signal xAxisStep : std_logic;
 signal zAxisDir  : std_logic;
 signal xAxisDir  : std_logic;
 signal zExtInit  : std_logic;
 signal xExtInit  : std_logic;
 signal zExtEna   : std_logic;
 signal xExtEna   : std_logic;

 signal zDelayStep : std_logic;
 signal xDelayStep : std_logic;

 signal zFreqGenEna : std_logic;
 signal xFreqGenEna : std_logic;

 signal intZDoneInt : std_logic;
 signal intXDoneInt : std_logic;

 signal zDir  : std_logic := '0';
 signal zStep : std_logic := '0';
 signal xDir  : std_logic := '0';
 signal xStep : std_logic := '0';

 signal zCurrentDir : std_logic := '0';
 signal xCurrentDir : std_logic := '0';

 signal spEna          : std_logic;
 signal spindleStep    : std_logic;
 signal spindleDir     : std_logic;
 signal spindleStepOut : std_logic;
 signal spindleDirOut  : std_logic;

 signal zSwitches : std_logic_vector(3 downto 0);
 signal xSwitches : std_logic_vector(3 downto 0);

 alias eStopIn : std_logic is pinIn(0);
 alias pwmOut  : std_logic is pinOut(10);
 alias chgPump : std_logic is pinOut(11);

 signal eStop  : std_logic;
 signal pwmEna : std_logic;
 
 signal zDroPhase : std_logic_vector(1 downto 0) := (others => '0');
 signal xDroPhase : std_logic_vector(1 downto 0) := (others => '0');
 signal zStepLast : std_logic := '0';

 signal zAxisDro : std_logic_vector(1 downto 0) := (others => '0');
 signal xAxisDro : std_logic_vector(1 downto 0) := (others => '0');
 signal xStepLast : std_logic := '0';

begin

 eStop <= cfgCtlR.cfgEStopEna and (eStopIn xor cfgCtlR.cfgEStopInv);
 statusR.stEStop <= eStop;

 statusR.ctlBusy     <= '0';
 statusR.queNotEmpty <= '0';

 pinOut(0) <= zDir;
 pinOut(1) <= zStep;
 pinOut(2) <= xDir;
 pinOut(3) <= xStep;

 pinOut(7 downto 4) <= (others => '0');

 -- alias digSel: unsigned(1 downto 0) is div(19 downto 18);
 -- pinOut(5 downto 4) <= zMpg;
 -- pinout(7 downto 6) <= xMpg;
 pinOut(9 downto 8) <= zDro;

 -- pinOut(9 downto 4) <= std_logic_vector(div(19 downto 14));

 -- zSwitches <= std_logic_vector(cfgProbeInv &
 --                               cfgCtlReg(c_cfgZPlusInv downto c_cfgzHomeInv));
 -- xSwitches <= std_logic_vector(cfgProbeInv &
 --                               cfgCtlReg(c_cfgXPlusInv downto c_cfgxHomeInv));
 zSwitches <= (cfgCtlR.cfgProbeInv & cfgCtlR.cfgZPlusInv &
               cfgCtlR.cfgZHomeInv & cfgCtlR.cfgZMinusInv);

 xSwitches <= (cfgCtlR.cfgProbeInv & cfgCtlR.cfgXPlusInv &
               cfgCtlR.cfgXHomeInv & cfgCtlR.cfgXMinusInv);

 inputsR <= inputsToRec("00000000" & pinIn);


 bufOutP : process (clk)
 begin
  if (rising_edge(clk)) then
   bufOut <= pinIn(3 downto 0);
  end if;
 end process bufOutP;

 extOut(0) <= spindleDirOut;
 extOut(1) <= spindleStepOut;
 extOut(2) <= pinIn(4);

 statusR.zAxisEna <= zExtEna;
 statusR.xAxisEna <= xExtEna;

 statusR.zAxisDone <= intZDoneInt;
 statusR.xAxisDone <= intXDoneInt;

 statusR.syncActive <= intActive;

 zDoneInt <= intZDoneInt;
 xDoneInt <= intXDoneInt;

 dbg.xCh     <= xCh;
 dbg.zCh     <= zCh;
 dbg.sync    <= ch;
 dbg.xDone   <= intXDoneInt;
 dbg.zDone   <= intZDoneInt;
 dbg.dbgFreq <= dbgFreqGen;

 -- clock divider

 direction <= (not cfgCtlR.cfgEncDirInv) when (cfgCtlR.cfgEnaEncDir = '0') else
              (encDir xor cfgCtlR.cfgEncDirInv);

 inputs : entity work.ShiftOutN
  generic map (opVal   => F_Rd_Inputs,
               n       => inputsSize,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => curR,
   data => inputsReg,
   dout => dout.inputs                  --inputsDout
   );

 inputsReg <= unsigned(inputsToVec(inputsR));

 sync_reg : entity work.CtlReg
  generic map (opVal => F_Ld_Sync_Ctl,
               n     => synCtlSize)
  port map (
   clk  => clk,
   inp  => curW,
   data => synCtlReg
   );

 synCtlR <= synCtlToRec(synCtlReg);

 clk_reg : entity work.CtlReg
  generic map (opVal => F_Ld_Clk_Ctl,
               n     => clkCtlSize)
  port map (
   clk  => clk,
   inp  => curW,
   data => clkCtlReg
   );

 clkCtlR <= clkCtlToRec(clkCtlReg);

 cfg_reg : entity work.CtlReg
  generic map (opVal => F_Ld_Cfg_Ctl,
               n     => cfgCtlSize)
  port map (
   clk  => clk,
   inp  => curW,
   data => cfgCtlReg
   );

 cfgCtlR <= cfgCtlToRec(cfgCtlReg);

 spi_reg : entity work.CtlReg
  generic map (opVal => F_Ld_Sp_Ctl,
               n     => spCtlSize)
  port map (
   clk  => clk,
   inp  => curW,
   data => spCtlReg
   );

 spCtlR <= spCtlToRec(spCtlReg);
 
 -- quadrature encoder

 quad_encoder : entity work.QuadEncoder
  port map (
   clk => clk,
   a   => aIn,
   b   => bIn,
   ch  => ch,
   dir => encDir
   );

 encoderProc : entity work.Encoder
  generic map (opBase       => F_Enc_Base,
               cycleLenBits => cycleLenBits,
               encClkBits   => encClkBits,
               cycleClkbits => cycleClkBits,
               outBits      => outBits)
  port map (
   clk     => clk,

   inp     => curW,
   oRec    => curR,
   dout    => dout.encoder,
   -- dout    => encDout,

   init    => synCtlR.synEncInit,
   ena     => synCtlR.synEncEna,
   ch      => ch,
   active  => intActive,
   intclk  => intClk
   );

 phase_counter : entity work.PhaseCounter
  generic map (opBase    => F_Phase_Base,
               phaseBits => phaseBits,
               totalBits => totalBits,
               outBits   => outBits)
  port map (
   clk     => clk,

   inp     => curW,
   oRec    => curR,
   dout    => dout.phase,
   -- dout    => phaseDOut,

   init    => synCtlR.synPhaseInit,
   genSync => cfgCtlR.cfgGenSync,
   ch      => ch,
   sync    => syncIn,
   dir     => direction,
   syncOut => sync);

 index_clocks : entity work.IndexClocks
  generic map (opval   => F_Rd_Idx_Clks,
               n       => idxClkBits,
               outBits => outBits)
  port map (
   clk   => clk,
   oRec  => curR,
   dout  => dout.index,
   -- dout  => idxClkDout,
   ch    => ch,
   index => sync
   );

 zFreqGenEna <= '1' when ((clkCtlR.zFreqSel = clkFreq) and (zExtEna = '1'))
                else '0';

 zFreq_Gen : entity work.FreqGen
  generic map (opVal    => F_ZAxis_Base + F_Ld_Freq,
               freqBits => freqBits)
  port map (
   clk      => clk,
   inp      => curW,
   ena      => zFreqGenEna,
   pulseOut => zFreqGen
   );

 xFreqGenEna <= '1' when ((clkCtlR.xFreqSel = clkFreq) and (xExtEna = '1'))
                else '0';

 xFreq_Gen : entity work.FreqGen
  generic map (opVal    => F_XAxis_Base + F_Ld_Freq,
               freqBits => freqBits)
  port map (
   clk      => clk,
   inp      => curW,
   ena      => xFreqGenEna,
   pulseOut => xFreqGen
   );

 spFreq_Gen : entity work.FreqGen
  generic map (opVal => F_XAxis_Base + F_Ld_Freq,
               freqBits => freqBits)
  port map (
   clk      => clk,
   inp      => curW,
   ena      => spCtlR.spEna,
   pulseOut => spFreqGen
   );

 dbgFreq_gen : entity work.FreqGenCtr
  generic map (opBase    => F_Dbg_Freq_Base,
               freqBits  => freqBits,
               countBits => freqCountBits)
  port map (
   clk      => clk,
   inp      => curW,
   ena      => clkCtlR.clkDbgFreqEna,
   pulseOut => dbgFreqGen
   );

 step_Delay : process(clk)
 begin
  if (rising_edge(clk)) then
   zDelayStep <= zAxisStep;
   xDelayStep <= xAxisStep;
  end if;
 end process;

 zDro_Sim : process(clk)
 begin
  if (rising_edge(clk)) then
   zStepLast <= zAxisStep;
   if ((zStepLast = '0') and (zAxisStep = '1')) then
    if (zAxisDir = '1') then
     case zDroPhase is
      when "00"   => zDroPhase <= "01";
      when "01"   => zDroPhase <= "11";
      when "11"   => zDroPhase <= "10";
      when "10"   => zDroPhase <= "00";
      when others => zDroPhase <= "00";
     end case;
    else
     case zDroPhase is
      when "00"   => zDroPhase <= "10";
      when "10"   => zDroPhase <= "11";
      when "11"   => zDroPhase <= "01";
      when "01"   => zDroPhase <= "00";
      when others => zDroPhase <= "00";
     end case;
    end if;
   end if;
  end if;
 end process;

 zAxisDro <= zDro when (cfgCtlR.cfgDroStep = '0') else zDroPhase;

 zCh_Data : process(clk)
 begin
  if (rising_edge(clk)) then
   case clkCtlR.zFreqSel is
    when clkFreq    => zCh <= zFreqGen;
    when clkCh      => zCh <= ch;
    when clkIntClk  => zCh <= intClk;
    when clkSlvFreq => zCh <= xFreqGen;
    when clkSlvCh   => zCh <= xCh;
    when clkSpindle => zCh <= spFreqGen;
    when clkDbgFreq => zCh <= dbgFreqGen;
    when others     => zCh <= '0';
   end case;
  end if;
 end process;

 z_Axis : entity work.Axis
  generic map (
   opBase     => F_ZAxis_Base,
   synBits    => synBits,
   posBits    => posBits,
   countBits  => countBits,
   distBits   => distBits,
   locBits    => locBits,
   outBits    => outBits,
   dbgBits    => dbgBits,
   synDbgBits => synDbgBits
   )
  port map (
   clk        => clk,

   inp        => curW,
   oRec       => curR,
   dout       => dout.z,                --zDOut,

   extInit    => xExtInit,
   extEna     => xExtEna,

   ch         => zCh,
   encDir     => direction,
   sync       => sync,

   droQuad    => zAxisDro,
   droInvert  => cfgCtlR.cfgZDroInv,
   mpgQuad    => zMpg,
   jogInvert  => cfgctlR.cfgZJogInv,

   currentDir => zCurrentDir,
   switches   => zSwitches,
   eStop      => eStop,

   dbg        => dbg.z,
   initOut    => zExtInit,
   enaOut     => zExtEna,

   stepOut    => zAxisStep,
   dirOut     => zAxisDir,
   doneInt    => intZDoneInt
   );

 zStep_Pulse : entity work.PulseGen
  generic map (pulseWidth => stepWidth)
  port map (
   clk      => clk,
   pulseIn  => zDelayStep,
   pulseOut => zStep
   );

 xAxisDro <= xDro when (cfgCtlR.cfgDroStep = '0') else xDroPhase;

 xDro_Sim : process(clk)
 begin
  if (rising_edge(clk)) then
   xStepLast <= xAxisStep;
   if ((xStepLast = '0') and (xAxisStep = '1')) then
    if (xAxisDir = '1') then
     case xDroPhase is
      when "00"   => xDroPhase <= "01";
      when "01"   => xDroPhase <= "11";
      when "11"   => xDroPhase <= "10";
      when "10"   => xDroPhase <= "00";
      when others => xDroPhase <= "00";
     end case;
    else
     case xDroPhase is
      when "00"   => xDroPhase <= "10";
      when "10"   => xDroPhase <= "11";
      when "11"   => xDroPhase <= "01";
      when "01"   => xDroPhase <= "00";
      when others => xDroPhase <= "00";
     end case;
    end if;
   end if;
  end if;
 end process;

 xCh_Data : process(clk)
 begin
  if (rising_edge(clk)) then
   case clkCtlR.xFreqSel is
    when clkFreq    => xCh <= xFreqGen;
    when clkCh      => xCh <= ch;
    when clkIntClk  => xCh <= intClk;
    when clkSlvFreq => xCh <= zFreqGen;
    when clkSlvCh   => xCh <= zCh;
    when clkSpindle => xCh <= spFreqGen;
    when clkDbgFreq => xCh <= dbgFreqGen;
    when others     => xCh <= '0';
   end case;
  end if;
 end process;

 x_Axis : entity work.Axis
  generic map (
   opBase     => F_XAxis_Base,
   synBits    => synBits,
   posBits    => posBits,
   countBits  => countBits,
   distBits   => distBits,
   locBits    => locBits,
   outBits    => outBits,
   dbgBits    => dbgBits,
   synDbgBits => synDbgBits
   )
  port map (
   clk        => clk,

   inp        => curW,
   oRec       => curR,
   dout       => dout.x,                --xDOut,

   extInit    => zExtInit,
   extEna     => zExtEna,

   ch         => xCh,
   encDir     => direction,
   sync       => sync,

   droQuad    => xAxisDro,
   droInvert  => cfgCtlR.cfgXDroInv,
   mpgQuad    => xMpg,
   jogInvert  => cfgCtlR.cfgXJogInv,

   currentDir => xCurrentDir,
   switches   => xSwitches,
   eStop      => eStop,

   dbg        => dbg.x,
   initOut    => xExtInit,
   enaOut     => xExtEna,
   stepOut    => xAxisStep,
   dirOut     => xAxisDir,
   doneInt    => intXDoneInt
   );

 xStep_Pulse : entity work.PulseGen
  generic map (pulseWidth => stepWidth)
  port map (
   clk      => clk,
   pulseIn  => xDelayStep,
   pulseOut => xStep
   );

 statusR.zAxisCurDir <= zCurrentDir;
 statusR.xAxisCurDir <= xCurrentDir;

 dirProcess: process(clk)
 begin
  if (rising_edge(clk)) then
   if (zStep = '1') then
    zCurrentDir <= zAxisDir;
    zDir <= zAxisDir xor cfgCtlR.cfgZDirInv;
   end if;
   if (xStep = '1') then
    xCurrentDir <= xAxisDir;
    xDir <= xAxisDir xor cfgCtlR.cfgxDirInv;
   end if;

   if (curR.Op = F_Rd_Status) then
    chgPump <= '1';
   else
    chgPump <= '0';
   end if;
  end if;
 end process;

 spindleProc : entity work.Spindle
  generic map (opBase    => F_Spindle_Base,
               synBits   => synBits,
               posBits   => posBits,
               countBits => countBits,
               outBits   => outBits)
  port map (
   clk => clk,

   inp       => curW,
   oRec      => curR,
   dout      => dout.spindle,           --spindleDout,

   ch        => spFreqGen,
   mpgQuad   => zMpg,
   jogInvert => cfgCtlR.cfgZJogInv,
   eStop     => eStop,
   spActive  => statusR.spindleActive,
   stepOut   => spindleStep,
   dirOut    => spindleDir
   );

 spStep_Pulse : entity work.PulseGen
  generic map (pulseWidth => stepWidth)
  port map (
   clk      => clk,
   pulseIn  => spindleStep,
   pulseOut => spindleStepOut
   );

 spindleDirOut <= spindleDir xor cfgCtlR.cfgSpDirInv;

 pwmEna <= '1' when (eStop = '0') and (cfgCtlR.cfgPWMEna = '1') else '0';
 
 pwmProc : entity work.PWM
  generic map (opBase => F_PWM_Base,
               n      => pwmBits)
  port map (
   clk    => clk,
   inp    => curW,
   ena    => pwmEna,
   pwmOut => pwmOut
   );

end Behavioral;
