library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

use work.regDef.all;
use work.IORecord.all;
use work.DbgRecord.all;
use work.RiscvDataRec.all;
use work.conversion.all;
use work.FpgaLatheBitsRec.all;
use work.FpgaLatheBitsFunc.all;

entity LatheInterface is
 generic (
  dbgPins        : positive := 8;
  inputPins      : positive := 13;
  outputPins     : positive := 12;
  ledPins        : positive := 2;
  bufPins        : positive := 4;
  extPins        : positive := 4;
  synBits        : positive;
  posBits        : positive;
  countBits      : positive;
  distBits       : positive;
  locBits        : positive;
  dbgBits        : positive;
  synDbgBits     : positive;
  rdAddrBits     : positive;
  outBits        : positive;
  opBits         : positive;
  addrBits       : positive;
  seqBits        : positive;
  phaseBits      : positive;
  totalBits      : positive;
  indexClockBits : positive;
  encScaleBits   : positive;
  encCountBits   : positive;
  freqBits       : positive;
  freqCountBits  : positive;
  cycleLenBits   : positive;
  encClkBits     : positive;
  cycleClkBits   : positive;
  pwmBits        : positive;
  stepWidth      : positive;
  ilaDbg         : natural := 0
  );
 port (
  sysClk   : in std_logic;

  led      : out std_logic_vector(ledPins-1 downto 0) := (others => '0');
  anode    : out std_logic_vector(3 downto 0) := (others => '1');
  seg      : out std_logic_vector(6 downto 0) := (others => '1');

  dclk     : in  std_logic;
  dout     : out LatheInterfaceData;
  din      : in std_logic;
  dsel     : in std_logic;

  aIn      : in std_logic;
  bIn      : in std_logic;
  syncIn   : in std_logic;

  zDro     : in std_logic_vector(1 downto 0);
  xDro     : in std_logic_vector(1 downto 0);
  -- zMpg     : in std_logic_vector(1 downto 0);
  -- xMpg     : in std_logic_vector(1 downto 0);

  pinIn    : in std_logic_vector(inputPins-1 downto 0);

  dbg      : out InterfaceDbg;
  -- aux      : out std_logic_vector(7 downto 0);
  pinOut   : out std_logic_vector(outputPins-1 downto 0) := (others => '0');
  extOut   : out std_logic_vector(extPins-1 downto 0) := (others => '0');
  bufOut   : out std_logic_vector(bufPins-1 downto 0) := (others => '0');

  riscvCtl : in  RiscvDataCtl;

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
 -- signal spiLoad   : std_logic := '0';
 -- signal spiActive : std_logic := '0';

 signal dinW : std_logic := '0';

 signal spiW   : DataInp := dataInpInit;
 signal extW   : DataInp := dataInpInit;
 signal curW   : DataInp := dataInpInit;

 signal spiR   : DataOut := dataOutInit;
 signal extR   : DataOut := dataOutInit;
 signal curR   : DataOut := dataOutInit;

 constant displayBits : positive := 16;
 signal dspData  : std_logic_vector (displayBits-1 downto 0) := (others => '0');

 signal statusR   : statusRec := statusToRec(statusZero);
 signal statusRL  : statusRec := statusToRec(statusZero);
 signal statusReg : unsigned(statusSize-1 downto 0);

 signal zDone : std_logic;
 signal xDone : std_logic;

 constant delay : positive := 3;
 signal delayDout  : std_logic_vector(delay-1 downto 0) := (others => '0');

 --component ila_0
 -- port (
 --  clk : in std_logic;
 --  probe0 : in std_logic_vector(0 downto 0);
 --  probe1 : in std_logic_vector(0 downto 0);
 --  probe2 : in std_logic_vector(0 downto 0);
 --  probe3 : in std_logic_vector(0 downto 0);
 --  probe4 : in std_logic_vector(0 downto 0);
 --  probe5 : in std_logic_vector(0 downto 0);
 --  probe6 : in std_logic_vector(6 downto 0)
 --  );
 --end component;

 signal opDbg : std_logic_vector(6 DOWNTO 0);
 signal dOutTemp : std_logic;

 signal dOutRecord : LatheInterfaceData;

begin

 dOutProc1 : entity work.DoutDelay
  port map (
   clk  => sysClk,
   data => dOutRecord,
   dout => dOutTemp
   );

 --ila_dbg : if ilaDbg = 1 generate

 -- opDbg <= std_logic_vector(spiOp(7-1 downto 0));

 -- u_ila : ila_0
 --  port map (
 --   clk => clk,
 --   probe0(0) => dsel,
 --   probe1(0) => dclk,
 --   probe2(0) => din,
 --   probe3(0) => spiShift,
 --   probe4(0) => spiCopy,
 --   probe5(0) => dOutTemp,
 --   probe6    => opDbg
 --   );

 --end generate ila_dbg;

 dout <= dOutRecord;
 dOutRecord.ctl  <= '0';
 dOutRecord.runR <= '0';

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
 -- dspData(7  downto 0) <= spiW.op;

 spiW <= (din => din,    shift => spiShift, op => spiOp);

 extW <= (din => riscvCtl.dSnd, shift => riscvCtl.shift, op => riscvCtl.op);

 curW <= spiW when (riscvCtl.active = '0') else extW;

 spiR  <= (shift => spiShift, op => spiOp, copy => spiCopy);

 extR <= (shift => riscvCtl.shift, op => riscvCtl.op, copy => riscvCtl.copy);

 curR <= spiR   when (riscvCtl.active = '0') else extR;

 spi_int : entity work.SPI
  port map (
   clk       => clk,
   dclk      => dclk,
   dsel      => dsel,

   din       => din,
   shift     => spiShift,
   op        => spiOp,
   -- load      => spiLoad,

   copy      => spiCopy
   -- spiActive => spiActive
   );

 status : entity work.ShiftOutN
  generic map (opVal   => F_Rd_Status,
               n       => statusSize,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => curR,
   data => statusReg,
   dout => dOutRecord.status                  --statusDout
   );

 statusReg <= unsigned(statusToVec(statusR));

 -- runCtl : entity work.CtlReg
 --  generic map (opVal => F_Ld_Run_Ctl,
 --               n     => runSize)
 --  port map (
 --   clk  => clk,
 --   inp  => curW,
 --   data => runReg
 --   );

 -- runR <= runToRec(runReg);

 --  runCtlRd : entity work.ShiftOutN
 --  generic map (opVal   => F_Rd_Run_Ctl,
 --               n       => runSize,
 --               outBits => outBits)
 --  port map (
 --   clk  => clk,
 --   oRec => curR,
 --   data => runRdReg,
 --   dout => dout.runR                    --runRDout
 --   );

 --  runRdReg <= unsigned(runToVec(runR));

 -- ctrlProc : entity work.Controller
 --  generic map (opBase     => F_Ctrl_Base,
 --               addrBits   => addrBits,
 --               statusBits => statusSize,
 --               seqBits    => seqBits,
 --               outBits    => outBits)
 --  port map (
 --   clk       => clk,

 --   init      => runR.runInit,

 --   dInp      => spiW,
 --   copy      => spiCopy,

 --   ena       => runR.runEna,
 --   zDoneInt  => zDone,
 --   xDoneInt  => xDone,

 --   dout      => dout.ctl,               --ctlDout,

 --   ctlDIn    => ctlDin,
 --   ctlShift  => ctlShift,
 --   ctlOp     => ctlOp,
 --   ctlLoad   => ctlLoad,

 --   busy      => statusR.ctlBusy,
 --   notEmpty  => statusR.queNotEmpty
 --   );

 -- dataReader : entity work.Reader
 --  generic map (opBase     => F_Read_Base,
 --               rdAddrBits => rdAddrBits,
 --               outBits    => outBits)
 --  port map (
 --   clk     => clk,
 --   init    => runR.readerInit,
 --   inp     => spiW,
 --   copy    => spiCopy,
 --   copyOut => rdCopy,
 --   opOut   => rdOp,
 --   active  => rdActive
 --   );

 -- dispalyCtlProc : entity work.DisplayCtl
 --  generic map (opVal       => F_Ld_Dsp_Reg,
 --               displayBits => displayBits,
 --               outBits     => outBits)
 --  port map (
 --   clk      => clk,
 --   dsel     => dsel,
 --   inp      => spiW,
 --   dspCopy  => dspCopy,
 --   dspShift => dspShift,
 --   dspOp    => dspOp,
 --   dspreg => dspData
 --   -- dspReg   => open
 --   );

 displayCtlProc : entity work.CtlReg
  generic map (opVal => F_Ld_Dsp_Reg,
               n     => displayBits)
  port map (
   clk  => clk,
   inp  => curW,
   data => dspData
   );

 -- led display

 led_display : entity work.Display
  port map (
   clk    => clk,
   dspReg => unsigned(dspData),
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
  generic map (
   dbgPins        => dbgPins,
   outputPins     => outputPins,
   inputPins      => inputPins,
   extPins        => extPins,
   bufPins        => bufPins,
   synBits        => synBits,
   posBits        => posBits,
   countBits      => countBits,
   distBits       => distBits,
   locBits        => locBits,
   dbgBits        => dbgBits,
   synDbgBits     => synDbgBits,
   rdAddrBits     => rdAddrBits,
   outBits        => outBits,
   opBits         => opBits,
   addrBits       => addrBits,
   seqBits        => seqBits,
   phaseBits      => phaseBits,
   totalBits      => totalBits,
   indexClockBits => indexClockBits,
   encScaleBits   => encScaleBits,
   encCountBits   => encCountBits,
   freqBits       => freqBits,
   freqCountBits  => freqCountBits,
   cycleLenBits   => cycleLenBits,
   encClkBits     => encClkBits,
   cycleClkBits   => cycleClkBits,
   pwmBits        => pwmBits,
   stepWidth      => stepWidth
   )
  port map (
   clk      => clk,

   -- spiW     => spiW,
   curW     => curW,

   dOut     => dOutRecord.latheCtl,     --latheDOut,

   -- spiR     => spiR,
   curR     => curR,

   dbg      => dbg.ctl,

   aIn      => aIn,
   bIn      => bIn,
   syncIn   => syncIn,

   zDro     => zDro,
   xDro     => xDro,
   -- zMpg     => zMpg,
   -- xMpg     => xMpg,

   pinIn    => pinIn,

   -- aux      => aux,
   pinOut   => pinOut,
   extOut   => extOut,

   bufOut   => bufOut,

   statusR  => statusRL,

   zDoneInt => zDone,
   xDoneInt => xDone
   );

end Behavioral;
