library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;

entity LatheNew is
 port(
  sysClk : in std_logic;
  
  -- led : out std_logic_vector(7 downto 0) := (7 downto 0 => '0');
  -- dbg : out std_logic_vector(7 downto 0) := (7 downto 0 => '0');
  -- anode : out std_logic_vector(3 downto 0) := (3 downto 0 => '1');
  -- seg : out std_logic_vector(6 downto 0) := (6 downto 0 => '1');

  dclk : in std_logic;
  dout : out std_logic := '0';
  din  : in std_logic;
  dsel : in std_logic;

  aIn : in std_logic;
  bIn : in std_logic;
  syncIn : in std_logic;

  zStep : out std_logic := '0';
  zDir : out std_logic := '0';
  xStep : out std_logic := '0';
  xDir : out std_logic := '0';

  zDoneInt : out std_logic := '0';
  xDoneInt : out std_logic := '0'
  );
end LatheNew;

architecture Behavioral of LatheNew is

 -- component SystemClk is
 --  port(
 --   areset : in std_logic;
 --   inclk0 : in std_logic;
 --   c0 : out std_logic;
 --   locked : out std_logic
 --   );
 -- end component;

component Clock is
 port(
  clockIn : in std_logic;
  clockOut : out std_logic
  );
end Component;

 component SPI is
  generic (opBits : positive);
  port (
   clk : in std_logic;                   --system clock
   dclk : in std_logic;                  --spi clk
   dsel : in std_logic;                  --spi select
   din : in std_logic;                   --spi data in
   shift : out std_logic;                --shift data
   op : out unsigned(opBits-1 downto 0);  --op code
   copy : out std_logic;                 --copy data to be shifted out
   load : out std_logic;                 --load data shifted in
   header : inout std_logic
   );
 end Component;

 component QuadEncoder is
  port (
   clk : in std_logic;
   a : in std_logic;
   b : in std_logic;
   ch : inout std_logic;
   dir : out std_logic;
   dir_ch : out std_logic;
   err : out std_logic);
 end Component;

 component Encoder is
  generic(opBase : unsigned;
          opBits : positive;
          cycleLenBits : positive;
          encClkBits : positive;
          cycleClkbits : positive);
  port(
   clk : in std_logic;                   --system clock
   din : in std_logic;                   --spi data in
   dshift : in std_logic;                --spi shift signal
   op : in unsigned (opBits-1 downto 0); --current operation
   copy : in std_logic;                  --copy for output
   load : in std_logic;                  --load value
   init : in std_logic;                  --init signal
   ena : in std_logic;                   --enable input
   ch : in std_logic;                    --input clock
   dout : out std_logic;                 --data out
   intclk : out std_logic
   );
 end Component;

 component DataSel2_1 is
  port (
   sel : in std_logic;
   a : in std_logic;
   b : in std_logic;
   y : out std_logic
   );
 end component;

 component CtlReg is
  generic(opVal : unsigned;
          opb : positive;
          n : positive);
  port (
   clk : in std_logic;                   --clock
   din : in std_logic;                   --data in
   op : in unsigned(opb-1 downto 0);     --current reg address
   shift : in std_logic;                 --shift data
   load : in std_logic;                  --load to data register
   data : inout  unsigned (n-1 downto 0));
 end Component;

 component PhaseCounter is
  generic (opBase : unsigned;
           opBits : positive;
           phaseBits : positive;
           totalBits : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   copy : in std_logic;
   load : in std_logic;
   init : in std_logic;
   genSync : in std_logic;
   ch : in std_logic;
   sync : in std_logic;
   dir : in std_logic;
   dout : out std_logic;
   syncOut : out std_logic);
 end Component;

 component FreqGen is
  generic(opVal : unsigned;
          opBits : positive;
          freqBits : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in std_logic;
   load : in std_logic;
   op : in unsigned(opBits-1 downto 0);
   ena : in std_logic;
   pulseOut : out std_logic
   );
 end Component;

 component FreqGenCtr is
  generic(opBase : unsigned;
          opBits : positive;
          freqBits : positive;
          freqCountBits: positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in std_logic;
   load : in std_logic;
   op : in unsigned(opBits-1 downto 0);
   pulseOut : out std_logic
   );
 end Component;

 component DataSel8_1 is
  port ( sel : in unsigned (2 downto 0);
         d0 : in std_logic;
         d1 : in std_logic;
         d2 : in std_logic;
         d3 : in std_logic;
         d4 : in std_logic;
         d5 : in std_logic;
         d6 : in std_logic;
         d7 : in std_logic;
         dout : out std_logic);
 end Component;

 component Axis is
  generic (opBase : unsigned;
           opBits : positive;
           synBits : positive;
           posBits : positive;
           countBits : positive;
           distBits : positive;
           locBits : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in std_logic;
   op : in unsigned(opBits-1 downto 0);
   copy : in std_logic;
   load : in std_logic;
   extInit : in std_logic;               --reset
   extEna : in std_logic;                --enable operation
   extUpdLoc : in std_logic;
   ch : in std_logic;
   encDir : in std_logic;
   sync : in std_logic;
   initOut : out std_logic;
   enaOut : out std_logic;
   updLocOut : out std_logic;
   dout : out std_logic;
   stepOut : out std_logic;
   dirOut : out std_logic;
   doneInt : out std_logic
   );
 end Component;

 component PulseGen is
  generic(pulseWidth : positive);
  port ( clk : in std_logic;
         pulseIn : in std_logic;
         pulseOut : out std_logic);
 end Component;

 constant synBits : positive := 32;
 constant posBits : positive := 18;
 constant countBits : positive := 18;
 constant distBits : positive := 18;
 constant locBits : positive := 18;

 constant opBits : positive := 8;
 constant phaseBits : positive := 16;
 constant totalBits : positive := 32;

 constant freqBits : positive := 16;
 constant freqcountBits : positive := 16;

 constant cycleLenBits : positive := 16;
 constant encClkBits : positive := 24;
 constant cycleClkBits : positive := 32;

 constant stepWidth : positive :=  25;

 -- configuration control register

 constant cfgCtlSize : integer := 6;
 signal cfgCtlReg : unsigned(cfgCtlSize-1 downto 0);
 alias cfgZDir    : std_logic is cfgCtlreg(0); -- x01 z direction inverted
 alias cfgXDir    : std_logic is cfgCtlreg(1); -- x02 x direction inverted
 alias cfgSpDir   : std_logic is cfgCtlreg(2); -- x04 spindle directiion inverted
 alias cfgEncDir  : std_logic is cfgCtlreg(3); -- x08 invert encoder direction
 alias cfgEnaEncDir : std_logic is cfgCtlreg(4); -- x10 enable encoder direction
 alias cfgGenSync : std_logic is cfgCtlreg(5); -- x20 no encoder generate sync pulse

 -- clock control register

 constant clkCtlSize : integer := 6;
 signal clkCtlReg : unsigned(clkCtlSize-1 downto 0);
 alias zFreqSel   : unsigned is clkCtlreg(2 downto 0); -- x01 z Frequency select
 alias xFreqSel   : unsigned is clkCtlreg(5 downto 3); -- x08 x Frequency select

 -- sync control register

 constant synCtlSize : integer := 3;
 signal synCtlReg : unsigned(synCtlSize-1 downto 0);
 alias synPhaseInit : std_logic is synCtlreg(0); -- x01 init phase counter
 alias synEncInit : std_logic is synCtlreg(1); -- x02 init encoder
 alias synEncEna  : std_logic is synCtlreg(2); -- x04 enable encoder

 -- system clock

 signal clk : std_logic;

 -- quadrature encoder

 signal ch : std_logic;
 signal encDir : std_logic;
 signal encDirXor : std_logic;
 signal cfgEncDirNot : std_logic;
 signal direction : std_logic;

 -- spi interface

 constant out_bits : positive := 32;
 signal copy : std_logic;               --copy to output register
 signal dshift : std_logic;             --shift data
 signal load : std_logic;               --load to register
 signal op : unsigned (opBits-1 downto 0); --operation code
 signal outReg : unsigned (out_bits-1 downto 0); --output register
 signal header : std_logic;

 -- signal locked : std_logic;

 signal zDOut : std_logic;
 signal xDOut : std_logic;
 signal encDOut : std_logic;
 signal phaseDOut : std_logic;
 
 signal zFreqGen : std_logic;
 signal xFreqGen : std_logic;
 signal dbgFreqGen : std_logic;

 signal sync : std_logic;

 signal intClk : std_logic;
 signal xCh : std_logic;
 signal zCh : std_logic;
 signal xInit : std_logic;
 signal xUpdLoc : std_logic;
 signal zInit : std_logic;
 signal zUpdLoc : std_logic;

 signal zAxisStep : std_logic;
 signal xAxisStep : std_logic;
 signal zAxisDir : std_logic;
 signal xAxisDir : std_logic;
 signal zExtInit : std_logic;
 signal xExtInit : std_logic;
 signal zExtEna : std_logic;
 signal xExtEna : std_logic;

 signal zDelayStep : std_logic;
 signal xDelayStep : std_logic;
 
begin

 -- system clock

 sys_Clk : Clock
  port map(
   clockIn => sysClk,
   clockOut => clk
   );

 -- sys_cpk n: SystemClk
 --  port map (
 --   areset  => '0',
 --   inclk0  => sysClk,
 --   c0      => clk,
 --   locked  => open
 --   );

 quad_encoder : QuadEncoder
  port map (
   clk => clk,
   a => aIn,
   b => bIn,
   ch => ch,
   dir => encDir,
   dir_ch => open,
   err => open
   );

 -- encDout <= '0';
 -- intClk <= '0';

 encoderProc : Encoder
  generic map(opBase => F_Enc_Base,
              opBits => opBits,
              cycleLenBits => cycleLenBits,
              encClkBits => encClkBits,
              cycleClkbits => cycleClkBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   load => load,
   init => synEncInit,
   ena => synEncEna,
   ch => ch,
   dout => encDout,
   intclk => intClk
   );

 encDirXor <= encDir xor cfgEncDir;
 cfgEncDirNot <= not cfgEncDir;

 EncoderDir: DataSel2_1
  port map (
   sel => cfgEnaEncDir,
   a => cfgEncDirNot,
   b => encDirXor,
   y => direction
   );

 dout <= zDOut or xDOut or encDOut or phaseDOut;

 spi_int : SPI
  generic map (opBits => opBits)
  port map (
   clk => clk,
   dclk => dclk,
   dsel => dsel,
   din => din,
   shift => dshift,
   op => op,
   copy => copy,
   load => load,
   header => header
   );

 sync_reg: CtlReg
  generic map(opVal => F_Ld_Sync_Ctl,
              opb => opBits,
              n => synCtlSize)
  port map (
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   load => load,
   data => synCtlReg);

 clk_reg: CtlReg
  generic map(opVal => F_Ld_Clk_Ctl,
              opb => opBits,
              n => clkCtlSize)
  port map (
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   load => load,
   data => clkCtlReg);

 cfg_reg : CtlReg
  generic map(opVal => F_Ld_Cfg_Ctl,
              opb => opBits,
              n => cfgCtlSize)
  port map (
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   load => load,
   data => cfgCtlReg);

 phase_counter : PhaseCounter
  generic map (opBase => F_Phase_Base,
               opBits => opBits,
               phaseBits => phaseBits,
               totalBits => totalBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   load => load,
   init => synPhaseInit,
   genSync => cfgGenSync,
   ch => ch,
   sync => syncIn,
   dir => direction,
   dout => phaseDOut,
   syncOut => sync);

 zFreq_Gen : FreqGen
  generic map(opVal => F_Ld_Z_Freq,
              opBits => opBits,
              freqBits => freqBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   load => load,
   op => op,
   ena => zExtEna,
   pulseOut => zFreqGen
   );

 xFreq_Gen : FreqGen
  generic map(opVal => F_Ld_X_Freq,
              opBits => opBits,
              freqBits => freqBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   load => load,
   op => op,
   ena => xExtEna,
   pulseOut => xFreqGen
   );

 dbgFreq_gen : FreqGenCtr
  generic map(opBase => F_Dbg_Freq_Base,
              opBits => opBits,
              freqBits => freqBits,
              freqCountBits=> freqCountBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   load => load,
   op => op,
   pulseOut => dbgFreqGen
   );

 step_Delay : process(clk)
 begin
  if (rising_edge(clk)) then
   zDelayStep <= zAxisStep;
   xDelayStep <= xAxisStep;
  end if;
 end process;
 
 zCh_Data : DataSel8_1
  port map (
   sel => zFreqSel,
   d0 => zFreqGen,
   d1 => ch,
   d2 => intClk,
   d3 => xDelayStep,
   d4 => xFreqGen,
   d5 => '0',
   d6 => '0',
   d7 => dbgFreqGen,
   dout => zCh
   );

 z_Axis : Axis
  generic map (opBase => F_ZAxis_Base,
               opBits => opBits,
               synBits => synBits,
               posBits => posBits,
               countBits => countBits,
               distBits => distBits,
               locBits => locBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   load => load,
   extInit => xExtInit,
   extEna => xExtEna,
   extUpdLoc => xUpdLoc,
   ch => zCh,
   encDir => direction,
   sync => sync,
   initOut => zExtInit,
   enaOut => zExtEna,
   updLocOut => zUpdLoc,
   dout => zDOut,
   stepOut => zAxisStep,
   dirOut => zAxisDir,
   doneInt => zDoneInt
   );

 zStep_Pulse: PulseGen
  generic map(pulseWidth => stepWidth)
  port map (
   clk => clk,
   pulseIn => zAxisStep,
   pulseOut => zStep
   );

 zDir <= zAxisDir xor cfgZDir;
 
 xCh_Data : DataSel8_1
  port map (
   sel => xFreqSel,
   d0 => xFreqGen,
   d1 => ch,
   d2 => intClk,
   d3 => zDelayStep,
   d4 => zFreqGen,
   d5 => '0',
   d6 => '0',
   d7 => dbgFreqGen,
   dout => xCh)
  ;

 x_Axis : Axis
  generic map (opBase => F_XAxis_Base,
               opBits => opBits,
               synBits => synBits,
               posBits => posBits,
               countBits => countBits,
               distBits => distBits,
               locBits => locBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   load => load,
   extInit => zExtInit,
   extEna => zExtEna,
   extUpdLoc => zUpdLoc,
   ch => xCh,
   encDir => direction,
   sync => sync,
   initOut => xExtInit,
   enaOut => xExtEna,
   updLocOut => xUpdLoc,
   dout => xDOut,
   stepOut => xAxisStep,
   dirOut => xAxisDir,
   doneInt => xDoneInt
   );

 xStep_Pulse : PulseGen
  generic map(pulseWidth => stepWidth)
  port map (
   clk => clk,
   pulseIn => xAxisStep,
   pulseOut => xStep
   );
 
 xDir <= xAxisDir xor cfgxDir;

end Behavioral;

