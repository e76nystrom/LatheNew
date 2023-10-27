-- Create Date: 09/27/2023 04:00:50 AM

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;
--use ieee.std_logic_arith.conv_std_logic_vector;

use work.SimProc.all;
use work.RegDef.all;
use work.Conversion.all;
use work.IORecord.all;
use work.RiscvDataRec.all;

entity A_InterfaceTest is
end A_InterfaceTest;

architecture Behavioral of A_InterfaceTest is
 
 signal sysClk : std_logic := '0';

 -- signal reset   : std_logic := '0';
 signal we      : std_ulogic := '0'; 
 signal reg     : std_ulogic_vector(2 downto 0) := (others => '0');

 signal cfsDataIn  : std_ulogic_vector(31 downto 0) := (others => '0');
 signal cfsDataOut : std_ulogic_vector(31 downto 0) := (others => '0');

 signal latheData  : RiscvDataRcv := riscvDataRcvInit;
 signal latheCtl   : RiscvDataCtl := riscvDataCtlInit;

 constant datalen : positive := 32;
 signal testReg   : std_logic_vector(dataLen-1 downto 0) := (others => '0');

 constant regOp0 : unsigned(opb-1 downto 0) := x"03";
 constant regOp1 : unsigned(opb-1 downto 0) := x"04";

 signal intW : dataInp := dataInpInit;
 signal intR : dataOut := dataOutInit;

begin

 Interface : entity work.CFSInterface
  port map (
   clk     => sysClk,
   -- reset   => reset,
   we      => we,
   reg     => reg,

   CFSdataIn  => cfsDataIn,
   CFSdataOut => cfsDataOut,

   latheData  => latheData,
   latheCtl   => latheCtl
   );

 intW <= (dIn => latheCtl.dSnd, shift => latheCtl.shift, op => latheCtl.op,
         load => latheCtl.load);

 intR <= (shift => latheCtl.shift, op => latheCtl.op, copy => latheCtl.copy);

  regX : entity work.CtlReg
  generic map (opVal => regOp0,
               n     => dataLen)
  port map (
   clk  => sysClk,
   inp  => intW,
   data => testReg
   );

  regY : entity work.ShiftOutN
  generic map(opVal   => regOp1,
              n       => dataLen,
              outBits => dataLen)
  port map (
   clk    => sysClk,
   oRec   => intR,
   data   => unsigned(testReg),
   dout   => latheData.data
   );

 -- Clock process definitions

 clkProcess : process
 begin
  sysClk <= '0';
  wait for clk_period/2;
  sysClk <= '1';
  wait for clk_period/2;
 end process;

 -- Stimulus process

 stimProc : process
 
  procedure delay(constant n : in integer) is
  begin
   for i in 0 to n-1 loop
    wait until (sysClk = '1');
    wait until (sysClk = '0');
   end loop;
  end procedure delay;

  procedure xWrite(variable regVal : in std_logic_vector(1 downto 0);
                   variable data   : in integer) is
  begin
   reg <= std_ulogic_vector(regVal);
   we  <= '1'; 
   cfsDataIn <= to_ulogic(data, cfsDataOut'length);
   delay(2);
   reg <= "00";
   we  <= '0';
   delay(40);
  end procedure xWrite;

  -- procedure xRead(variable regVal : in std_logic_vector(1 downto 0);
  --                 constant bits : in natural) is
  --  variable tmp : unsigned(bits-1 downto 0);
  -- begin
  --  tmp := (others => '0');
  --  reg <= std_ulogic_vector(regVal);
  --  re  <= '1'; 
  --  delay(2);
  --  for i in 0 to bits-1 loop
  --   tmp := tmp(bits-2 downto 0) & latheData.data;
  --   delay(1);
  --  end loop;
  --  report "xRead " & integer'image(to_integer(tmp));   
  -- end procedure xRead;

  function hexToString(val : std_logic_vector;
                       n   : integer) return string is
   variable inp    : std_logic_vector(32-1 downto 0) := (others => '0');
   variable rtnVal : string(1 to 8);
   variable txt    : character;
   variable index  : integer range 0 to 32;
   variable i      : integer range 0 to 8;
   variable tmp    : std_logic_vector(3 downto 0);
  begin
   inp(n-1 downto 0) := val;
   index := 0;
   i := 0;
   while index < n loop
    tmp := val(index+3 downto index);
    case tmp is
     when "0000" => txt := '0';
     when "0001" => txt := '1';
     when "0010" => txt := '2';
     when "0011" => txt := '3';
     when "0100" => txt := '4';
     when "0101" => txt := '5';
     when "0110" => txt := '6';
     when "0111" => txt := '7';
     when "1000" => txt := '8';
     when "1001" => txt := '9';
     when "1010" => txt := 'a';
     when "1011" => txt := 'b';
     when "1100" => txt := 'c';
     when "1101" => txt := 'd';
     when "1110" => txt := 'e';
     when "1111" => txt := 'f';
     when others => txt := 'x';
    end case;
    rtnVal(i+1) := txt;
    i := i + 1;
    index := index + 4;
   end loop;
   return rtnVal;
  end function;
  
  variable tmp : std_logic_vector(31 downto 0);
  variable tmp1 : std_logic_vector(RiscvDataCtlLen-1 downto 0);

  variable r : std_logic_vector(1 downto 0);
  variable d : integer;

  variable l :line;

 begin
  
-- hold reset state for 100 ns.

  wait for 100 ns;

  -- delay(10);
  -- reset <= '1';
  -- delay(5);
  -- reset <= '0';
  -- delay(5);

  -- insert stimulus here

  r := "01";                            --make active
  d := 1;
  xWrite(r, d);

  r := "10";                            --write data
  d := 16#4000000f#;
  xWrite(r, d);

  r := "11";                            --write op
  d := to_integer("0" & regOp0);
  xWrite(r, d);

  r := "11";                            --read op
  d := to_integer("1" & regOp1);
  xWrite(r, d);
  
  report "cfsDataOut 0x" & hexToString(std_logic_vector(cfsDataOut), cfsDataOut'length);

  -- tmp1 := riscvDataToVec(latheCtl);
  -- report "latheCtl" & integer'image(to_integer(unsigned(tmp1)));
  delay(1000);
  wait;
 end process;

end Behavioral;
