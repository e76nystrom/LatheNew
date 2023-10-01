library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;

use work.ExtDataRec.all;
use work.IORecord.all;

entity LatheTop is
 generic (CLOCK_FREQUENCY   : natural := 50000000;  -- clock frequency of clk_i in Hz
          MEM_INT_IMEM_SIZE : natural := 16*1024;   -- size of processor-internal instruction memory in bytes
          MEM_INT_DMEM_SIZE : natural := 8*1024;    -- size of processor-internal data memory in bytes
          ledPins : positive := 8;
          dbgPins : positive := 8);
 port (
  sysClk   : in std_logic;
  rstn_i   : in std_ulogic;         -- global reset, low-active, async
  
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

  -- aux      : out std_logic_vector(7 downto 0);
  aux      : out std_ulogic_vector(7 downto 0);

  pinOut   : out std_logic_vector(11 downto 0) := (others => '0');
  extOut   : out std_logic_vector(2 downto 0) := (others => '0');
  
  bufOut   : out std_logic_vector(3 downto 0) := (others => '0');

  zDoneInt : out std_logic := '0';
  xDoneInt : out std_logic := '0';

  -- JTAG on-chip debugger interface --
  jtag_trst_i : in  std_ulogic; -- low-active TAP reset (optional)
  jtag_tck_i  : in  std_ulogic; -- serial clock
  jtag_tdi_i  : in  std_ulogic; -- serial data input
  jtag_tdo_o  : out std_ulogic; -- serial data output
  jtag_tms_i  : in  std_ulogic; -- mode select

  -- GPIO --
  -- gpio_o      : out std_ulogic_vector(7 downto 0); -- parallel output
  
  -- UART0 --
  dbg_txd_o : out std_ulogic; -- UART0 send data
  dbg_rxd_i : in  std_ulogic  -- UART0 receive data

  );
end LatheTop;

architecture Behavioral of LatheTop is

 attribute syn_keep : boolean;
 attribute syn_keep of led   : signal is true;
 attribute syn_keep of dbg   : signal is true;
 attribute syn_keep of anode : signal is true;
 attribute syn_keep of seg   : signal is true;

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

 attribute syn_keep of pinIn  : signal is true;
 attribute syn_keep of aux    : signal is true;
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

 signal sysClkOut  : std_logic;

 signal con_gpio_o : std_ulogic_vector(63 downto 0) := (others => '0');

 signal cfs_in_i   : std_ulogic_vector(32-1 downto 0) := (others => '0');
 signal cfs_out_o  : std_ulogic_vector(32-1 downto 0) := (others => '0');

 signal cfs_re_o   : std_ulogic := '0';
 signal cfs_we_o   : std_ulogic := '0';
 signal cfs_reg_o  : std_ulogic_vector(1 downto 0) := (others => '0');

 signal latheData  : ExtDataRcv;
 signal latheCtl   : ExtDataCtl;

begin

 pllClock : entity work.Clock
  port map ( 
   clockIn  => sysClk,
   clockOut => sysClkOut
   ); 

 neorv32_top_inst: entity work.neorv32_top
  generic map (
   -- General --
   CLOCK_FREQUENCY              => 50000000,
   INT_BOOTLOADER_EN            => true,
   -- On-Chip Debugger (OCD) --
   ON_CHIP_DEBUGGER_EN          => true,
   -- RISC-V CPU Extensions --
   CPU_EXTENSION_RISCV_C        => true,
   CPU_EXTENSION_RISCV_M        => true,
   CPU_EXTENSION_RISCV_Zicntr   => true,
   CPU_EXTENSION_RISCV_Zifencei => true,
   -- Internal Instruction memory --
   MEM_INT_IMEM_EN              => true,
   MEM_INT_IMEM_SIZE            => MEM_INT_IMEM_SIZE,
   -- Internal Data memory --
   MEM_INT_DMEM_EN              => true,
   MEM_INT_DMEM_SIZE            => MEM_INT_DMEM_SIZE,
   -- Processor peripherals --
   IO_GPIO_NUM                  => 8,
   IO_MTIME_EN                  => true,
   IO_UART0_EN                  => true
   )
  port map (
   clk_i       => sysClkOut,
   rstn_i      => rstn_i,

   cfs_in_i    => cfs_in_i,
   cfs_out_o   => cfs_out_o,

   cfs_re_o    => cfs_re_o,
   cfs_we_o    => cfs_we_o,
   cfs_reg_o   => cfs_reg_o,
   
   jtag_trst_i => jtag_trst_i,
   jtag_tck_i  => jtag_tck_i,
   jtag_tdi_i  => jtag_tdi_i,
   jtag_tdo_o  => jtag_tdo_o,
   jtag_tms_i  => jtag_tms_i,

   gpio_o      => con_gpio_o,

   uart0_txd_o => dbg_txd_o,
   uart0_rxd_i => dbg_rxd_i
   );

 -- GPIO output --
 aux <= con_gpio_o(7 downto 0); 

 interfaceProc : entity work.CFSInterface
 generic map (lenBits  => 8,
              dataBits => 32)
 port map (
  clk        => sysClkOut,
  re         => cfs_re_o,
  we         => cfs_we_o,
  reg        => cfs_reg_o,
  
  CFSDataIn  => cfs_out_o,
  CFSDataOut => cfs_in_i,

  latheData  => latheData,
  latheCtl   => latheCtl
  );

 latheInt: entity work.LatheInterface
  generic map (ledPins => ledPins,
               dbgPins => dbgPins)
  port map (
   sysClk   => sysClkOut,

   led      => led,
   dbg      => dbg,
   anode    => anode,
   seg      => seg,

   dclk     => dclk,
   dout     => dout,
   din      => din,
   dsel     => dsel,

   aIn      => aIn,
   bIn      => bIn,
   syncIn   => syncIn,

   zDro     => zDro,
   xDro     => xDro,
   zMpg     => zMpg,

   xMpg     => xMpg,

   pinIn    => pinIn,

   -- aux      => aux,
   pinOut   => pinOut,
   extOut   => extOut,

   bufOut   => bufOut,

   latheData => latheData,
   latheCtl  => latheCtl,

   zDoneInt => zDoneInt,
   xDoneInt => xDoneInt
   );

end Behavioral;