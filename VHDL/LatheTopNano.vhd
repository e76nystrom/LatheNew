library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RiscvDataRec.all;
use work.dbgRecord.all;
use work.IORecord.all;

entity LatheTop is
 generic (ledPins   : positive := 8;
          dbgPins   : positive := 8;
          inputPins : positive := 13);
 port (
  sysClk   : in std_logic;
  
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

  pinIn    : in std_logic_vector(inputPins-1 downto 0);

  -- aux      : out std_logic_vector(7 downto 0);
  -- aux      : out std_ulogic_vector(7 downto 0) := (others => '0');

  pinOut   : out std_logic_vector(11 downto 0) := (others => '0');
  extOut   : out std_logic_vector(2 downto 0) := (others => '0');
  
  bufOut   : out std_logic_vector(3 downto 0) := (others => '0');

  zDoneInt : out std_logic := '0';
  xDoneInt : out std_logic := '0'
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
 -- attribute syn_keep of aux    : signal is true;
 attribute syn_keep of pinOut : signal is true;
 attribute syn_keep of extOut : signal is true;
 attribute syn_keep of bufOut : signal is true;

 attribute syn_keep of zDoneInt : signal is true;
 attribute syn_keep of xDoneInt : signal is true;

 signal sysClkOut  : std_logic;

 signal con_gpio_o : std_ulogic_vector(63 downto 0) := (others => '0');

 signal cfs_in_i   : std_ulogic_vector(32-1 downto 0) := (others => '0');
 signal cfs_out_o  : std_ulogic_vector(32-1 downto 0) := (others => '0');

 signal cfs_re_o   : std_ulogic := '0';
 signal cfs_we_o   : std_ulogic := '0';
 signal cfs_reg_o  : std_ulogic_vector(1 downto 0) := (others => '0');

 signal data    : LatheInterfaceData;

 signal latheData  : RiscvDataRcv := riscvDataRcvInit;
 signal latheCtl   : RiscvDataCtl := riscvDataCtlInit;

 signal debug      : InterfaceDbg;
 signal extDout    : std_logic;
  
begin

 dbgsetup : entity work.DbgMap
  port map (
   clk   => sysClkOut,
   debug => debug,
   dbg   => dbg
   );

 pllClock : entity work.Clock
  port map ( 
   clockIn  => sysClk,
   clockOut => sysClkOut
   ); 

 dOutProc : entity work.DoutDelay
  port map (
   clk  => sysClkOut,
   data => data,
   dout => extDout
   );

 dOut <= extDout;
 
-- interfaceProc : entity work.CFSInterface
 -- generic map (lenBits  => 8,
 --              dataBits => 32)
 -- port map (
 --  clk        => sysClkOut,
 --  re         => cfs_re_o,
 --  we         => cfs_we_o,
 --  reg        => cfs_reg_o,
  
 --  CFSDataIn  => cfs_out_o,
 --  CFSDataOut => cfs_in_i,

 --  latheData  => latheData,
 --  latheCtl   => latheCtl
 --  );

 latheInt: entity work.LatheInterface
  generic map (ledPins => ledPins,
               dbgPins => dbgPins)
  port map (
   sysClk   => sysClkOut,

   led      => led,
   anode    => anode,
   seg      => seg,

   dclk     => dclk,
   dout     => data,
   din      => din,
   dsel     => dsel,

   aIn      => aIn,
   bIn      => bIn,
   syncIn   => syncIn,

   zDro     => zDro,
   xDro     => xDro,
   -- zmpg     => zMpg,
   -- xMpg     => xMpg,

   pinIn    => pinIn,

   dbg      => debug,
   -- aux      => aux,
   pinOut   => pinOut,
   extOut   => extOut,

   bufOut   => bufOut,

   riscvCtl  => latheCtl,

   zDoneInt => zDoneInt,
   xDoneInt => xDoneInt
   );

end Behavioral;
