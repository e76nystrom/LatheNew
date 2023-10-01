library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;

package conversion is

 function to_std_logic(val : boolean)
  return std_logic;

 function to_boolean(val : std_logic)
  return boolean;

 function to_boolean(val : boolean)
  return boolean;

 function to_ulogic(val  : integer;
                    size : integer)
  return std_ulogic_vector;

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
  
 function to_ulogic(val  : integer;
                    size : integer)
  return std_ulogic_vector is
  variable src  : std_logic_vector(size-1 downto 0);
  variable tmp  : std_ulogic_vector(size-1 downto 0);
  variable mask : integer;
 begin
  src := conv_std_logic_vector(val, size);
  for i in 0 to size-1 loop
   tmp(i) := src(i);
  end loop;
   return tmp;
 end to_ulogic;

end package body Conversion;
