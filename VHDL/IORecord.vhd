library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

use work.RegDef.opb;

package IORecord is

 type DataInp is record
  dIn   : std_logic;
  shift : std_logic;
  op    : unsigned(opb-1 downto 0);
  load  : std_logic;
 end record DataInp;

 constant dataInpInit : DataInp := (dIn => '0', shift => '0', op => (others =>'0'), load => '0');

 type DataOut is record
  shift : std_logic;
  op    : unsigned(opb-1 downto 0);
  copy  : std_logic;
 end record DataOut;

 constant dataOutInit : DataOut := (shift => '0', op => (others => '0'), copy => '0');

end package IORecord;
