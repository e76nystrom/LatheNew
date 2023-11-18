library ieee;
use ieee.std_logic_1164.all;
 
package MpgRecord is

 type MpgQuadRec is record
 zQuad : std_logic_vector(2-1 downto 0);
 xQuad : std_logic_vector(2-1 downto 0);
 end record MpgQuadRec;

end package MpgRecord;
