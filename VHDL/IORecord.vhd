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

 type DataOut is record
  shift : std_logic;
  op    : unsigned(opb-1 downto 0);
  copy  : std_logic;
 end record DataOut;

 type ExtData is record
  op    : unsigned(opb-1 downto 0);  --register number
  shift : std_logic;                    --shift data
  copy  : std_logic;                    --copy input data
  load  : std_logic;                    --load output data
  dSnd  : std_logic;                    --output data
 end record ExtData;

end package IORecord;
