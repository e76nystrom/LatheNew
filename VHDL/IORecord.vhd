library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

use work.RegDef.opb;

package IORecord is

 type DataInp is record
  dIn   : std_logic;
  shift : std_logic;
  op    : unsigned(opb-1 downto 0);
 end record DataInp;

 constant dataInpInit : DataInp := (dIn => '0', shift => '0',
                                    op => (others =>'0'));

 type DataOut is record
  shift : std_logic;
  op    : unsigned(opb-1 downto 0);
  copy  : std_logic;
 end record DataOut;

 constant dataOutInit : DataOut := (shift => '0', op => (others => '0'),
                                    copy => '0');

 type SyncCtlRec is record
  ctlChDirect  : std_logic;
  ctlDroEnd    : std_logic;
  ctlDistMode  : std_logic;
  ctlDir       : std_logic;
  ctlHome      : std_logic;
  ctlHomePol   : std_logic;
  ctlProbe     : std_logic;
  ctlUseLimits : std_logic;
 end record SyncCtlRec;

 type SyncData is record
  dist       : std_logic;
  loc        : std_logic;
  xPos       : std_logic;
  yPos       : std_logic;
  sum        : std_logic;
  accelSum   : std_logic;
  accelCtr   : std_logic;
  accelSteps : std_logic;
  dro        : std_logic;
 end record SyncData;

 type AxisData is record
  status : std_logic;
  ctl    : std_logic;
  sync   : SyncData;
 end record AxisData;

 type SpindleData is record
  xPos       : std_logic;
  yPos       : std_logic;
  sum        : std_logic;
  accelSum   : std_logic;
  accelMax   : std_logic;
 end record SpindleData;

 type EncoderData is record
  cmpTmr : std_logic;
  intTmr : std_logic;
 end record EncoderData;

 type IndexData is record
  index     : std_logic;
  encoder   : std_logic;
  turnCount : std_logic;
 end record IndexData;

 type LatheCtlData is record
  inputs  : std_logic;
  phase   : std_logic;
  index   : indexData;
  encoder : EncoderData;
  z       : AxisData;
  x       : AxisData;
  spindle : SpindleData;
 end record LatheCtlData;
 
 type LatheInterfaceData is record
  ctl      : std_logic;
  runR     : std_logic;
  status   : std_logic;
  latheCtl : LatheCtlData;
 end record LatheInterfaceData;

end package IORecord;
