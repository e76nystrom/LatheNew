library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

use work.regDef.all;
use work.IORecord.all;
use work.ExtDataRec.all;
use work.conversion.all;
use work.FpgaLatheBitsRec.all;
use work.FpgaLatheBitsFunc.all;

entity LatheInterface is
 generic (extData       : natural  := 0;
          ledPins       : positive := 8;
          dbgPins       : positive := 8;
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
          stepWidth     : positive := 25);
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

  latheData : out ExtDataRcv := extDataRcvInit;
  latheCtl  : in  ExtDataCtl;

  zDoneInt : out std_logic := '0';
  xDoneInt : out std_logic := '0'
  );
end LatheInterface;

architecture Behavioral of LatheInterface is

 signal clk : std_logic;

 constant divBits : integer := 26;
 signal div   : unsigned (divBits downto 0) := (others => '0');
 alias digSel : unsigned(1 downto 0) is div(19 downto 18);
 -- alias digSel: unsigned(1 downto 0) is div(8 downto 7);

 -- spi interface

 signal spiShift  : std_logic := '0';
 signal spiOp     : unsigned (opb-1 downto 0) := (others => '0');
 signal spiCopy   : std_logic := '0';
 signal spiLoad   : std_logic := '0';
 signal spiActive : std_logic := '0';

 signal dinW : std_logic := '0';

 -- controller

 signal ctlDin   : std_logic;
 signal ctlShift : std_logic;
 signal ctlOp    : unsigned (opb-1 downto 0); --operation code
 signal ctlLoad  : std_logic;

 signal spiW   : DataInp := dataInpInit;
 signal ctlW   : DataInp := dataInpInit;
 signal extW   : DataInp := dataInpInit;

 signal curW   : DataInp := dataInpInit;

 signal spiR   : DataOut := dataOutInit;
 signal readR  : DataOut := dataOutInit;
 signal extR   : DataOut := dataOutInit;
 signal dspR   : DataOut := dataOutInit;

 signal curR   : DataOut := dataOutInit;

 -- reader

 signal rdActive : std_logic;
 signal rdCopy   : std_logic;
 signal rdOp     : unsigned (opb-1 downto 0); --operation code
 
 -- display

 constant displayBits : positive := 16;
 signal dspCopy  : std_logic;
 signal dspShift : std_logic;
 signal dspOp    : unsigned (opb-1 downto 0) := (others => '0');
 signal dspData  : unsigned (displayBits-1 downto 0) := (others => '0');

 signal statusR   : statusRec := statusToRec(statusZero);
 signal statusRL  : statusRec := statusToRec(statusZero);
 signal statusReg : unsigned(statusSize-1 downto 0);

 signal runReg   : runVec;
 signal runR     : runRec;
 signal runRdReg : unsigned(runSize-1 downto 0);

 signal zDone : std_logic;
 signal xDone : std_logic;

 signal CtlDout    : std_logic;
 signal runRDout   : std_logic;
 signal statusDout : std_logic;
 signal latheDout  : std_logic;
 constant delay : positive := 3;
 signal delayDout  : std_logic_vector(delay-1 downto 0) := (others => '0');

begin

 clk <= sysClk;

 clk_div: process(clk)
 begin
  if (rising_edge(clk)) then
   div <= div + 1;
  end if;
 end process;

 ledCfg8 : if ledPins > 2 generate
  led(7) <= div(divBits);
  led(6) <= div(divBits-1);
  led(5) <= div(divBits-2);
  led(4) <= div(divBits-3);
  led(3) <= spiW.op(3);
  led(2) <= div(divBits-4);
  led(1) <= div(divBits-5);
  led(0) <= div(divBits-6);
 end generate ledCfg8;

 ledCfg2 : if ledPins <= 2 generate
  led(1) <= div(divBits);
  led(0) <= div(divBits-1);
 end generate ledCfg2;

 -- dspData(3 downto 0) <= zDbg;
 -- dspData(7 downto 4) <= xDbg;
 dspData(7  downto 0) <= spiW.op;

 delayProc : process(clk)
 begin
  if (rising_edge(clk)) then
   delayDout <= delayDout(delay-2 downto 0) & (ctlDout or runRDout or statusDout);
  end if;
 end process;

 dOut <= latheDout or delayDout(delay-1);

 extData0 : if extData /= 0 generate
  latheData.data <= delayDout(delay-1) or latheDout;
 end generate extData0;

 spiW <= (din => din,    shift => spiShift, op => spiOp, load => spiLoad);
 ctlW <= (din => ctlDin, shift => ctlShift, op => ctlOp, load => ctlLoad);

 extData1T : if extData /= 0 generate
  extW <= (din => latheCtl.dSnd, shift => latheCtl.shift, op => latheCtl.op,
           load => latheCtl.load);

  curW <= ctlW when (runR.runEna     = '1') else
          extW when (latheCtl.active = '1') else
          spiW;
 end generate extData1T;

 extData1F : if extData = 0 generate
  curW <= ctlW when (runR.runEna = '1') else
          spiW;
 end generate extData1F;

 spiR  <= (shift => spiShift, op => spiOp, copy => spiCopy);
 readR <= (shift => spiShift, op => rdOp,  copy => rdCopy);
 dspR  <= (shift => dspShift, op => dspOp, copy => dspCopy);

 extData2T : if extData /= 0 generate
  extR  <= (shift => latheCtl.shift, op => latheCtl.op, copy => latheCtl.copy);

  curR <= readR  when (rdActive        = '1') else
          extR   when (latheCtl.active = '1') else
          spiR   when (spiActive       = '1') else
          dspR;
 end generate extData2T;
 
 extData2F : if extData = 0 generate
  curR <= readR  when (rdActive  = '1') else
          spiR   when (spiActive = '1') else
          dspR;
 end generate extData2F;

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

 status : entity work.ShiftOutN
  generic map (opVal   => F_Rd_Status,
               n       => statusSize,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => curR,
   data => statusReg,
   dout => statusDout
   );

 statusReg <= unsigned(statusToVec(statusR));

 runCtl : entity work.CtlReg
  generic map (opVal => F_Ld_Run_Ctl,
               n     => runSize)
  port map (
   clk  => clk,
   inp  => extW,
   data => runReg);

 runR <= runToRec(runReg);

  runCtlRd : entity work.ShiftOutN
  generic map(opVal   => F_Rd_Run_Ctl,
              n       => runSize,              
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => extR,
   data => runRdReg,
   dout => runRDout
   );

  runRdReg <= unsigned(runToVec(runR));

 ctrlProc : entity work.Controller
  generic map (opBase     => F_Ctrl_Base,
               addrBits   => addrBits,
               statusBits => statusSize,
               seqBits    => seqBits,
               outBits    => outBits)
  port map (
   clk       => clk,

   init      => runR.runInit,

   dInp      => spiW,
   copy      => spiCopy,

   ena       => runR.runEna,
   zDoneInt  => zDone,
   xDoneInt  => xDone,

   dout      => ctlDout,

   ctlDIn    => ctlDin,
   ctlShift  => ctlShift,
   ctlOp     => ctlOp,
   ctlLoad   => ctlLoad,

   busy      => statusR.ctlBusy,
   notEmpty  => statusR.queNotEmpty
   );

 dataReader : entity work.Reader
  generic map (opBase     => F_Read_Base,
               rdAddrBits => rdAddrBits,
               outBits    => outBits)
  port map (
   clk     => clk,
   init    => runR.readerInit,
   inp     => spiW,
   copy    => spiCopy,
   copyOut => rdCopy,
   opOut   => rdOp,
   active  => rdActive
   );

 dispalyCtlProc : entity work.DisplayCtl
  generic map (opVal       => F_Ld_Dsp_Reg,
               displayBits => displayBits,
               outBits     => outBits)
  port map (
   clk      => clk,
   dsel     => dsel,
   inp      => spiW,
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

 statusR.zAxisCurDir <= statusRL.zAxisCurDir;
 statusR.xAxisCurDir <= statusRL.xAxisCurDir;
 statusR.stEStop     <= statusRL.stEStop;
 statusR.zAxisEna    <= statusRL.zAxisEna;
 statusR.xAxisEna    <= statusRL.xAxisEna;
 statusR.zAxisDone   <= statusRL.zAxisDone;
 statusR.xAxisDone   <= statusRL.xAxisDone;
 statusR.syncActive  <= statusRL.syncActive;

 zDoneInt <= zDone;
 xDoneInt <= xDone;

 latheCtlProc: entity work.LatheCtl
  generic map (dbgPins => dbgPins)
  port map (
   clk      => clk,

   spiW     => spiW,
   curW     => curW,

   dOut     => latheDOut,

   spiR     => spiR,
   curR     => curR,

   dbg      => dbg,

   aIn      => aIn,
   bIn      => bIn,
   syncIn   => syncIn,

   zDro     => zDro,
   xDro     => xDro,
   zMpg     => zMpg,

   xMpg     => xMpg,

   pinIn    => pinIn,

   aux      => aux,
   pinOut   => pinOut,
   extOut   => extOut,

   bufOut   => bufOut,

   statusR  => statusRL,

   zDoneInt => zDone,
   xDoneInt => xDone
   );

end Behavioral;
