library ieee;
use ieee.std_logic_1164.all;
 
package ExtSignal is

 constant ledPins : positive := 8;
 constant dbgPins : positive := 8;

 type DbgOut is record
  led   : std_logic_vector(ledPins-1 downto 0);
  dbg   : std_logic_vector(dbgPins-1 downto 0);
  anode : std_logic_vector(3 downto 0);
  seg   : std_logic_vector(6 downto 0);
 end record DbgOut;

 type InputData is record
  aIn    : std_logic;
  bIn    : std_logic;
  syncIn : std_logic;
  zDro   : std_logic_vector(1 downto 0);
  xDro   : std_logic_vector(1 downto 0);
  zMpg   : std_logic_vector(1 downto 0);
  xMpg   : std_logic_vector(1 downto 0);
  pinIn  : std_logic_vector(4 downto 0);
 end record InputData;

 type OutputData is record
  aux      : std_logic_vector(7 downto 0);
  pinOut   : std_logic_vector(11 downto 0);
  extOut   : std_logic_vector(2 downto 0);
  bufOut   : std_logic_vector(3 downto 0);
  zDoneInt : std_logic;
  xDoneInt : std_logic;
 end record OutputData;

end package ExtSignal;
