library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

use work.RegDef.opb;

package ExtDataRec is

 type ExtDataCtl is record
  op     : unsigned(opb-1 downto 0);    --register number
  active : std_logic;
  shift  : std_logic;                   --shift data
  copy   : std_logic;                   --copy input data
  load   : std_logic;                   --load output data
  dSnd   : std_logic;                   --output data
 end record ExtDataCtl;

 constant extDataCtlInit : ExtDataCtl := (op     => (others => '0'),
                                          active => '0',
                                          shift  => '0',
                                          copy   => '0',
                                          load   => '0',
                                          dSnd   => '0');

 constant extDataCtlLen : positive := 13;

 type ExtDataRcv is record
  data  : std_logic;
 end record ExtDataRcv;

 constant extDataRcvInit : ExtDataRcv := (data => '0');

 function extDataToVec(val : extDataCtl)
  return std_logic_vector;
 
end ExtDataRec;

package body ExtDataRec is

 function extDataToVec(val : extDataCtl) return std_logic_vector is
  variable rtnVec : std_logic_vector(extDataCtlLen-1 downto 0);
 begin
  rtnVec := val.active & val.shift & val.copy & val.load & val.dSnd &
            std_logic_vector(val.op);
  return rtnVec;
 end function;

end package body ExtDataRec;

