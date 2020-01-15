library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;

entity Controller is
 generic (opBase : unsigned;
          opBits : positive;
          addrBits : positive := 8
          );
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in std_logic;
  op : in unsigned(opBits-1 downto 0);
  copy : in std_logic;
  load : in std_logic
  );
end Controller;

architecture behavioral of  Controller is

 component ShiftOp is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive);
  port(
   clk : in std_logic;
   din : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   shift : in std_logic;
   data : inout unsigned (n-1 downto 0)
   );
 end Component;

 component CMem IS
  port
   (
    clock : in std_logic := '1';
    data  : in std_logic_vector (7 downto 0);
    rdaddress : in std_logic_vector (7 downto 0);
    wraddress : in std_logic_vector (7 downto 0);
    wren : in std_logic := '0';
    q : out std_logic_vector (7 downto 0)
    );
 end component;

 constant byteBits : positive := 8;

 signal dataReg : unsigned (byteBits-1 downto 0);

 signal rdAddress : std_logic_vector (addrBits-1 donwto 0);
 signal wrAddress : std_logic_vector (addrBits-1 downto 0);

 signal writeEna : std_logic := '0';

 signal outData : std_logic_vector (byteBits-1 downto 0);

begin

  : ShiftOp
  generic map(opVal => opBase,
         opBits => opBits,
         n => byteBits)
  port map(
  clk => clk,
  din => din,
  op => op,
  shift => dshift,
  data => dataReg
  );

  : CMem
   PORT
   (
    clock => clk,
    data => dataReg,
    rdaddress => rdAddress,
    wraddress => wrAddress,
    wren => writeEna,
    q => outData
    )

  


 Proc : process(clk)
 begin
  if (rising_edge(clk)) then
  end if;
 end process Proc;

end behavioral;
