library ieee;
use ieee.std_logic_1164.all;
 
package DbgRecord is

 constant nSyn : positive := 4;

 type SyncAccelDbg is record
  dbg : std_logic_vector(nSyn-1 downto 0);
 end record SyncAccelDbg;

 constant syncAccelDbgInit : SyncAccelDbg := (dbg => (others => '0'));

 constant nAxis : positive := 1;

 type AxisDbg is record
  sync : SyncAccelDbg;
  dbg  : std_logic_vector(nAxis-1 downto 0);
 end record AxisDbg;

 constant AxisDbgInit : AxisDbg := (sync => SyncAccelDbgInit,
                                    dbg => (others => '0'));

end package DbgRecord;
