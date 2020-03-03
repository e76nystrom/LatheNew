library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.conversion.all;

entity LatheNew is
 port(
  sysClk : in std_logic;
  
  led : out std_logic_vector(7 downto 0) := (7 downto 0 => '0');
  dbg : out std_logic_vector(7 downto 0) := (7 downto 0 => '0');
  anode : out std_logic_vector(3 downto 0) := (3 downto 0 => '1');
  seg : out std_logic_vector(6 downto 0) := (6 downto 0 => '1');

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
   shift : out boolean;                  --shift data
   op : out unsigned(opBits-1 downto 0);  --op code
   copy : out boolean;                   --copy data to be shifted out
   load : out boolean;                   --load data shifted in
   header : out boolean;
   spiActive : out boolean
   );
 end Component;

 component Controller is
  generic (opBase : unsigned;
           opBits : positive;
           addrBits : positive;
           statusBits : positive;
           seqBits : positive;
           outBits : positive
           );
  port (
   clk : in std_logic;
   -- init : in boolean;
   init : in std_logic;
   din : in std_logic;
   dshift : in boolean;
   op : in unsigned(opBits-1 downto 0);
   copy : in boolean;
   load : in boolean;
   -- ena : in boolean;
   ena : in std_logic;
   statusReg : in unsigned(statusBits-1 downto 0);

   dout : out std_logic;
   dinOut : out std_logic;
   dshiftOut : out boolean;
   opOut : out unsigned(opBits-1 downto 0);
   loadOut : out boolean;
   empty : out boolean
   );
 end Component;

 component Reader is
  generic(opBase : unsigned;
          opBits : positive;
          rdAddrBits : positive;
          outBits : positive
          );
  port (
   clk : in std_logic;
   init : in std_logic;
   din : in std_logic;
   dshift : in boolean;
   op : in unsigned(opBits-1 downto 0);
   copy : in boolean;
   load : in boolean;
   copyOut : out boolean;
   opOut : out unsigned(opBits-1 downto 0);
   active : out boolean
   );
 end Component;

 component Display is
  port (
   clk : in std_logic;
   dspreg : in unsigned(15 downto 0);
   digSel : in unsigned(1 downto 0);
   anode : out std_logic_vector(3 downto 0);
   seg : out std_logic_vector(6 downto 0)
   );
 end Component;

 component DisplayCtl is
  generic (opVal : unsigned;
           opBits : positive;
           displayBits : positive;
           outBits : positive);
  port (
   clk : in std_logic;
   dsel : in Std_logic;
   din : in std_logic;
   shift : in boolean;
   op : in unsigned (opBits-1 downto 0);
   dout : in std_logic;
   dspCopy : out boolean;
   dspShift : out boolean;
   dspOp : inout unsigned (opBits-1 downto 0);
   dspreg : inout unsigned (displayBits-1 downto 0)
   );
 end Component;

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
   clk : in std_logic;                  --system clock
   din : in std_logic;                  --spi data in
   dshift : in boolean;                 --spi shift signal
   op : in unsigned (opBits-1 downto 0); --current operation
   load : in boolean;                   --load value
   dshiftR : in boolean;                --spi shift signal
   opR : in unsigned (opBits-1 downto 0); --current operation
   copyR : in boolean;                  --copy for output
   init : in std_logic;                 --init signal
   ena : in std_logic;                  --enable input
   ch : in std_logic;                   --input clock
   dout : out std_logic;                --data out
   active : out std_logic;              --active
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
   shift : in boolean;                   --shift data
   load : in boolean;                    --load to data register
   data : inout  unsigned (n-1 downto 0));
 end Component;

 component PhaseCounter is
  generic (opBase : unsigned;
           opBits : positive;
           phaseBits : positive;
           totalBits : positive;
           outBits : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in boolean;
   op : in unsigned (opBits-1 downto 0);
   load : in boolean;
   dshiftR : in boolean;
   opR : in unsigned (opBits-1 downto 0);
   copyR : in boolean;
   init : in std_logic;
   genSync : in std_logic;
   ch : in std_logic;
   sync : in std_logic;
   dir : in std_logic;
   dout : out std_logic;
   syncOut : out std_logic);
 end Component;

 component IndexClocks is
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
   dout : out std_logic
   );
 end Component;

 component FreqGen is
  generic(opVal : unsigned;
          opBits : positive;
          freqBits : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in boolean;
   op : in unsigned(opBits-1 downto 0);
   load : in boolean;
   ena : in std_logic;
   pulseOut : out std_logic
   );
 end Component;

 component FreqGenCtr is
  generic(opBase : unsigned;
          opBits : positive;
          freqBits : positive;
          countBits: positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in boolean;
   op : in unsigned(opBits-1 downto 0);
   load : in boolean;
   ena : in std_logic;
   pulseOut : out std_logic
   );
 end Component;

 component DataSelSyn8_1 is
  port (
   clk : in std_logic;
   sel : in unsigned (2 downto 0);
   d0 : in std_logic;
   d1 : in std_logic;
   d2 : in std_logic;
   d3 : in std_logic;
   d4 : in std_logic;
   d5 : in std_logic;
   d6 : in std_logic;
   d7 : in std_logic;
   dout : out std_logic
   );
 end Component;

 component Axis is
  generic (opBase : unsigned;
           opBits : positive;
           synBits : positive;
           posBits : positive;
           countBits : positive;
           distBits : positive;
           locBits : positive;
           outBits : positive;
           dbgBits : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in boolean;
   op : in unsigned(opBits-1 downto 0);
   load : in boolean;
   dshiftR : in boolean;
   opR : in unsigned(opBits-1 downto 0);
   copyR : in boolean;
   extInit : in std_logic;               --reset
   extEna : in std_logic;                --enable operation
   extUpdLoc : in std_logic;
   ch : in std_logic;
   encDir : in std_logic;
   sync : in std_logic;
   dbgOut : out unsigned(dbgBits-1 downto 0);
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

 -- clock divider

 constant divBits : integer := 26;
 signal div : unsigned (divBits downto 0) := (others => '0');
 alias digSel: unsigned(1 downto 0) is div(19 downto 18);
 -- alias digSel: unsigned(1 downto 0) is div(8 downto 7);

 constant synBits : positive := 32;
 constant posBits : positive := 24;
 constant countBits : positive := 18;
 constant distBits : positive := 18;
 constant locBits : positive := 18;

 constant dbgBits : positive := 4;

 constant rdAddrBits : positive := 5;
 constant outBits : positive := 32;
 
 constant opBits : positive := 8;
 constant addrBits : positive := 8;
 constant seqBits : positive := 8;

 constant phaseBits : positive := 16;
 constant totalBits : positive := 32;

 constant idxClkBits : positive := 28;
 -- constant idxClkBits : positive := 16; 

 constant freqBits : positive := 16;
 constant freqCountBits : positive := 32;

 constant cycleLenBits : positive := 16;
 constant encClkBits : positive := 24;
 constant cycleClkBits : positive := 32;

 constant stepWidth : positive :=  25;

-- status register

 constant statusSize : integer := 7;
 signal statusReg : unsigned(statusSize-1 downto 0);
 alias zAxisEna   : std_logic is statusreg(0); -- x01 z axis enable flag
 alias zAxisDone  : std_logic is statusreg(1); -- x02 z axis done
 alias xAxisEna   : std_logic is statusreg(2); -- x04 x axis enable flag
 alias xAxisDone  : std_logic is statusreg(3); -- x08 x axis done
 alias queEmpty   : std_logic is statusreg(4); -- x10 controller queue empty
 alias ctlIdle    : std_logic is statusreg(5); -- x20 controller idle
 alias syncActive : std_logic is statusreg(6); -- x40 sync active

-- run control register

 constant runSize : integer := 3;
 signal runReg : unsigned(runSize-1 downto 0);
 alias runEna     : std_logic is runreg(0); -- x01 run from controller data
 alias runInit    : std_logic is runreg(1); -- x02 initialize controller
 alias readerInit : std_logic is runreg(2); -- x04 initialize reader

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

 constant clkCtlSize : integer := 7;
 signal clkCtlReg : unsigned(clkCtlSize-1 downto 0);
 alias zFreqSel   : unsigned is clkCtlreg(2 downto 0); -- x01 z Frequency select
 alias xFreqSel   : unsigned is clkCtlreg(5 downto 3); -- x08 x Frequency select
 alias clkDbgFreqEna : std_logic is clkCtlreg(6); -- x40 enable debug frequency

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

 signal spiShift : boolean := false;
 signal spiOp : unsigned (opBits-1 downto 0) := (others => '0');
 signal spiCopy : boolean := false;
 signal spiLoad : boolean := false;
 signal spiActive : boolean := false;

 signal internalDout : std_logic;

 signal dinW : std_logic := '0';

 signal curDin : std_logic := '0';      --current din

 signal dshift : boolean := false;         --shift data
 signal op : unsigned (opBits-1 downto 0); --operation code
 signal load : boolean := false;           --load to register

 signal dshiftR : boolean := false;         --shift data
 signal opR : unsigned (opBits-1 downto 0); --operation code
 signal copyR : boolean := false;           --copy to output register
-- signal header : boolean;

 -- controller

 signal ctlDin : std_logic;
 signal ctlShift : boolean;
 signal ctlOp : unsigned (opBits-1 downto 0); --operation code
 signal ctlLoad : boolean;
 signal ctlEmpty : boolean;
 signal ctlDout : std_logic;

 -- reader

 signal rdActive : boolean;
 signal rdCopy : boolean;
 signal rdOp : unsigned (opBits-1 downto 0); --operation code
 
 -- display

 constant displayBits : positive := 16;
 signal dspCopy : boolean;
 signal dspShift : boolean;
 signal dspOp : unsigned (opBits-1 downto 0);

 signal dspData : unsigned (displayBits-1 downto 0);

 -- signal locked : std_logic;

 signal statusDout : std_logic;
 signal phaseDOut : std_logic;
 signal encDOut : std_logic;
 signal zDOut : std_logic;
 signal xDOut : std_logic;
 signal idxClkDout : std_logic;
 
 signal zFreqGen : std_logic;
 signal xFreqGen : std_logic;
 signal dbgFreqGen : std_logic;

 signal sync : std_logic;

 signal intActive : std_logic;
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

 signal test1 : std_logic;
 signal test2 : std_logic;
 signal test3 : std_logic;

 signal zDbg : unsigned(3 downto 0);
 signal xDbg : unsigned(3 downto 0);

 signal zFreqGenEna : std_logic;
 signal xFreqGenEna : std_logic;

 signal intZDoneInt : std_logic;
 signal intXDoneInt : std_logic;

begin

 zAxisEna <= zExtEna;
 zDoneInt <= intZDoneInt;
 xAxisEna <= xExtEna;
 xDoneInt <= intXDoneInt;

 zAxisDone <= intZDoneInt;
 xAxisDone <= intXDoneInt;

 queEmpty <= to_std_logic(ctlEmpty);
 syncActive <= intActive;

 led(7) <= div(divBits);
 led(6) <= div(divBits-1);
 led(5) <= div(divBits-2);
 led(4) <= div(divBits-3);
 led(3) <= op(3);
 led(2) <= clkCtlReg(2);
 led(1) <= clkCtlReg(1);
 led(0) <= clkCtlReg(0);

 dspData(3 downto 0) <= zDbg;
 dspData(7 downto 4) <= xDbg;
 dspData(15 downto 8) <= op;

 -- test 1 output pulse

 testOut1 : PulseGen
  generic map (pulseWidth => 25)
  port map (
   clk => clk,
   pulseIn => xCh,
   PulseOut => test1
   );

-- test 2 output pulse

 testOut2 : PulseGen
  generic map (pulseWidth => 25)
  port map (
   clk => clk,
   pulseIn => zCh,
   pulseOut => test2
   );

 testOut3 : PulseGen
  generic map (pulseWidth => 25)
  port map (
   clk => clk,
   pulseIn => sync,
   pulseOut => test3
   );

 dbg(0) <= test1;
 dbg(1) <= test2;

 dbg(2) <= intZDoneInt;
 -- dbg(3) <= intXDoneInt;
 dbg(3) <= test3;
 dbg(7 downto 4) <= std_logic_vector(zDbg);

 -- dbg(4) = dbgOUt(0) <= runEna;
 -- dbg(5) = dbgOut(1) <= distDecel;
 -- dbg(6) = dbgOut(2) <= distZero;
 -- dbg(7) = dbgOut(3) <= syncAccelActive;

 -- dbg(2) <= zDbg(0);
 -- dbg(3) <= intZDoneInt;
 -- dbg(7 downto 4) <= std_logic_vector(zDbg);

 -- dbg(4) <= div(divBits-4);
 -- dbg(5) <= div(divBits-5);
 -- dbg(6) <= div(divBits-6);
 -- dbg(7) <= div(divBits-7);

 -- system clock

 sys_Clk : Clock
  port map(
   clockIn => sysClk,
   clockOut => clk
   );

 -- clock divider

 clk_div: process(clk)
 begin
  if (rising_edge(clk)) then
   div <= div + 1;
  end if;
 end process;

 -- led display

 led_display : Display
  port map (
   clk => clk,
   dspReg => dspData,
   digSel => digSel,
   anode => anode,
   seg => seg
   );

 -- quadrature encoder

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
   din => curDin,
   dshift => dshift,
   op => op,
   load => load,
   dshiftR => dshiftR,
   opR => opR,
   copyR => copyR,
   init => synEncInit,
   ena => synEncEna,
   ch => ch,
   dout => encDout,
   active => intActive,
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

 internalDout <= statusDout or ctlDout or phaseDout or idxClkDout or
                 EncDout or zDOut or xDOut;
 dout <= internalDout;

 -- curDin <= din;
 -- dshift <= spiShift;
 -- op <= spiOp;
 -- load <= spiLoad;

 curDin <= ctlDin when runEna = '1' else din;
 dshift <= ctlShift when runEna = '1' else spiShift;
 op <= ctlOp when runEna = '1' else spiOp;
 load <= ctlLoad when runEna = '1' else spiLoad;

 -- dshiftR <= spiShift when spiActive else dspShift;
 -- opR <= spiOp when spiActive else dspOp;
 -- copyR <= spiCopy when spiActive else dspCopy;
 
 readProc : process (spiActive, rdActive,
                     spiShift, spiCopy, spiOp,
                     rdCopy, rdOp,
                     dspShift, dspCopy, dspOp)
 begin
  if (rdActive) then
   dshiftR <= spiShift;
   copyR <= rdCopy;
   opR <= rdOp;
  elsif spiActive then
   dshiftR <= spiShift;
   copyR <= spiCopy;
   opR <= spiOp;
  else
   dshiftR <= dspShift;
   copyR <= dspCopy;
   opR <= dspOp;
  end if;
 end process readProc;

 -- dshift <= spiShift;
 -- op <= spiOp;
 -- copy <= spiCopy;

 spi_int : SPI
  generic map (opBits => opBits)
  port map (
   clk => clk,
   dclk => dclk,
   dsel => dsel,
   din => din,
   shift => spiShift,
   op => spiOp,
   copy => spiCopy,
   load => spiLoad,
   header => open,
   spiActive => spiActive
   );

 ctrlProc : Controller
  generic map (opBase => F_Ctrl_Base,
               opBits => opBits,
               addrBits => addrBits,
               statusBits => statusSize,
               seqBits => seqBits,
               outBits => outBits
               )
  port map (
   clk => clk,
   -- init => to_boolean(runInit),
   init => runInit,
   din => din,
   dshift => spiShift,
   op => spiOp,
   copy => spiCopy,
   load => load,
   -- ena => to_boolean(runEna),
   ena => runEna,
   statusReg => statusReg,
   dout => ctlDout,
   dinOut => ctlDin,
   dshiftOut => ctlShift,
   opOut => ctlOp,
   loadOut => ctlLoad,
   empty => ctlEmpty
   );

 dataReader: Reader
  generic map(opBase => F_Read_Base,
         opBits => opBits,
         rdAddrBits => rdAddrBits,
         outBits => outBits
)
  port map (
  clk => clk,
  init => readerInit,
  din => din,
  dshift => spiShift,
  op => spiOp,
  copy => spiCopy,
  load => load,
  copyOut => rdCopy,
  opOut => rdOp,
  active => rdActive
  );

 dispalyCtlProc : DisplayCtl
  generic map (opVal => F_Ld_Dsp_Reg,
               opBits => opBits,
               displayBits => displayBits,
               outBits => outBits
               )
  port map (
   clk => clk,
   dsel => dsel,
   din => din,
   shift => spiShift,
   op => spiOp,
   dout => internalDout,
   dspCopy => dspCopy,
   dspShift => dspShift,
   dspOp => dspOp,
   -- dspreg => dspData
   dspReg => open
   );

 status: ShiftOutN
  generic map(opVal => F_Rd_Status,
              opBits => opBits,
              n => statusSize,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => spiShift,
   op => spiOp,
   copy => spiCopy,
   data => statusReg,
   dout => statusDout
   );

 run_reg: CtlReg
  generic map(opVal => F_Ld_Run_Ctl,
              opb => opBits,
              n => runSize)
  port map (
   clk => clk,
   din => din,
   op => spiOp,
   shift => spiShift,
   load => spiLoad,
   data => runReg);

 sync_reg: CtlReg
  generic map(opVal => F_Ld_Sync_Ctl,
              opb => opBits,
              n => synCtlSize)
  port map (
   clk => clk,
   din => curDin,
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
   din => curDin,
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
   op => spiOp,
   shift => spiShift,
   load => spiLoad,
   data => cfgCtlReg);

 phase_counter : PhaseCounter
  generic map (opBase => F_Phase_Base,
               opBits => opBits,
               phaseBits => phaseBits,
               totalBits => totalBits,
               outBits => outBits)
  port map (
   clk => clk,
   din => curDin,
   dshift => dshift,
   op => op,
   load => load,
   dshiftR => dshiftR,
   opR => opR,
   copyR => copyR,
   init => synPhaseInit,
   genSync => cfgGenSync,
   ch => ch,
   sync => syncIn,
   dir => direction,
   dout => phaseDOut,
   syncOut => sync);

 index_clocks: IndexClocks
  generic map (opval => F_Rd_Idx_Clks,
               opBits => opBits,
               n => idxClkBits,
               outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftR,
   op => opR,
   copy => copyR,
   ch => ch,
   index => sync,
   dout => idxClkDout
   );

 zFreqGenEna <= '1' when ((zFreqSel = "001") and (zExtEna = '1')) else '0';

 zFreq_Gen : FreqGen
  generic map(opVal => F_ZAxis_Base + F_Ld_Freq,
              opBits => opBits,
              freqBits => freqBits)
  port map (
   clk => clk,
   din => curDin,
   dshift => dshift,
   op => op,
   load => load,
   ena => zFreqGenEna,
   pulseOut => zFreqGen
   );

 xFreqGenEna <= '1' when ((xFreqSel = "001") and (xExtEna = '1')) else '0';

 xFreq_Gen : FreqGen
  generic map(opVal => F_XAxis_Base + F_Ld_Freq,
              opBits => opBits,
              freqBits => freqBits)
  port map (
   clk => clk,
   din => curDin,
   dshift => dshift,
   op => op,
   load => load,
   ena => xFreqGenEna,
   pulseOut => xFreqGen
   );

 dbgFreq_gen : FreqGenCtr
  generic map(opBase => F_Dbg_Freq_Base,
              opBits => opBits,
              freqBits => freqBits,
              countBits=> freqCountBits)
  port map (
   clk => clk,
   din => curDin,
   dshift => dshift,
   op => op,
   load => load,
   ena => clkDbgFreqEna,
   pulseOut => dbgFreqGen
   );

 step_Delay : process(clk)
 begin
  if (rising_edge(clk)) then
   zDelayStep <= zAxisStep;
   xDelayStep <= xAxisStep;
  end if;
 end process;
 
 zCh_Data : DataSelSyn8_1
  port map (
   clk => clk,
   sel => zFreqSel,
   d0 => '0',
   d1 => zFreqGen,
   d2 => ch,
   d3 => intClk,
   d4 => xFreqGen,
   d5 => xCh,
   d6 => '0',
   d7 => dbgFreqGen,
   dout => zCh
   );

 z_Axis : Axis
  generic map (
   opBase => F_ZAxis_Base,
   opBits => opBits,
   synBits => synBits,
   posBits => posBits,
   countBits => countBits,
   distBits => distBits,
   locBits => locBits,
   outBits => outBits,
   dbgBits => dbgBits
   )
  port map (
   clk => clk,
   din => curDin,
   dshift => dshift,
   op => op,
   load => load,
   dshiftR => dshiftR,
   opR => opR,
   copyR => copyR,
   extInit => xExtInit,
   extEna => xExtEna,
   extUpdLoc => xUpdLoc,
   ch => zCh,
   encDir => direction,
   sync => sync,
   dbgOut => zDbg,
   initOut => zExtInit,
   enaOut => zExtEna,
   updLocOut => zUpdLoc,
   dout => zDOut,
   stepOut => zAxisStep,
   dirOut => zAxisDir,
   doneInt => intZDoneInt
   );

 zStep_Pulse: PulseGen
  generic map(pulseWidth => stepWidth)
  port map (
   clk => clk,
   pulseIn => zAxisStep,
   pulseOut => zStep
   );

 zDir <= zAxisDir xor cfgZDir;
 
 xCh_Data : DataSelSyn8_1
  port map (
   clk => clk,
   sel => xFreqSel,
   d0 => '0',
   d1 => xFreqGen,
   d2 => ch,
   d3 => intClk,
   d4 => zFreqGen,
   d5 => zCh,
   d6 => '0',
   d7 => dbgFreqGen,
   dout => xCh);

 x_Axis : Axis
  generic map (
   opBase => F_XAxis_Base,
   opBits => opBits,
   synBits => synBits,
   posBits => posBits,
   countBits => countBits,
   distBits => distBits,
   locBits => locBits,
   outBits => outBits,
   dbgBits => dbgBits
   )
  port map (
   clk => clk,
   din => curDin,
   dshift => dshift,
   op => op,
   load => load,
   dshiftR => dshiftR,
   opR => opR,
   copyR => copyR,
   extInit => zExtInit,
   extEna => zExtEna,
   extUpdLoc => zUpdLoc,
   ch => xCh,
   encDir => direction,
   sync => sync,
   dbgOut => xDbg,
   initOut => xExtInit,
   enaOut => xExtEna,
   updLocOut => xUpdLoc,
   dout => xDOut,
   stepOut => xAxisStep,
   dirOut => xAxisDir,
   doneInt => intXDoneInt
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
