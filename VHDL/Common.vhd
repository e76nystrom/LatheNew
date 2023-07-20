library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Common is

 constant jogTypeLen : positive := 2;
                        
 type jog_type is (jogNone, jogCmd, jogMpg, jogDist);

 function jt_to_slv(e : jog_type) return std_logic_vector; 

 function slv_to_jt (s : std_logic_vector(jogTypeLen-1 downto 0))
  return jog_type;

end Common;

package body Common is

 function jt_to_slv(e : jog_type) return std_logic_vector is
 begin
  case e is
   when jogNone => return("00");
   when jogCmd  => return("01");
   when jogMpg  => return("10");
   when jogDist => return("11");
   when others  => null;
  end case;
  return("00");
 end;

 function slv_to_jt(s : std_logic_vector(jogTypeLen-1 downto 0))
  return jog_type is
 begin
  case s is
   when "00"   => return(jogNone);
   when "01"   => return(jogCmd);
   when "10"   => return(jogMpg);
   when "11"   => return(jogDist);
   when others => null;
  end case;
  return(jogNone);
 end;
 
end Common;
