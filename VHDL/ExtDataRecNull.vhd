library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

use work.RegDef.opb;

package ExtDataRec is

 type ExtDataCtl is record
  x : std_logic_vector (0 downto 0);
 end record;

 constant extDataCtlInit : ExtDataCtl := (x => (others => '0'));

 type ExtDataRcv is record
  x : std_logic_vector (0 downto 0);
 end record;

 constant extDataRcvInit : ExtDataRcv := (x => (others => '0'));

end package ExtDataRec;
