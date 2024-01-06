library ieee;
use ieee.std_logic_1164.all;
 
package DbgRecord is

 constant nSyn : positive := 4;

 type SyncAccelDbg is record
  ena     : std_logic;
  done    : std_logic;
  distCtr : std_logic;
  loc     : std_logic;
 end record SyncAccelDbg;

 -- constant syncAccelDbgInit : SyncAccelDbg := (dbg => (others => '0'));

 constant nAxis : positive := 4;

 type AxisDbg is record
  sync : SyncAccelDbg;
  ctlStart : std_logic;
  axisEna  : std_logic;
  doneDist : std_logic;
  pulseOut : std_logic;
 end record AxisDbg;

 -- constant AxisDbgInit : AxisDbg := (sync => SyncAccelDbgInit,
 --                                    dbg => (others => '0'));

 type EncScaleDbg is record
  cycleDone : std_logic;
  cmpUpd    : std_logic;
  intClk    : std_logic;
 end record EncScaleDbg;

 type ControlDbg is record
  xCh      : std_logic;
  zCh      : std_logic;
  sync     : std_logic;
  dbgFreq  : std_logic;
  xDone    : std_logic;
  zDone    : std_logic;
  z        : AxisDbg;
  x        : AxisDbg;
  encScale : EncScaleDbg;
 end record controlDbg;

 type InterfaceDbg is record
  ctl : ControlDbg;
 end record InterfaceDbg;

end package DbgRecord;
