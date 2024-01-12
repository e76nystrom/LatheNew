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
          inputPins     : positive := 13;
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

  pinIn    : in  std_logic_vector(inputPins-1 downto 0);

  statusR  : out statusRec := statusToRec(statusZero);

  dbg      : out controlDbg;
  -- aux      : out std_logic_vector(7 downto 0) := (others => '0');
  pinOut   : out std_logic_vector(11 downto 0) := (others => '0');
  extOut   : out std_logic_vector(2 downto 0)  := (others => '0');
  bufOut   : out std_logic_vector(3 downto 0)  := (others => '0');

  zDoneInt : out std_logic := '0';
  xDoneInt : out std_logic := '0'
  
  );
end LatheCtl;

architecture Behavioral of LatheCtl is

 -- control registers

 signal inputsR   : inputsRec;

 signal pinOutR : pinOutRec;

 signal outPinReg : outputsVec;
 signal outPinR   : outputsRec;

 signal synCtlReg : synCtlVec;
 signal synCtlR   : synCtlRec;

 signal clkCtlReg : clkCtlVec;
 signal clkCtlR   : clkCtlRec;

 signal cfgCtlReg : cfgCtlVec;
 signal cfgCtlR   : cfgCtlRec;

 signal spCtlReg : spCtlVec;
 signal spCtlR   : spCtlRec;

 -- quadrature encoder

 signal quadCh    : std_logic;
 signal ch        : std_logic;
 signal encDir    : std_logic;
 signal direction : std_logic;
 
 -- frequency generator

 signal zFreqGen   : std_logic;
 signal xFreqGen   : std_logic;
 signal dbgFreqGen : std_logic;
 signal spFreqGen  : std_logic;

 -- sync signals

 signal dbgSync     : std_logic;
 signal phaseSyncIn : std_logic;
 signal sync        : std_logic;

 signal intActive : std_logic;
 signal intClk    : std_logic;
 signal encCh     : std_logic;
 signal xCh       : std_logic;
 signal zCh       : std_logic;
 signal xInit     : std_logic;
 signal zInit     : std_logic;
 signal zAxisIn   : axisInRec;

 signal zAxisStep : std_logic;
 signal xAxisStep : std_logic;

 signal zAxisDir  : std_logic;
 signal xAxisDir  : std_logic;

 signal zExtInit  : std_logic;
 signal xExtInit  : std_logic;

 signal zExtEna   : std_logic;
 signal zExtRunOutEna : std_logic;
 
 signal xExtEna   : std_logic;

 signal xAxisIn   : axisInRec;

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

 -- signal zSwitches : std_logic_vector(3 downto 0);
 -- signal xSwitches : std_logic_vector(3 downto 0);

 alias eStopIn : std_logic is inputsR.inPin10;
 -- alias pwmOut  : std_logic is pinOut(10);
 -- alias chgPump : std_logic is pinOut(11);

 signal eStop     : std_logic;
 signal pwmEna    : std_logic;
 
 signal zDroPhase : std_logic_vector(1 downto 0) := (others => '0');
 signal xDroPhase : std_logic_vector(1 downto 0) := (others => '0');
 signal zStepLast : std_logic := '0';

 signal zAxisDro  : std_logic_vector(1 downto 0) := (others => '0');
 signal zDroSel   : std_logic_vector(1 downto 0) := (others => '0');
 signal xAxisDro  : std_logic_vector(1 downto 0) := (others => '0');
 signal xDroSel   : std_logic_vector(1 downto 0) := (others => '0');
 signal xStepLast : std_logic := '0';

 signal dbgEncScale : EncScaleDbg;

begin

 inputsR <= inputsToRec(pinIn);

 eStop <= cfgCtlR.cfgEStopEna and (eStopIn xor cfgCtlR.cfgEStopInv);
 statusR.stEStop <= eStop;

 pinOut <= pinOutToVec(pinOutR);

 pinOutR.pinOut2  <= zDir; 
 pinOutR.pinOut3  <= zStep;
 pinOutR.pinOut4  <= xDir; 
 pinOutR.pinOut5  <= xStep;
 pinOutR.pinOut6  <= '0';
 pinOutR.pinOut7  <= '0';
 pinOutR.pinOut8  <= '0';
 pinOutR.pinOut9  <= '0';
 pinOutR.pinOut1  <= outPinR.outPin1;
 pinOutR.pinOut14 <= outPinR.outPin14;

 bufOutP : process (clk)
 begin
  if (rising_edge(clk)) then
   bufOut <= pinIn(3 downto 0);
  end if;
 end process bufOutP;

 extOut(0) <= spindleDirOut;
 extOut(1) <= spindleStepOut;

 extOut(2) <= inputsR.inZHome;

 statusR.zAxisEna <= zExtEna;
 statusR.xAxisEna <= xExtEna;

 statusR.zAxisDone <= intZDoneInt;
 statusR.xAxisDone <= intXDoneInt;

 statusR.syncActive <= intActive;

 zDoneInt <= intZDoneInt;
 xDoneInt <= intXDoneInt;

 dbg.xCh      <= xCh;
 dbg.zCh      <= zCh;
 dbg.sync     <= ch;
 dbg.xDone    <= intXDoneInt;
 dbg.zDone    <= intZDoneInt;
 dbg.dbgFreq  <= dbgFreqGen;
 dbg.encScale <= dbgEncScale;

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
   data => unsigned(pinIn),
   dout => dout.inputs
   );

 outPin_reg : entity work.CtlReg
  generic map (opVal => F_Ld_Out_Reg,
               n     => outputsSize)
  port map (
   clk  => clk,
   inp  => curW,
   data => outPinReg
   );

 outPinR <= outputsToRec(outPinReg);

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

ch <= quadCh when (clkCtlR.clkDbgSyncEna = '0') else dbgFreqGen;

 quad_encoder : entity work.QuadEncoder
  port map (
   clk => clk,
   a   => aIn,
   b   => bIn,
   ch  => quadCh,
   dir => encDir
   );

 enc_clk : process(clk)
 begin
  if (rising_edge(clk)) then
   case synCtlR.synEncClkSel is
    when encClkCh  => encCh <= ch;
    when encClkSp  => encCh <= spFreqGen;
    when encClkDbg => encCh <= dbgFreqGen;
    when others    => encCh <= '0';
   end case;
  end if;
 end process;

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

   init    => synCtlR.synEncInit,
   ena     => synCtlR.synEncEna,
   ch      => encCh,

   dbg     => dbgEncScale,
   dout    => dout.encoder,
   active  => intActive,
   intclk  => intClk
   );

 phaseSyncIn <= syncIn when (clkCtlR.clkDbgSyncEna = '0') else dbgSync;

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

   init    => synCtlR.synPhaseInit,
   genSync => cfgCtlR.cfgGenSync,
   ch      => ch,
   sync    => phaseSyncIn,
   dir     => direction,
   syncOut => sync);

 index_clocks : entity work.IndexClocks
  generic map (opBase  => F_Index_Base,
               n       => idxClkBits,
               outBits => outBits)
  port map (
   clk     => clk,
   inp     => curW,
   oRec    => curR,
   dout    => dout.index,
   axisEna => zExtEna,
   ch      => ch,
   index   => sync
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
   syncOut  => dbgSync,
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

 zDroSel <= zDro when (cfgCtlR.cfgDroStep = '0') else zDroPhase;

 zAxisDro(0) <= zDroSel(0) when (cfgCtlR.cfgZDroInv = '0') else zDroSel(1);
 zAxisDro(1) <= zDroSel(1) when (cfgCtlR.cfgZDroInv = '0') else zDroSel(0);

 zAxisIn.axHome  <= inputsR.inZHome  xor cfgCtlR.cfgZHomeInv;
 zAxisIn.axMinus <= inputsR.inZMinus xor cfgCtlR.cfgZMinusInv;
 zAxisIn.axPlus  <= inputsR.inZPlus  xor cfgCtlR.cfgZPlusInv;
 zAxisIn.axProbe <= inputsR.inProbe  xor cfgCtlR.cfgProbeInv;

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
   dout       => dout.z,

   extInit    => xExtInit,
   extEna     => xExtEna,
   extDone    => intXDoneInt,

   ch         => zCh,
   encDir     => direction,
   sync       => sync,

   droQuad    => zAxisDro,
   axisIn     => zAxisIn,
   currentDir => zCurrentDir,
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

 xDroSel <= xDro when (cfgCtlR.cfgDroStep = '0') else xDroPhase;

 xAxisDro(0) <= xDroSel(0) when (cfgCtlR.cfgXDroInv = '0') else xDroSel(1);
 xAxisDro(1) <= xDroSel(1) when (cfgCtlR.cfgXDroInv = '0') else xDroSel(0);

 xAxisIn.axHome  <= inputsR.inXHome  xor cfgCtlR.cfgXHomeInv;
 xAxisIn.axMinus <= inputsR.inXMinus xor cfgCtlR.cfgXMinusInv;
 xAxisIn.axPlus  <= inputsR.inXPlus  xor cfgCtlR.cfgXPlusInv;
 xAxisIn.axProbe <= inputsR.inProbe  xor cfgCtlR.cfgProbeInv;

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

 RunOut_Ctl : entity work.RunOutSync
  generic map (
   opBase        => F_RunOut_Base,
   runOutCtrBits => 18
   )
  port map (
   clk     => clk,
   inp     => curW,
   enable  => zExtEna,
   step    => zDelayStep,
   rEnable => zExtRunOutEna
   );

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
   dout       => dout.x,

   extInit    => zExtInit,
   extEna     => zExtRunOutEna,
   extDone    => intZDoneInt,

   ch         => xCh,
   encDir     => direction,
   sync       => sync,

   droQuad    => xAxisDro,
   axisIn     => xAxisIn,
   currentDir => xCurrentDir,
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

   if (curR.Op = F_Rd_Status) then      --charge pump
     pinOutR.pinOut17 <= '1';
   else
     pinOutR.pinOut17 <= '0';
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
   dout      => dout.spindle,

   ch        => spFreqGen,
   mpgQuad   => zMpg,
   jogInvert => cfgCtlR.cfgZMpgInv,
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
   pwmOut =>  pinOutR.pinOut16
   );

end Behavioral;
