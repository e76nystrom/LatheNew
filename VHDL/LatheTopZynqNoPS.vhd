library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;

use neorv32.MpgRecord.all;

use work.IORecord.all;
use work.DbgRecord.all;
use work.RiscvDataRec.all;
use work.FpgaLatheBitsRec.all;
use work.FpgaLatheBitsFunc.all;

entity LatheTopZYNQ is
 generic (
  CLOCK_FREQUENCY   : natural := 50000000;  -- clock frequency of clk_i in Hz
  MEM_INT_IMEM_SIZE : natural := 32*1024;   -- internal instruction memory in bytes
  MEM_INT_DMEM_SIZE : natural := 8*1024;    -- internal data memory in bytes
  outputPins        : positive := 12;
  inputPins         : positive := 5;
  ledPins           : positive := 2;
  dbgPins           : positive := 8;
  bufPins           : positive := 4;
  xOutPins          : positive := 4;
  extPins           : positive := 4
  );
 port (
  sysClk   : in std_logic;
  rstn_i   : in std_logic;         -- global reset, low-active, async

  led      : out std_logic_vector(ledPins-1 downto 0) := (others => '0');
  dbg      : out std_logic_vector(dbgPins-1 downto 0) := (others => '0');
  xOut     : out std_logic_vector(xOutPins-1 downto 0) := (others => '0');
  -- anode    : out std_logic_vector(3 downto 0) := (others => '1');
  -- seg      : out std_logic_vector(6 downto 0) := (others => '1');

  dsel     : in std_logic;
  dclk     : in std_logic;
  din      : in std_logic;

  dout     : out std_logic := '0';

  aIn      : in std_logic;
  bIn      : in std_logic;
  syncIn   : in std_logic;

  zDro     : in std_logic_vector(1 downto 0);
  xDro     : in std_logic_vector(1 downto 0);

  zMpg     : in std_logic_vector(1 downto 0);
  xMpg     : in std_logic_vector(1 downto 0);

  pinOut   : out std_logic_vector(outputPins-1 downto 0) := (others => '0');
  pinIn    : in  std_logic_vector(inputPins-1 downto 0);

  -- aux      : out std_logic_vector(7 downto 0);

  extOut   : out std_logic_vector(extPins-1 downto 0) := (others => '0');
  bufOut   : out std_logic_vector(bufPins-1 downto 0) := (others => '0');

  zDoneInt : out std_logic := '0';
  xDoneInt : out std_logic := '0';

  -- JTAG on-chip debugger interface --
  jtag_trst_i : in  std_logic; -- low-active TAP reset (optional)
  jtag_tck_i  : in  std_logic; -- serial clock
  jtag_tdi_i  : in  std_logic; -- serial data input
  jtag_tdo_o  : out std_logic; -- serial data output
  jtag_tms_i  : in  std_logic; -- mode select

  -- GPIO --
  -- gpio_o      : out std_ulogic_vector(7 downto 0); -- parallel output

  -- UART0 --
  dbg_txd_o : out std_logic; -- UART0 send data
  dbg_rxd_i : in  std_logic; -- UART0 receive data

  -- UART1 --
  rem_txd_o : out std_logic; -- UART1 send data
  rem_rxd_i : in  std_logic -- UART1 receive data

  -- DDR_addr    : inout STD_LOGIC_VECTOR ( 14 downto 0 );
  -- DDR_ba      : inout STD_LOGIC_VECTOR ( 2 downto 0 );
  -- DDR_cas_n   : inout STD_LOGIC;
  -- DDR_ck_n    : inout STD_LOGIC;
  -- DDR_ck_p    : inout STD_LOGIC;
  -- DDR_cke     : inout STD_LOGIC;
  -- DDR_cs_n    : inout STD_LOGIC;
  -- DDR_dm      : inout STD_LOGIC_VECTOR ( 3 downto 0 );
  -- DDR_dq      : inout STD_LOGIC_VECTOR ( 31 downto 0 );
  -- DDR_dqs_n   : inout STD_LOGIC_VECTOR ( 3 downto 0 );
  -- DDR_dqs_p   : inout STD_LOGIC_VECTOR ( 3 downto 0 );
  -- DDR_odt     : inout STD_LOGIC;
  -- DDR_ras_n   : inout STD_LOGIC;
  -- DDR_reset_n : inout STD_LOGIC;
  -- DDR_we_n    : inout STD_LOGIC;

  -- FIXED_IO_ddr_vrn   : inout STD_LOGIC;
  -- FIXED_IO_ddr_vrp   : inout STD_LOGIC;
  -- FIXED_IO_mio       : inout STD_LOGIC_VECTOR ( 53 downto 0 );
  -- FIXED_IO_ps_clk    : inout STD_LOGIC;
  -- FIXED_IO_ps_porb   : inout STD_LOGIC;
  -- FIXED_IO_ps_srstb  : inout STD_LOGIC;

  -- MDIO_PHY_0_mdc     : out   STD_LOGIC;
  -- MDIO_PHY_0_mdio_io : inout STD_LOGIC;

  -- RGMII_0_rd     : in  STD_LOGIC_VECTOR ( 3 downto 0 );
  -- RGMII_0_rx_ctl : in  STD_LOGIC;
  -- RGMII_0_rxc    : in  STD_LOGIC;
  -- RGMII_0_td     : out STD_LOGIC_VECTOR ( 3 downto 0 );
  -- RGMII_0_tx_ctl : out STD_LOGIC;
  -- RGMII_0_txc    : out STD_LOGIC;

  -- UART_0_0_rxd : in  STD_LOGIC;
  -- UART_0_0_txd : out STD_LOGIC

  );
end LatheTopZYNQ;

architecture Behavioral of LatheTopZYNQ is

 -- component ZYNQ_Core_wrapper is
 --  port (
 --   DDR_addr    : inout STD_LOGIC_VECTOR ( 14 downto 0 );
 --   DDR_ba      : inout STD_LOGIC_VECTOR ( 2 downto 0 );
 --   DDR_cas_n   : inout STD_LOGIC;
 --   DDR_ck_n    : inout STD_LOGIC;
 --   DDR_ck_p    : inout STD_LOGIC;
 --   DDR_cke     : inout STD_LOGIC;
 --   DDR_cs_n    : inout STD_LOGIC;
 --   DDR_dm      : inout STD_LOGIC_VECTOR ( 3 downto 0 );
 --   DDR_dq      : inout STD_LOGIC_VECTOR ( 31 downto 0 );
 --   DDR_dqs_n   : inout STD_LOGIC_VECTOR ( 3 downto 0 );
 --   DDR_dqs_p   : inout STD_LOGIC_VECTOR ( 3 downto 0 );
 --   DDR_odt     : inout STD_LOGIC;
 --   DDR_ras_n   : inout STD_LOGIC;
 --   DDR_reset_n : inout STD_LOGIC;
 --   DDR_we_n    : inout STD_LOGIC;

 --   FIXED_IO_ddr_vrn   : inout STD_LOGIC;
 --   FIXED_IO_ddr_vrp   : inout STD_LOGIC;
 --   FIXED_IO_mio       : inout STD_LOGIC_VECTOR ( 53 downto 0 );
 --   FIXED_IO_ps_clk    : inout STD_LOGIC;
 --   FIXED_IO_ps_porb   : inout STD_LOGIC;
 --   FIXED_IO_ps_srstb  : inout STD_LOGIC;

 --   MDIO_PHY_0_mdc     : out   STD_LOGIC;
 --   MDIO_PHY_0_mdio_io : inout STD_LOGIC;

 --   RGMII_0_rd     : in  STD_LOGIC_VECTOR ( 3 downto 0 );
 --   RGMII_0_rx_ctl : in  STD_LOGIC;
 --   RGMII_0_rxc    : in  STD_LOGIC;
 --   RGMII_0_td     : out STD_LOGIC_VECTOR ( 3 downto 0 );
 --   RGMII_0_tx_ctl : out STD_LOGIC;
 --   RGMII_0_txc    : out STD_LOGIC;

 --   UART_0_0_rxd : in  STD_LOGIC;
 --   UART_0_0_txd : out STD_LOGIC
 --   );
 -- end component;

 attribute syn_keep : boolean;
 attribute syn_keep of led   : signal is true;
 attribute syn_keep of dbg   : signal is true;
 -- attribute syn_keep of anode : signal is true;
 -- attribute syn_keep of seg   : signal is true;

 attribute syn_keep of dclk : signal is true;
 attribute syn_keep of dout : signal is true;
 attribute syn_keep of din  : signal is true;
 attribute syn_keep of dsel : signal is true;

 attribute syn_keep of ain    : signal is true;
 attribute syn_keep of bin    : signal is true;
 attribute syn_keep of syncin : signal is true;

 attribute syn_keep of zDro : signal is true;
 attribute syn_keep of xDro : signal is true;
 attribute syn_keep of zMpg : signal is true;
 attribute syn_keep of xMpg : signal is true;

 -- attribute syn_keep of pinIn  : signal is true;
 -- attribute syn_keep of aux    : signal is true;
 attribute syn_keep of pinOut : signal is true;
 attribute syn_keep of extOut : signal is true;
 attribute syn_keep of bufOut : signal is true;

 attribute syn_keep of zDoneInt : signal is true;
 attribute syn_keep of xDoneInt : signal is true;

 attribute syn_keep of jtag_trst_i : signal is true;
 attribute syn_keep of jtag_tck_i  : signal is true;
 attribute syn_keep of jtag_tdo_o  : signal is true;
 attribute syn_keep of jtag_tms_i  : signal is true;
 attribute syn_keep of jtag_tdi_i  : signal is true;

 attribute syn_keep of dbg_txd_o : signal is true;
 attribute syn_keep of dbg_rxd_i : signal is true;

 attribute syn_keep of rem_txd_o : signal is true;
 attribute syn_keep of rem_rxd_i : signal is true;

 signal sysClkOut  : std_logic;

 signal con_gpio_o : std_ulogic_vector(63 downto 0) := (others => '0');

 signal cfs_in_i   : std_ulogic_vector(32-1 downto 0) := (others => '0');
 -- signal cfs_tmp_i  : std_ulogic_vector(32-1 downto 0) := (others => '0');
 signal cfs_out_o  : std_ulogic_vector(32-1 downto 0) := (others => '0');

 signal cfs_we_o   : std_ulogic := '0';
 signal cfs_reg_o  : std_ulogic_vector(2 downto 0) := (others => '0');

 signal spiDClk : std_ulogic;
 signal spiDin  : std_ulogic;
 signal spiCS   : std_uLogic_vector(7 downto 0);

 signal data    : LatheInterfaceData;

 signal latheDClk : std_logic;
 signal latheDin  : std_logic;
 signal latheDSel : std_Logic;

 signal riscvData  : RiscvDataRcv;
 signal riscvCtl   : RiscvDataCtl;

 signal riscVCtlReg : riscVCtlRec := (riscvData => '0',
                                      riscvSPI => '0',
                                      riscvInTest => '0');

 signal debug      : InterfaceDbg;
 signal sink       : std_logic;
 signal riscvDout  : std_logic;

 signal mpgQuad    : MpgQuadRec;

 constant maxInputPins : positive := 13 + 5;

 signal cfs_pins_i : std_ulogic_vector(1 + riscvCtlSize + maxInputPins-1 downto 0);

 signal pinInTest  : std_ulogic_vector(inputPins-1 downto 0) := (others => '0');
 signal pinInLathe : std_logic_vector(inputPins-1 downto 0) := (others => '0');

 signal anode      : std_logic_vector(3 downto 0) := (others => '1');
 signal seg        : std_logic_vector(6 downto 0) := (others => '1');

 signal xOutTemp   : std_ulogic_vector(xOutPins-1 downto 0);

 -- component ila_0
 --  port (
 --   clk : in std_logic;
 --   probe0 : in std_logic_vector(0 downto 0);
 --   probe1 : in std_logic_vector(0 downto 0);
 --   probe2 : in std_logic_vector(0 downto 0);
 --   probe3 : in std_logic_vector(0 downto 0)
 --   );
 -- end component;

 component ila_0
  port (
   clk : in std_logic;
   probe0 : in std_logic_vector(3-1 downto 0);
   probe1 : in std_logic_vector(5-1 downto 0);
   probe2 : in std_logic_vector(5-1 downto 0);
   probe3 : in std_logic_vector(5-1 downto 0);
   probe4 : in std_logic_vector(4-1 downto 0)
   );
 end component;

 signal probe0 : std_logic_vector(2 downto 0);

begin

 pllClock : entity work.Clock
  port map (
   clockIn  => sysClk,
   clockOut => sysClkOut
   );
--  sysClkOut <= sysClk;

 -- t_ila : ila_0
 --  port map (
 --   clk => sysClk,
 --   probe0(0) => dsel,
 --   probe1(0) => din,
 --   probe2(0) => dclk,
 --   probe3(0) => riscvDout
 --   );

 t_ila : ila_0
  port map (
   clk => sysClkOut,
   probe0 => std_logic_vector(riscvCtlToVec(riscvCtlReg)),
   probe1 => pinIn,
   probe2 => std_logic_vector(pinInTest),
   probe3 => pinInLathe,
   probe4 => std_logic_vector(xOutTemp)
   );

 cfs_pins_i(maxInputPins + riscvCtlSize) <= sink;

 cfs_pins_i(riscvCtlSize + maxInputPins - 1 downto maxInputPins) <=
  std_ulogic_vector(riscvCtlToVec(riscvCtlReg));

 genInput0: if MaxInputPins = inputPins generate

   cfs_pins_i(inputPins downto 0) <= std_ulogic_vector(pinInLathe);

 end generate genInput0;

 genInput1: if MaxInputPins > inputPins generate

 cfs_pins_i(maxInputPins-1 downto inputPins) <= (others => '0');
 cfs_pins_i(inputPins-1 downto 0) <= std_ulogic_vector(pinInLathe);

 end generate genInput1;

 mpgQuad.zQuad <= zMpg;
 mpgQuad.xQuad <= xMpg;

 xOut <= std_logic_vector(xOutTemp);

 dbgsetup : entity work.DbgMap
  port map (
   clk   => sysClkOut,
   debug => debug,
   dbg   => dbg,
   sink  => sink
   );

 neorv32_top_inst: entity work.neorv32_top
  generic map (
   -- General --
   CLOCK_FREQUENCY              => CLOCK_FREQUENCY,
   INT_BOOTLOADER_EN            => true,
   -- On-Chip Debugger (OCD) --
   ON_CHIP_DEBUGGER_EN          => true,
   -- RISC-V CPU Extensions --
   CPU_EXTENSION_RISCV_B        => true,
   CPU_EXTENSION_RISCV_C        => true,
   CPU_EXTENSION_RISCV_M        => true,
   CPU_EXTENSION_RISCV_Zicntr   => true,
   -- CPU_EXTENSION_RISCV_Zifencei => true,
   -- Internal Instruction memory --
   MEM_INT_IMEM_EN              => true,
   MEM_INT_IMEM_SIZE            => MEM_INT_IMEM_SIZE,
   -- Internal Data memory --
   MEM_INT_DMEM_EN              => true,
   MEM_INT_DMEM_SIZE            => MEM_INT_DMEM_SIZE,
   IO_CFS_EN                    => true,
   inputPins                    => 1 + riscvCtlSize + maxInputPins,
   testPins                     => inputPins,
   -- Processor peripherals --
   IO_GPIO_NUM                  => 8,
   IO_MTIME_EN                  => true,

   IO_UART0_EN                  => true,
   IO_UART0_RX_FIFO             => 1,
   IO_UART0_TX_FIFO             => 1024,

   IO_UART1_EN                  => true,
   IO_UART1_RX_FIFO             => 128,
   IO_UART1_TX_FIFO             => 128,

   IO_SPI_EN                    => true,
   IO_SPI_FIFO                  => 1
   )
  port map (
   clk_i       => sysClkOut,
   rstn_i      => rstn_i,

   cfs_in_i    => cfs_in_i,
   cfs_out_o   => cfs_out_o,

   cfs_we_o    => cfs_we_o,
   cfs_reg_o   => cfs_reg_o,

   cfs_mpg_i   => mpgQuad,
   cfs_pins_i  => cfs_pins_i,
   cfs_test_pins_o => pinInTest,

   cfs_dbg_o   => xOutTemp,

   jtag_trst_i => jtag_trst_i,
   jtag_tck_i  => jtag_tck_i,
   jtag_tdi_i  => jtag_tdi_i,
   jtag_tdo_o  => jtag_tdo_o,
   jtag_tms_i  => jtag_tms_i,

   -- SPI (available if IO_SPI_EN = true) --

   spi_csn_o => spiCS,      -- chip-select
   spi_clk_o => spiDClk,    -- SPI serial clock
   spi_dat_o => spiDin,     -- controller data out, peripheral data in
   spi_dat_i => riscvDout,  -- controller data in, peripheral data out

   uart0_txd_o => dbg_txd_o,
   uart0_rxd_i => dbg_rxd_i,

   uart1_txd_o => rem_txd_o,
   uart1_rxd_i => rem_rxd_i,

   gpio_o      => con_gpio_o
   );

 -- cfs_in_i(31) <= sink or cfs_tmp_i(31);
 -- cfs_in_i(30 downto 0) <= cfs_tmp_i(30 downto 0);

 -- GPIO output --
 -- aux <= con_gpio_o(7 downto 0);
 -- aux(7) <= riscVCtlReg.riscVData;
 -- aux(6) <= con_gpio_o(0);
 -- aux(5 downto 0) <= std_logic_vector(riscvCtl.op(5 downto 0));

 -- latheCtl.active <= riscVCtlReg.riscvData;

 latheDSel <=  spiCS(0) when riscVCtlReg.riscVSPI = '1' else dsel;
 latheDClk <=  spiDClk  when riscVCtlReg.riscVSPI = '1' else dclk;
 latheDin  <=  spiDin   when riscVCtlReg.riscVSPI = '1' else din;

 dOutProc : entity work.DoutDelay
  port map (
   clk  => sysClkOut,
   data => data,
   dout => riscvDout
   );

 dOut <= riscvDout when ((riscVCtlReg.riscVSPI = '0') and
                         (riscVCtlReg.riscVData = '0')) else '0';
 riscvData.data <= riscvDout when riscVCtlReg.riscVData = '1' else '0';


 interfaceProc : entity work.CFSInterface
 generic map (
  lenBits  => 8,
  dataBits => 32,
  inputPins => inputPins)
 port map (
  clk        => sysClkOut,
  we         => cfs_we_o,
  reg        => cfs_reg_o,

  CFSDataIn  => cfs_out_o,
  CFSDataOut => cfs_in_i,

  riscvCtl   => riscvCtlReg,

  latheData  => riscvData,
  latheCtl   => riscvCtl
  );

 pinInLathe <= pinIn when (riscVCtlReg.riscvInTest = '0') else std_logic_vector(pinInTest);

 latheInt: entity work.LatheInterface
  generic map (
   dbgPins        => dbgPins,
   inputPins      => inputPins,
   outputPins     => outputPins,
   ledPins        => ledPins,
   bufPins        => bufPins,
   extPins        => extPins,
   synBits        => 32,
   posBits        => 24,
   countBits      => 18,
   distBits       => 18,
   locBits        => 18,
   dbgBits        => 4,
   synDbgBits     => 4,
   rdAddrBits     => 5,
   outBits        => 32,
   opBits         => 8,
   addrBits       => 8,
   seqBits        => 8,
   phaseBits      => 16,
   totalBits      => 32,
   indexClockBits => 28,
   encScaleBits   => 12,
   encCountBits   => 16,
   freqBits       => 16,
   freqCountBits  => 32,
   cycleLenBits   => 11,
   encClkBits     => 24,
   cycleClkBits   => 32,
   pwmBits        => 16,
   stepWidth      => 50
   )
  port map (
   sysClk   => sysClkOut,

   led      => led,
   dbg      => debug,
   anode    => anode,
   seg      => seg,

   dsel     => latheDSel,
   dclk     => latheDclk,
   din      => latheDin,
   dout     => data,                    --extDout,

   aIn      => aIn,
   bIn      => bIn,
   syncIn   => syncIn,

   zDro     => zDro,
   xDro     => xDro,
   -- zMpg     => zMpg,
   -- xMpg     => xMpg,

   pinIn    => pinInLathe,

   -- aux      => aux,
   pinOut   => pinOut,
   extOut   => extOut,

   bufOut   => bufOut,

   riscvCtl  => riscvCtl,

   zDoneInt => zDoneInt,
   xDoneInt => xDoneInt
   );

  -- ZYNQ: entity ZYNQ_Core_wrapper
  -- port map (
  --  DDR_addr    => DDR_addr,
  --  DDR_ba      => DDR_ba,
  --  DDR_cas_n   => DDR_cas_n,
  --  DDR_ck_n    => DDR_ck_n,
  --  DDR_ck_p    => DDR_ck_p,
  --  DDR_cke     => DDR_cke,
  --  DDR_cs_n    => DDR_cs_n,
  --  DDR_dm      => DDR_dm,
  --  DDR_dq      => DDR_dq,
  --  DDR_dqs_n   => DDR_dqs_n,
  --  DDR_dqs_p   => DDR_dqs_p,
  --  DDR_odt     => DDR_odt,
  --  DDR_ras_n   => DDR_ras_n,
  --  DDR_reset_n => DDR_reset_n,
  --  DDR_we_n    => DDR_we_n,

  --  FIXED_IO_ddr_vrn   => FIXED_IO_ddr_vrn,
  --  FIXED_IO_ddr_vrp   => FIXED_IO_ddr_vrp,
  --  FIXED_IO_mio       => FIXED_IO_mio,
  --  FIXED_IO_ps_clk    => FIXED_IO_ps_clk,
  --  FIXED_IO_ps_porb   => FIXED_IO_ps_porb,
  --  FIXED_IO_ps_srstb  => FIXED_IO_ps_srstb,

  --  MDIO_PHY_0_mdc     => MDIO_PHY_0_mdc,
  --  MDIO_PHY_0_mdio_io => MDIO_PHY_0_mdio_io,

  --  RGMII_0_rd     => RGMII_0_rd,
  --  RGMII_0_rx_ctl => RGMII_0_rx_ctl,
  --  RGMII_0_rxc    => RGMII_0_rxc,
  --  RGMII_0_td     => RGMII_0_td,
  --  RGMII_0_tx_ctl => RGMII_0_tx_ctl,
  --  RGMII_0_txc    => RGMII_0_txc,

  --  UART_0_0_rxd => UART_0_0_rxd,
  --  UART_0_0_txd => UART_0_0_txd
  --  );

end Behavioral;
