library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.all;
use work.conversion.all;

entity LatheNew is
 generic (ledPins : positive := 8;
          dbgPins : positive := 8);
 port (
  sysClk : in std_logic;
  
  led      : out std_logic_vector(ledPins-1 downto 0) := (others => '0');
  dbg      : out std_logic_vector(dbgPins-1 downto 0) := (others => '0');
  anode    : out std_logic_vector(3 downto 0) := (others => '1');
  seg      : out std_logic_vector(6 downto 0) := (others => '1');

  dclk     : in std_logic;
  dout     : out std_logic := '0';
  din      : in std_logic;
  dsel     : in std_logic;

  aIn      : in std_logic;
  bIn      : in std_logic;
  syncIn   : in std_logic;

  zDro     : in std_logic_vector(1 downto 0);
  xDro     : in std_logic_vector(1 downto 0);
  zMpg     : in std_logic_vector(1 downto 0);
  xMpg     : in std_logic_vector(1 downto 0);

  pinIn    : in std_logic_vector(4 downto 0);

  aux      : out std_logic_vector(7 downto 0);
  pinOut   : out std_logic_vector(11 downto 0) := (others => '0');
  extOut   : out std_logic_vector(2 downto 0) := (others => '0');
  bufOut   : out std_logic_vector(3 downto 0) := (others => '0');

  zDoneInt : out std_logic := '0';
  xDoneInt : out std_logic := '0'
  
  );
end LatheNew;

architecture Behavioral of LatheNew is

component SystemClk is
 port (
  inclk  : in  std_logic := 'X'; -- inclk
  outclk : out std_logic         -- outclk
  );
end component SystemClk;

 constant divBits : integer := 26;
 signal div : unsigned (divBits downto 0) := (others => '0');
 alias digSel: unsigned(1 downto 0) is div(19 downto 18);
 -- alias digSel: unsigned(1 downto 0) is div(8 downto 7);

 constant synBits       : positive := 32;
 constant posBits       : positive := 24;
 constant countBits     : positive := 18;
 constant distBits      : positive := 18;
 constant locBits       : positive := 18;

 constant dbgBits       : positive := 4;
 constant synDbgBits    : positive := 4;

 constant rdAddrBits    : positive := 5;
 constant outBits       : positive := 32;
 
 constant opBits        : positive := 8;
 constant addrBits      : positive := 8;
 constant seqBits       : positive := 8;

 constant phaseBits     : positive := 16;
 constant totalBits     : positive := 32;

 constant idxClkBits    : positive := 28;
 -- constant idxClkBits : positive := 16; 

 constant freqBits      : positive := 16;
 constant freqCountBits : positive := 32;

 constant cycleLenBits  : positive := 11;
 constant encClkBits    : positive := 24;
 constant cycleClkBits  : positive := 32;

 constant pwmBits       : positive := 16;

 constant stepWidth     : positive :=  25;

 -- status register

 constant statusSize : integer := 11;
 signal statusReg : unsigned(statusSize-1 downto 0);
 alias zAxisEna     : std_logic is statusreg(0); -- x01 z axis enable flag
 alias zAxisDone    : std_logic is statusreg(1); -- x02 z axis done
 alias zAxisCurDir  : std_logic is statusreg(2); -- x04 z axis current dir
 alias xAxisEna     : std_logic is statusreg(3); -- x10 x axis enable flag
 alias xAxisDone    : std_logic is statusreg(4); -- x08 x axis done
 alias xAxisCurDir  : std_logic is statusreg(5); -- x20 x axis current dir
 alias stEStop      : std_logic is statusreg(6); -- x40 emergency stop
 alias spindleActive : std_logic is statusreg(7); -- x80 x axis current dir
 alias queNotEmpty  : std_logic is statusreg(8); -- x100 ctl queue not empty
 alias ctlBusy      : std_logic is statusreg(9); -- x200 controller busy
 alias syncActive   : std_logic is statusreg(10); -- x400 sync active

 -- inputs register

 constant inputsSize : integer := 13;
 signal inputsReg : unsigned(inputsSize-1 downto 0);
 alias inZHome      : std_logic is inputsreg(0); -- x01 z home switch
 alias inZMinus     : std_logic is inputsreg(1); -- x02 z limit minus
 alias inZPlus      : std_logic is inputsreg(2); -- x04 z Limit Plus
 alias inXHome      : std_logic is inputsreg(3); -- x08 x home switch
 alias inXMinus     : std_logic is inputsreg(4); -- x10 x limit minus
 alias inXPlus      : std_logic is inputsreg(5); -- x20 x Limit Plus
 alias inSpare      : std_logic is inputsreg(6); -- x40 spare input
 alias inProbe      : std_logic is inputsreg(7); -- x80 probe input
 alias inPin10      : std_logic is inputsreg(8); -- x100 pin 10
 alias inPin11      : std_logic is inputsreg(9); -- x200 pin 11
 alias inPin12      : std_logic is inputsreg(10); -- x400 pin 12
 alias inPin13      : std_logic is inputsreg(11); -- x800 pin 13
 alias inPin15      : std_logic is inputsreg(12); -- x1000 pin 15

 -- run control register

 constant runSize : integer := 3;
 signal runReg : unsigned(runSize-1 downto 0);
 alias runEna     : std_logic is runreg(0); -- x01 run from controller data
 alias runInit    : std_logic is runreg(1); -- x02 initialize controller
 alias readerInit : std_logic is runreg(2); -- x04 initialize reader

 -- configuration control register

 constant cfgCtlSize : integer := 20;
 signal cfgCtlReg : unsigned(cfgCtlSize-1 downto 0);
 alias cfgZDirInv   : std_logic is cfgCtlreg(0); -- x01 z direction inverted
 alias cfgXDirInv   : std_logic is cfgCtlreg(1); -- x02 x direction inverted
 alias cfgZDroInv   : std_logic is cfgCtlreg(2); -- x04 z dro direction inverted
 alias cfgXDroInv   : std_logic is cfgCtlreg(3); -- x08 x dro direction inverted
 alias cfgZJogInv   : std_logic is cfgCtlreg(4); -- x10 z jog direction inverted
 alias cfgXJogInv   : std_logic is cfgCtlreg(5); -- x20 x jog direction inverted
 alias cfgSpDirInv  : std_logic is cfgCtlreg(6); -- x40 spindle directiion inverted
 alias cfgZHomeInv  : std_logic is cfgCtlreg(7); -- x80 z home inverted
 alias cfgZMinusInv : std_logic is cfgCtlreg(8); -- x100 z minus inverted
 alias cfgZPlusInv  : std_logic is cfgCtlreg(9); -- x200 z plus inverted
 alias cfgXHomeInv  : std_logic is cfgCtlreg(10); -- x400 x home inverted
 alias cfgXMinusInv : std_logic is cfgCtlreg(11); -- x800 x minus inverted
 alias cfgXPlusInv  : std_logic is cfgCtlreg(12); -- x1000 x plus inverted
 alias cfgProbeInv  : std_logic is cfgCtlreg(13); -- x2000 probe inverted
 alias cfgEncDirInv : std_logic is cfgCtlreg(14); -- x4000 invert encoder direction
 alias cfgEStopEna  : std_logic is cfgCtlreg(15); -- x8000 estop enable
 alias cfgEStopInv  : std_logic is cfgCtlreg(16); -- x10000 estop invert
 alias cfgEnaEncDir : std_logic is cfgCtlreg(17); -- x20000 enable encoder direction
 alias cfgGenSync   : std_logic is cfgCtlreg(18); -- x40000 no encoder generate sync pulse
 alias cfgPWMEna    : std_logic is cfgCtlreg(19); -- x80000 pwm enable

 constant c_cfgZDirInv   : integer :=  0; -- x01 z direction inverted
 constant c_cfgXDirInv   : integer :=  1; -- x02 x direction inverted
 constant c_cfgZDroInv   : integer :=  2; -- x04 z dro direction inverted
 constant c_cfgXDroInv   : integer :=  3; -- x08 x dro direction inverted
 constant c_cfgZJogInv   : integer :=  4; -- x10 z jog direction inverted
 constant c_cfgXJogInv   : integer :=  5; -- x20 x jog direction inverted
 constant c_cfgSpDirInv  : integer :=  6; -- x40 spindle directiion inverted
 constant c_cfgZHomeInv  : integer :=  7; -- x80 z home inverted
 constant c_cfgZMinusInv : integer :=  8; -- x100 z minus inverted
 constant c_cfgZPlusInv  : integer :=  9; -- x200 z plus inverted
 constant c_cfgXHomeInv  : integer := 10; -- x400 x home inverted
 constant c_cfgXMinusInv : integer := 11; -- x800 x minus inverted
 constant c_cfgXPlusInv  : integer := 12; -- x1000 x plus inverted
 constant c_cfgProbeInv  : integer := 13; -- x2000 probe inverted
 constant c_cfgEncDirInv : integer := 14; -- x4000 invert encoder direction
 constant c_cfgEStopEna  : integer := 15; -- x8000 estop enable
 constant c_cfgEStopInv  : integer := 16; -- x10000 estop invert
 constant c_cfgEnaEncDir : integer := 17; -- x20000 enable encoder direction
 constant c_cfgGenSync   : integer := 18; -- x40000 no encoder generate sync pulse
 constant c_cfgPWMEna    : integer := 19; -- x80000 pwm enable

 -- clock control register

 constant clkCtlSize : integer := 7;
 signal clkCtlReg : unsigned(clkCtlSize-1 downto 0);
 alias zFreqSel   : unsigned is clkCtlreg(2 downto 0); -- x01 z Frequency select
 alias xFreqSel   : unsigned is clkCtlreg(5 downto 3); -- x08 x Frequency select
 constant clkNone      : unsigned (2 downto 0) := "000"; -- 
 constant clkFreq      : unsigned (2 downto 0) := "001"; -- 
 constant clkCh        : unsigned (2 downto 0) := "010"; -- 
 constant clkIntClk    : unsigned (2 downto 0) := "011"; -- 
 constant clkSlvFreq   : unsigned (2 downto 0) := "100"; -- 
 constant clkSlvCh     : unsigned (2 downto 0) := "101"; -- 
 constant clkSpindle   : unsigned (2 downto 0) := "110"; -- 
 constant clkDbgFreq   : unsigned (2 downto 0) := "111"; -- 

 alias clkDbgFreqEna : std_logic is clkCtlreg(6); -- x40 enable debug frequency

 -- sync control register

 constant synCtlSize : integer := 3;
 signal synCtlReg : unsigned(synCtlSize-1 downto 0);
 alias synPhaseInit : std_logic is synCtlreg(0); -- x01 init phase counter
 alias synEncInit   : std_logic is synCtlreg(1); -- x02 init encoder
 alias synEncEna    : std_logic is synCtlreg(2); -- x04 enable encoder

 -- system clock

 signal clk : std_logic;

 -- quadrature encoder

 signal ch : std_logic;
 signal encDir : std_logic;
 signal direction : std_logic;

 -- spi interface

 signal spiShift : std_logic := '0';
 signal spiOp : unsigned (opBits-1 downto 0) := (others => '0');
 signal spiCopy : std_logic := '0';
 signal spiLoad : std_logic := '0';
 signal spiActive : std_logic := '0';

 signal internalDout : std_logic;
 signal dout0 : std_logic;
 signal dout1 : std_logic;
 signal dout2 : std_logic;

 signal dinW : std_logic := '0';

 signal curDin   : std_logic := '0';    --current din
 signal curShift : std_logic := '0';    --shift data
 signal curOp    : unsigned (opBits-1 downto 0); --operation code
 signal curLoad  : std_logic := '0';    --load to register

 -- signal shiftR : std_logic := '0';     --shift data
 -- signal opR     : unsigned (opBits-1 downto 0); --operation code
 -- signal copyR   : std_logic := '0';     --copy to output register

 -- controller

 signal ctlDin   : std_logic;
 signal ctlShift : std_logic;
 signal ctlOp    : unsigned (opBits-1 downto 0); --operation code
 signal ctlLoad  : std_logic;

 signal spiW  : DataInp := (dIn => '0', shift => '0', op => (others =>'0'), load => '0');
 signal ctlW  : DataInp := (dIn => '0', shift => '0', op => (others =>'0'), load => '0');
 signal curW  : DataInp := (dIn => '0', shift => '0', op => (others =>'0'), load => '0');

 signal spiR  : DataOut := (shift => '0', op => (others => '0'), copy => '0');
 signal curR  : DataOut := (shift => '0', op => (others => '0'), copy => '0');

 -- signal controllerBusy : std_logic;
 -- signal ctlNotEmpty    : std_logic;
 signal ctlDout        : std_logic;

 -- reader

 signal rdActive : std_logic;
 signal rdCopy : std_logic;
 signal rdOp : unsigned (opBits-1 downto 0); --operation code
 
 -- display

 constant displayBits : positive := 16;
 signal dspCopy : std_logic;
 signal dspShift : std_logic;
 signal dspOp : unsigned (opBits-1 downto 0);

 signal dspData : unsigned (displayBits-1 downto 0);

 signal statusDout : std_logic;
 signal inputsDout : std_logic;
 signal phaseDOut : std_logic;
 signal encDOut : std_logic;
 signal zDOut : std_logic;
 signal xDOut : std_logic;
 signal idxClkDout : std_logic;
 
 signal zFreqGen : std_logic;
 signal xFreqGen : std_logic;
 signal dbgFreqGen : std_logic;
 signal spFreqGen : std_logic;

 signal sync : std_logic;

 signal intActive : std_logic;
 signal intClk : std_logic;
 signal xCh : std_logic;
 signal zCh : std_logic;
 signal xInit : std_logic;
 signal zInit : std_logic;

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

 signal test0 : std_logic;
 signal test1 : std_logic;
 signal test2 : std_logic;

 signal zDbg : unsigned(dbgBits-1 downto 0);
 signal xDbg : unsigned(dbgBits-1 downto 0);

 signal zSynDbg : std_logic_vector(synDbgBits-1 downto 0);
 signal xSynDbg : std_logic_vector(synDbgBits-1 downto 0);

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

 signal spEna : std_logic;
 signal spindleDout : std_logic;
 signal spindleStep : std_logic;
 signal spindleDir : std_logic;
 signal spindleStepOUt : std_logic;
 signal spindleDirOut : std_logic;

 signal zSwitches : std_logic_vector(3 downto 0);
 signal xSwitches : std_logic_vector(3 downto 0);

 alias eStopIn : std_logic is pinIn(0);
 alias pwmOut : std_logic is pinOut(10);
 alias chgPump : std_logic is pinOut(11);

 signal lastDsel : std_logic := '0';
 signal chgPumpOut : std_logic := '0';

 signal eStop : std_logic;
 signal pwmEna : std_logic;
 
begin

 eStop <= cfgEStopEna and (eStopIn xor cfgEStopInv);
 stEStop <= eStop;

 pinOut(0) <= zDir;
 pinOut(1) <= zStep;
 pinOut(2) <= xDir;
 pinOut(3) <= xStep;

 pinOut(7 downto 4) <= std_logic_vector(xDbg);

 -- alias digSel: unsigned(1 downto 0) is div(19 downto 18);
 -- pinOut(5 downto 4) <= zMpg;
 -- pinout(7 downto 6) <= xMpg;
 pinOut(9 downto 8) <= zDro;

 -- pinOut(9 downto 4) <= std_logic_vector(div(19 downto 14));

 zSwitches <= std_logic_vector(cfgProbeInv &
                               cfgCtlReg(c_cfgZPlusInv downto c_cfgzHomeInv));
 xSwitches <= std_logic_vector(cfgProbeInv &
                               cfgCtlReg(c_cfgXPlusInv downto c_cfgxHomeInv));

 inputsReg <= unsigned(pinIn) & "00000000";

 bufOut <= pinIn(3 downto 0);
 extOut(0) <= spindleDirOut;
 extOut(1) <= spindleStepOut;
 extOut(2) <= pinIn(4);

 zAxisEna <= zExtEna;
 zDoneInt <= intZDoneInt;
 xAxisEna <= xExtEna;
 xDoneInt <= intXDoneInt;

 zAxisDone <= intZDoneInt;
 xAxisDone <= intXDoneInt;

 syncActive <= intActive;

 ledCfg8 : if ledPins > 2 generate
  led(7) <= div(divBits);
  led(6) <= div(divBits-1);
  led(5) <= div(divBits-2);
  led(4) <= div(divBits-3);
  led(3) <= spiW.op(3);
  led(2) <= clkCtlReg(2);
  led(1) <= clkCtlReg(1);
  led(0) <= clkCtlReg(0);
 end generate ledCfg8;

 ledCfg2 : if ledPins <= 2 generate
  led(1) <= div(divBits);
  led(0) <= div(divBits-1);
 end generate ledCfg2;

 dspData(3 downto 0) <= zDbg;
 dspData(7 downto 4) <= xDbg;
 dspData(15 downto 8) <= spiW.op;

 -- test 0 output pulse

 testOut0 : entity work.PulseGen
  generic map (pulseWidth => 50)
  port map (
   clk => clk,
   pulseIn => xCh,
   PulseOut => test0
   );

-- test 1 output pulse

 testOut1 : entity work.PulseGen
  generic map (pulseWidth => 50)
  port map (
   clk => clk,
   pulseIn => zCh,
   pulseOut => test1
   );

-- test 2 output pulse

 testOut2 : entity work.PulseGen
  generic map (pulseWidth => 50)
  port map (
   clk => clk,
   pulseIn => sync,
   pulseOut => test2
   );

 dbg(0) <= test0;
 dbg(1) <= test1;
 dbg(2) <= test2;

 -- dbg(3) <= intZDoneInt;
 dbg(3) <= intXDoneInt;
 dbg(7 downto 4) <= std_logic_vector(zDbg);

 -- dbgConfig : if dbgPins > 8 generate
 --  dbg(11 downto 8)  <= zSynDbg;
 --  dbg(15 downto 12) <= xSynDbg;
 -- else generate
 aux <= xSynDbg & zSynDbg;
 -- end generate dbgConfig;

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

 -- sys_Clk : Clock
 --  port map (
 --   clockIn => sysClk,
 --   clockOut => clk
 --   );


 -- sys_Clk : SystemClk
 --  port map (
 --   areset => '0',
 --   inclk0 => sysClk,
 --   c0     => clk, 
 --   locked => open
 --   );

 sys_clk : component SystemClk
  port map (
   inclk  => sysclk,                    --  altclkctrl_input.inclk
   outclk => clk                        --  altclkctrl_output.outclk
   );

 -- clk <= sysClk;

 -- clock divider

 clk_div: process(clk)
 begin
  if (rising_edge(clk)) then
   div <= div + 1;
  end if;
 end process;

 direction <= (not cfgEncDirInv) when (cfgEnaEncDir = '0') else
              (encDir xor cfgEncDirInv);

 dout <= internalDout;

 doutProcess : process(clk)
 begin
  if rising_edge(clk) then
   dout0 <= statusDout or inputsDout or ctlDout;
   dout1 <= phaseDout or idxClkDout or EncDout;
   dout2 <= zDOut or xDOut or spindleDout;
   internalDout <= dout0 or dout1 or dout2;
  end if;
 end process;

 curDin   <= ctlDin   when runEna = '1' else din;
 curshift <= ctlShift when runEna = '1' else spiShift;
 curOp    <= ctlOp    when runEna = '1' else spiOp;
 curLoad  <= ctlLoad  when runEna = '1' else spiLoad;
 
 -- readProc : process (spiActive, rdActive,
 --                     spiShift, spiCopy, spiOp,
 --                     rdCopy, rdOp,
 --                     dspShift, dspCopy, dspOp)
 -- begin
 --  if (rdActive = '1') then
 --   shiftR <= spiShift;
 --   opR    <= rdOp;
 --   copyR  <= rdCopy;
 --  elsif (spiActive = '1') then
 --   shiftR <= spiShift;
 --   opR    <= spiOp;
 --   copyR  <= spiCopy;
 --  else
 --   shiftR <= dspShift;
 --   opR    <= dspOp;
 --   copyR  <= dspCopy;
 --  end if;
 -- end process readProc;

 spiW <= (din => din,    shift => spiShift, op => spiOp, load => spiLoad);
 curW <= (din => curDin, shift => curShift, op => curOp, load => curLoad);

 spiR <= (shift => spiShift, op => spiOp, copy => spiCopy);

 -- curR <= (shift => shiftR,  op => OpR,   copy => copyR);
 curR <= (shift => spiShift,  op => rdOp,   copy => rdCopy)
         when (rdActive = '1') else
         (shift => spiShift,  op => spiOp,   copy => spiCopy)
         when (spiActive = '1') else
         (shift => dspShift,  op => dspOp,   copy => dspCopy);
 
 spi_int : entity work.SPI
  port map (
   clk       => clk,
   dclk      => dclk,
   dsel      => dsel,

   din       => din,
   shift     => spiShift,
   op        => spiOp,
   load      => spiLoad,

   copy      => spiCopy,
   spiActive => spiActive
   );

 ctrlProc : entity work.Controller
  generic map (opBase     => F_Ctrl_Base,
               addrBits   => addrBits,
               statusBits => statusSize,
               seqBits    => seqBits,
               outBits    => outBits
               )
  port map (
   clk       => clk,
   -- init => to_boolean(runInit),
   init      => runInit,

   dInp      => spiW,

   -- din       => din,
   -- dshift    => spiShift,
   -- op        => spiOp,
   -- load      => load,

   copy      => spiCopy,

   ena       => runEna,
   statusReg => statusReg,
   dout      => ctlDout,

   ctlDIn    => ctlDin,
   ctlShift  => ctlShift,
   ctlOp     => ctlOp,
   ctlLoad   => ctlLoad,

   busy      => ctlBusy,
   notEmpty  => queNotEmpty
   );

 -- ctlBusy <= '1' when controllerBusy = '1' else '0';

 dataReader : entity work.Reader
  generic map (opBase     => F_Read_Base,
               rdAddrBits => rdAddrBits,
               outBits    => outBits
               )
  port map (
   clk     => clk,
   init    => readerInit,
   inp     => spiW,
--   din     => din,
--   dshift  => spiShift,
--   op      => spiOp,
   copy    => spiCopy,
--   load    => load,
   copyOut => rdCopy,
   opOut   => rdOp,
   active  => rdActive
   );

 dispalyCtlProc : entity work.DisplayCtl
  generic map (opVal => F_Ld_Dsp_Reg,
               displayBits => displayBits,
               outBits => outBits
               )
  port map (
   clk      => clk,
   dsel     => dsel,
   inp      => spiW,
--   din      => din,
--   shift    => spiShift,
--   op       => spiOp,
   dout     => internalDout,
   dspCopy  => dspCopy,
   dspShift => dspShift,
   dspOp    => dspOp,
   -- dspreg => dspData
   dspReg   => open
   );

 -- led display

 led_display : entity work.Display
  port map (
   clk    => clk,
   dspReg => dspData,
   digSel => digSel,
   anode  => anode,
   seg    => seg
   );

 status : entity work.ShiftOutN
  generic map (opVal   => F_Rd_Status,
               n       => statusSize,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => spiR,
   -- dshift => spiShift,
   -- op => spiOp,
   -- copy => spiCopy,
   data => statusReg,
   dout => statusDout
   );

 inputs : entity work.ShiftOutN
  generic map (opVal   => F_Rd_Inputs,
               n       => inputsSize,
               outBits => outBits)
  port map (
   clk => clk,
   oRec => spiR,
   -- dshift => spiShift,
   -- op => spiOp,
   -- copy => spiCopy,
   data => inputsReg,
   dout => inputsDout
   );

 run_reg : entity work.CtlReg
  generic map (opVal => F_Ld_Run_Ctl,
               n =>     runSize)
  port map (
   clk => clk,
   inp => spiW,
   -- din => din,
   -- op => spiOp,
   -- shift => spiShift,
   -- load => spiLoad,
   data => runReg);

 sync_reg : entity work.CtlReg
  generic map (opVal => F_Ld_Sync_Ctl,
               n     => synCtlSize)
  port map (
   clk => clk,
   inp => curW,
   -- din => curDin,
   -- op => op,
   -- shift => dshift,
   -- load => load,
   data => synCtlReg);

 clk_reg : entity work.CtlReg
  generic map (opVal => F_Ld_Clk_Ctl,
               n     => clkCtlSize)
  port map (
   clk  => clk,
   inp => curW,
   -- din => curDin,
   -- op => op,
   -- shift => dshift,
   -- load => load,
   data => clkCtlReg);

 cfg_reg : entity work.CtlReg
  generic map (opVal => F_Ld_Cfg_Ctl,
               n     => cfgCtlSize)
  port map (
   clk  => clk,
   inp => spiW,
   -- din => din,
   -- op => spiOp,
   -- shift => spiShift,
   -- load => spiLoad,
   data => cfgCtlReg);

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
   -- din     => curDin,
   -- dshift  => dshift,
   -- op      => op,
   -- load    => load,

   dout    => encDout,
   oRec    => curR,
   -- dshiftR => dshiftR,
   -- opR     => opR,
   -- copyR   => copyR,

   init    => synEncInit,
   ena     => synEncEna,
   ch      => ch,
   active  => intActive,
   intclk  => intClk
   );

 phase_counter : entity work.PhaseCounter
  generic map (opBase => F_Phase_Base,
               phaseBits => phaseBits,
               totalBits => totalBits,
               outBits => outBits)
  port map (
   clk     => clk,

   inp     => curW,
   -- din     => curDin,
   -- dshift  => dshift,
   -- op      => op,
   -- load    => load,

   dout    => phaseDOut,
   oRec    => curR,
   -- dshiftR => dshiftR,
   -- opR     => opR,
   -- copyR   => copyR,

   init    => synPhaseInit,
   genSync => cfgGenSync,
   ch      => ch,
   sync    => syncIn,
   dir     => direction,
   syncOut => sync);

 index_clocks : entity work.IndexClocks
  generic map (opval   => F_Rd_Idx_Clks,
               n       => idxClkBits,
               outBits => outBits)
  port map (
   clk => clk,

   dout   => idxClkDout,
   oRec   => spiR,
   -- dshift => dshiftR,
   -- op     => opR,
   -- copy   => copyR,

   ch => ch,
   index => sync
   );

 zFreqGenEna <= '1' when ((zFreqSel = clkFreq) and (zExtEna = '1')) else '0';

 zFreq_Gen : entity work.FreqGen
  generic map (opVal    => F_ZAxis_Base + F_Ld_Freq,
               freqBits => freqBits)
  port map (
   clk      => clk,

   inp      => curW,
   -- din      => curDin,
   -- dshift   => dshift,
   -- op       => op,
   -- load     => load,

   ena      => zFreqGenEna,
   pulseOut => zFreqGen
   );

 xFreqGenEna <= '1' when ((xFreqSel = clkFreq) and (xExtEna = '1')) else '0';

 xFreq_Gen : entity work.FreqGen
  generic map (opVal    => F_XAxis_Base + F_Ld_Freq,
               freqBits => freqBits)
  port map (
   clk      => clk,

   inp      => curW,
   -- din      => curDin,
   -- dshift   => dshift,
   -- op       => op,
   -- load     => load,

   ena      => xFreqGenEna,
   pulseOut => xFreqGen
   );

 spFreq_Gen : entity work.FreqGen
  generic map (opVal => F_XAxis_Base + F_Ld_Freq,
               freqBits => freqBits)
  port map (
   clk => clk,

   inp      => curW,
   -- din => curDin,
   -- dshift => dshift,
   -- op => op,
   -- load => load,

   ena => spEna,
   pulseOut => spFreqGen
   );

 dbgFreq_gen : entity work.FreqGenCtr
  generic map (opBase    => F_Dbg_Freq_Base,
               freqBits  => freqBits,
               countBits => freqCountBits)
  port map (
   clk      => clk,

   inp      => curW,
   -- din      => curDin,
   -- dshift   => dshift,
   -- op       => op,
   -- load     => load,

   ena      => clkDbgFreqEna,
   pulseOut => dbgFreqGen
   );

 step_Delay : process(clk)
 begin
  if (rising_edge(clk)) then
   zDelayStep <= zAxisStep;
   xDelayStep <= xAxisStep;
  end if;
 end process;

 zCh_Data : process(clk)
 begin
  if (rising_edge(clk)) then
   case zFreqSel is
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
   -- din        => curDin,
   -- dshift     => dshift,
   -- op         => op,
   -- load       => load,

   oRec       => curR,
   dout       => zDOut,
   -- dshiftR    => dshiftR,
   -- opR        => opR,
   -- copyR      => copyR,

   extInit    => xExtInit,
   extEna     => xExtEna,

   ch         => zCh,
   encDir     => direction,
   sync       => sync,

   droQuad    => zDro,
   droInvert  => cfgZDroInv,
   mpgQuad    => zMpg,
   jogInvert  => cfgZJogInv,

   currentDir => zCurrentDir,
   switches   => zSwitches,
   eStop      => eStop,

   -- dbg        => zDbgRec,
   dbgOut     => zDbg,
   synDbg     => zSynDbg,
   initOut    => zExtInit,
   enaOut     => zExtEna,

   stepOut    => zAxisStep,
   dirOut     => zAxisDir,
   doneInt    => intZDoneInt
   );

 zStep_Pulse : entity work.PulseGen
  generic map (pulseWidth => stepWidth)
  port map (
   clk => clk,
   pulseIn => zDelayStep,
   pulseOut => zStep
   );

 xCh_Data : process(clk)
 begin
  if (rising_edge(clk)) then
   case xFreqSel is
    when clkFreq    => xCh <= xFreqGen;
    when clkCh      => xCh <= ch;
    when clkIntClk  => xCh <= intClk;
    when clkSlvFreq => xCh <= zFreqGen;
    when clkSlvCh   => xCh <= zCh;
    when clkSpindle => xCh <= spFreqGen;
    when clkDbgFreq => xCh <= dbgFreqGen;
    when others => xCh <= '0';
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

   inp        => spiW,
   -- din        => curDin,
   -- dshift     => dshift,
   -- op         => op,
   -- load       => load,

   oRec       => curR,
   -- dshiftR    => dshiftR,
   -- opR        => opR,
   -- copyR      => copyR,

   extInit    => zExtInit,
   extEna     => zExtEna,

   ch         => xCh,
   encDir     => direction,
   sync       => sync,

   droQuad    => xDro,
   droInvert  => cfgXDroInv,
   mpgQuad    => xMpg,
   jogInvert  => cfgXJogInv,

   currentDir => xCurrentDir,
   switches   => xSwitches,
   eStop      => eStop,

   -- dbg        => xDbgRec,
   dbgOut     => xDbg,
   synDbg     => xSynDbg,
   initOut    => xExtInit,
   enaOut     => xExtEna,
   dout       => xDOut,
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

 zAxisCurDir <= zCurrentDir;
 xAxisCurDir <= xCurrentDir;

 chgPump <= chgPumpOut;
 
 dirProcess: process(clk)
 begin
  if (rising_edge(clk)) then
   if (zStep = '1') then
    zCurrentDir <= zAxisDir;
    zDir <= zAxisDir xor cfgZDirInv;
   end if;
   if (xStep = '1') then
    xCurrentDir <= xAxisDir;
    xDir <= xAxisDir xor cfgxDirInv;
   end if;

   if ((dsel = '0') and (lastDsel = '1')) then
    if (spiOp = F_Rd_Status) then
     chgPumpOut <= not chgPumpOut;
     lastDsel <= '0';
    end if;
   else
    lastDsel <= '1';
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

   inp       => spiW,
   oRec      => curR,
   dout      => spindleDout,
   ch        => spFreqGen,
   mpgQuad   => zMpg,
   jogInvert => cfgZJogInv,
   eStop     => eStop,
   spActive  => spEna,
   stepOut   => spindleStep,
   dirOut    => spindleDir
   );

 spindleActive <= spEna;

 spStep_Pulse : entity work.PulseGen
  generic map (pulseWidth => stepWidth)
  port map (
   clk      => clk,
   pulseIn  => spindleStep,
   pulseOut => spindleStepOut
   );

 spindleDirOut <= spindleDir xor cfgSpDirInv;

 pwmEna <= '1' when (eStop = '0') and (cfgPWMEna = '1') else '0';
 
 pwmProc : entity work.PWM
  generic map (opBase => F_PWM_Base,
               n      => pwmBits)
  port map (
   clk    => clk,
   inp    => spiW,
   ena    => pwmEna,
   pwmOut => pwmOut
   );

end Behavioral;
