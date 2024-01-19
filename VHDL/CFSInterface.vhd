library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith;

use work.RegDef.all;
use work.IORecord.all;
use work.RiscvDataRec.all;
use work.FpgaLatheBitsRec.all;
use work.FpgaLatheBitsFunc.all;

entity CFSInterface is
 generic (lenBits   : positive := 8;
          dataBits  : positive := 32;
          inputPins : positive := 13);
 port (
  clk     : in std_logic;               --clock
  we      : in std_ulogic;              --write request
  reg     : in std_ulogic_vector(2 downto 0); --register number

  CFSdataIn  : in  std_ulogic_vector(31 downto 0); --cfs data in
  CFSdataOut : out std_ulogic_vector(31 downto 0) :=  (others => '0'); --cfs data out

  riscVCtl   : out riscVCtlRec;

  latheData  : in  RiscvDataRcv;          --incoming read data
  latheCtl   : out RiscvDataCtl := riscvDataCtlInit; --outgoing control and data
  pinIn      : out std_logic_vector(inputPins-1 downto 0) := (others => '0')
  );
end CFSInterface;

architecture Behavorial of CFSInterface is

 type sendFSM is (sIdle, sSend, SLoad);
 signal sendState : sendFSM := sIdle;

 type recvFSM is (rIdle, rCopy, rRecv);
 signal recvState : recvFSM := rIdle;

 signal sCount  : unsigned(lenBits-1 downto 0) := (others => '0');
 signal rCount  : unsigned(lenBits-1 downto 0) := (others => '0');

 signal shiftOut : std_logic_vector(dataBits-1 downto 0) := (others => '0');
 signal shiftIn  : std_logic_vector(dataBits-1 downto 0) := (others => '0');
 signal dataIn   : std_logic_vector(dataBits-1 downto 0) := (others => '0');

 signal send    : std_logic := '0';
 signal recv    : std_logic := '0';

 signal riscVCtlR : riscvCtlRec := riscVCtlToRec(riscVCtlZero);

 -- constant divRange : integer := 50-1;--50000-1;

 -- signal divider : integer range 0 to divRange := divRange;
 -- signal millis  : unsigned(32-1 downto 0) := (others => '0');

begin

 -- divProcess : process(clk)
 -- begin
 --  if (rising_edge(clk)) then            --if clock active
 --   if (divider = 0) then
 --    divider <= divRange;
 --    millis <= millis + 1;
 --   else
 --    divider <= divider - 1;
 --   end if;
 --  end if;
 -- end process;

 latheCtl.dSnd <= shiftOut(dataBits-1);
 CFSDataOut <= std_ulogic_vector(dataIn);

 -- CFSDataOut <= std_ulogic_vector(dataIn) when reg(2) = '0' else
 --               std_ulogic_vector(millis);


 riscVCtl <= riscVCtlR;
 latheCtl.active <= riscVCtlR.riscvData;

 data: process(clk)
  begin
  if (rising_edge(clk)) then            --if clock active
   if (we = '1') then                   --if write
    case reg  is                        --select operatin
     when "001" =>
      riscVCtlR <= riscVCtlToRecS(
       std_logic_vector(cfsDataIn(riscVCtlSize-1 downto 0)));

     when "010" =>                       --if data out
      shiftOut <= std_logic_vector(CFSDataIn); --load data out register

     when "011" =>                       --if load op register
      latheCtl.op <= unsigned(CFSDataIn(opb-1 downto 0)); --set op register
      if (CFSDataIn(opb) = '0') then
       send <= '1';
      else
       recv <= '1';
      end if;

     when "111" =>
      pinIn <= std_logic_vector(CFSDataIn(inputPins-1 downto 0));

     when others => null;
    end case;
   end if;

   case sendState is
    when sIdle =>                       --idle
     if (send = '1') then
      sCount <= to_unsigned(dataBits-1, lenBits);
      latheCtl.shift <= '1';
      sendState <= sSend;
     end if;

    when sSend =>                       --send data
     if (sCount /= 0) then
      sCount <= sCount - 1;
      shiftOut <= shiftOut(dataBits-2 downto 0) & shiftOut(databits-1);
     else
      latheCtl.shift <= '0';
      -- latheCtl.load <= '1';
      sendState <= sLoad;
     end if;

    when sLoad =>                       --load data
     -- latheCtl.load <= '0';
     send <= '0';
     latheCtl.op <= (others => '0');
     sendState <= sIdle;

    when others =>
     sendState <= sIdle;
   end case;

   case recvState is
    when rIdle =>
     if (recv = '1') then
      latheCtl.copy <= '1';
      shiftIn <= (others => '0');
      recvState <= rCopy;
     end if;

    when rCopy =>
     latheCtl.copy <= '0';
     rCount <= to_unsigned(dataBits-1, lenBits) + 4;
     latheCtl.shift <= '1';
     recvState <= rRecv;

    when rRecv =>
     if (rCount <= 4) then
      latheCtl.shift <= '0';
     end if;

     if (rCount /= 0) then
      rCount <= rCount - 1;
      shiftIn <= shiftIn(dataBits-2 downto 0) & latheData.data;
     else
      dataIn <= shiftIn;
      recv <= '0';
      latheCtl.op <= (others => '0');
      recvState <= rIdle;
     end if;
   end case;

  end if;
 end process;

end Behavorial;
