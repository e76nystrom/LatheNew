library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith;

use work.RegDef.all;
use work.IORecord.all;
use work.ExtDataRec.all;

entity CFSInterface is
 generic (lenBits  : positive := 8;
          dataBits : positive := 32);
 port (
  clk     : in std_logic;               --clock
  re      : in std_ulogic;              --read request
  we      : in std_ulogic;              --write request
  reg     : in std_ulogic_vector(1 downto 0); --register number

  CFSdataIn  : in  std_ulogic_vector(31 downto 0); --cfs data in
  CFSdataOut : out std_ulogic_vector(31 downto 0) := (others => '0'); --cfs ddata out

  latheData  : in  ExtDataRcv;          --input data
  latheCtl   : out ExtDataCtl := extDataCtlInit --control data
  );
end CFSInterface;

architecture Behavorial of CFSInterface is

 type sendFSM is (sIdle, sSend, SLoad);
 signal sendState : sendFSM := sIdle;

 type recvFSM is (rIdle, rCopy, rRecv);
 signal recvState : recvFSM := rIdle;

 signal sCount  : unsigned(lenBits-1 downto 0) := (others => '0');
 signal rCount  : unsigned(lenBits-1 downto 0) := (others => '0');

 signal dataOut : std_logic_vector(dataBits-1 downto 0) := (others => '0');
 signal dataIn  : std_logic_vector(dataBits-1 downto 0) := (others => '0');

 signal send    : std_logic := '0';
 signal recv    : std_logic := '0';

begin

 latheCtl.dSnd <= dataOut(dataBits-1);

 data: process(clk)
  begin
  if (rising_edge(clk)) then            --if clock active
   if (we = '1') then                   --if write
    case reg  is                        --select operatin
     when "01" =>
      latheCtl.active <= cfsDataIn(0);

     when "10" =>                       --if data out
      dataOut <= std_logic_vector(CFSDataIn); --load data out register

     when "11" =>                       --if load op register
      latheCtl.op <= unsigned(CFSDataIn(opb-1 downto 0)); --set op register
      if (CFSDataIn(opb) = '0') then
       send <= '1';
      else
       recv <= '1';
      end if;

     when others => null;
    end case;
   end if;

   if (re = '1') then                   --if read
    case reg  is                        --select operatin
     when "10" =>                       --if read
      CFSDataOut <= std_ulogic_vector(dataIn); --read data register

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
      dataOut <= dataOut(dataBits-2 downto 0) & '0';
     else
      latheCtl.shift <= '0';
      latheCtl.load <= '1';
      sendState <= sLoad;
     end if;

    when sLoad =>                       --load data
     latheCtl.load <= '0';
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
      recvState <= rCopy;
     end if;

    when rCopy =>
     latheCtl.copy <= '0';
     rCount <= to_unsigned(dataBits, lenBits);
     latheCtl.shift <= '1';
     recvState <= rRecv;

    when rRecv =>
     if (rCount /= 0) then
      rCount <= rCount - 1;
      dataIn <=  dataIn(dataBits-2 downto 0) & latheData.data;
     else
      recv <= '0';
      latheCtl.shift <= '0';
      CFSDataOut <= std_ulogic_vector(dataIn);
      latheCtl.op <= (others => '0');
      recvState <= rIdle;
     end if;
   end case;

  end if;
 end process;

end Behavorial;
