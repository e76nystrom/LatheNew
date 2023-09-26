library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

use work.RegDef.opb;

package ExtDataRec is

 type ExtDataCtl is record
  active : std_logic;
  op     : unsigned(opb-1 downto 0);    --register number
  shift  : std_logic;                   --shift data
  copy   : std_logic;                   --copy input data
  load   : std_logic;                   --load output data
  dSnd   : std_logic;                   --output data
 end record ExtDataCtl;

 constant extDataCtlInit : ExtDataCtl := (active => '0',
                                          op     => (others => '0'),
                                          shift  => '0',
                                          copy   => '0',
                                          load   => '0',
                                          dSnd   => '0');

 type ExtDataRcv is record
  data  : std_logic;
 end record ExtDataRcv;

 constant extDataRcvInit : ExtDataRcv := (data => '0');

end package ExtDataRec;
