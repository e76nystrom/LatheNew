library ieee;
use ieee.std_logic_1164.all;

package conversion is

 function to_std_logic(val : boolean)
  return std_logic;

 function to_boolean(val : std_logic)
  return boolean;

 function to_boolean(val : boolean)
  return boolean;

end Conversion;

package body Conversion is

 function to_std_logic(val : boolean)
  return std_logic is
 begin
  if val then
   return '1';
  else
   return '0';
  end if;
 end to_std_logic;

 function to_boolean(val : std_logic)
  return boolean is
 begin
  if (val = '1') then
   return true;
  else
   return false;
  end if;
 end to_boolean;

 function to_boolean(val : boolean)
  return boolean is
 begin
  return val;
 end to_boolean;
  
end package body Conversion;
