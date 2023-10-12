library ieee;

use ieee.std_logic_1164.all;

use work.IORecord.all;

entity DoutDelay is
 port (
  clk  : in  std_logic;
  data : in  LatheInterfaceData;
  dout : out std_logic
  );
end DoutDelay;

architecture Behavorial of DoutDelay is

 signal a : std_logic_vector(8 downto 0);
 signal b : std_logic_vector(2 downto 0);
 
begin

 doutProc : process(clk)
 begin
  if (rising_edge(clk)) then
   a(0) <= data.ctl or
           data.runR or
           data.status or
           data.latheCtl.inputs;

   a(1) <= data.latheCtl.phase or
           data.latheCtl.index or
           data.latheCtl.encoder.cmpTmr or
           data.latheCtl.encoder.intTmr;

   a(2) <= data.latheCtl.z.status or
           data.latheCtl.z.ctl or
           data.latheCtl.z.sync.dist or
           data.latheCtl.z.sync.loc;

   b(0) <= a(0) or a(1) or a(2);

   a(3) <= data.latheCtl.z.sync.xPos or
           data.latheCtl.z.sync.yPos or
           data.latheCtl.z.sync.sum or
           data.latheCtl.z.sync.accelSum;

   a(4) <= data.latheCtl.z.sync.accelCtr or
           data.latheCtl.z.sync.accelSteps or
           data.latheCtl.z.sync.dro;

   a(5) <= data.latheCtl.x.status or
           data.latheCtl.x.ctl or
           data.latheCtl.x.sync.dist or
           data.latheCtl.x.sync.loc;

   b(1) <= a(3) or a(4) or a(5);

   a(6) <= data.latheCtl.x.sync.xPos or
           data.latheCtl.x.sync.yPos or
           data.latheCtl.x.sync.sum or
           data.latheCtl.x.sync.accelSum;

   a(7) <= data.latheCtl.x.sync.accelCtr or
           data.latheCtl.x.sync.accelSteps or
           data.latheCtl.x.sync.dro or
           data.latheCtl.spindle.xPos;

   a(8) <= data.latheCtl.spindle.yPos or
           data.latheCtl.spindle.sum or
           data.latheCtl.spindle.accelSum or
           data.latheCtl.spindle.accelCtr;
   
   b(2) <= a(6) or a(7) or a(8);

   dout <= b(0) or b(1) or b(2);
  end if;
 end process;

end Behavorial;
