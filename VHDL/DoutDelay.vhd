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

 alias a0  : std_logic is data.ctl;
 alias a1  : std_logic is data.runR;
 alias a2  : std_logic is data.status;

 alias a3  : std_logic is data.latheCtl.inputs;
 alias a4  : std_logic is data.latheCtl.phase;
 alias a5  : std_logic is data.latheCtl.index.index;

 alias a6  : std_logic is data.latheCtl.index.encoder;
 alias a7  : std_logic is data.latheCtl.index.turnCount;
 alias a8  : std_logic is data.latheCtl.encoder.cmpTmr;

 alias a9  : std_logic is data.latheCtl.encoder.intTmr;
 alias a10 : std_logic is data.latheCtl.z.status;
 alias a11 : std_logic is data.latheCtl.z.ctl;
 alias a12 : std_logic is data.latheCtl.z.sync.dist;

 alias a13 : std_logic is data.latheCtl.z.sync.loc;
 alias a14 : std_logic is data.latheCtl.z.sync.xPos;
 alias a15 : std_logic is data.latheCtl.z.sync.yPos;
 alias a16 : std_logic is data.latheCtl.z.sync.sum;

 alias a17 : std_logic is data.latheCtl.z.sync.accelSum;
 alias a18 : std_logic is data.latheCtl.z.sync.accelCtr;
 alias a19 : std_logic is data.latheCtl.z.sync.accelSteps;
 alias a20 : std_logic is data.latheCtl.z.sync.dro;

 alias a21 : std_logic is data.latheCtl.x.status;
 alias a22 : std_logic is data.latheCtl.x.ctl;
 alias a23 : std_logic is data.latheCtl.x.sync.dist;
 alias a24 : std_logic is data.latheCtl.x.sync.loc;

 alias a25 : std_logic is data.latheCtl.x.sync.xPos;
 alias a26 : std_logic is data.latheCtl.x.sync.yPos;
 alias a27 : std_logic is data.latheCtl.x.sync.sum;
 alias a28 : std_logic is data.latheCtl.x.sync.accelSum;

 alias a29 : std_logic is data.latheCtl.x.sync.accelCtr;
 alias a30 : std_logic is data.latheCtl.x.sync.accelSteps;
 alias a31 : std_logic is data.latheCtl.x.sync.dro;
 alias a32 : std_logic is data.latheCtl.spindle.xPos;

 alias a33 : std_logic is data.latheCtl.spindle.yPos;
 alias a34 : std_logic is data.latheCtl.spindle.sum;
 alias a35 : std_logic is data.latheCtl.spindle.accelSum;
 alias a36 : std_logic is data.latheCtl.spindle.accelMax;

 signal a : std_logic_vector(9 downto 0);
 signal b : std_logic_vector(2 downto 0);

begin

 doutProc : process(clk)
 begin
  if (rising_edge(clk)) then
   a(0) <= a0  or a1  or a2  or a3;
   a(1) <= a4  or a5  or a6  or a7;
   a(2) <= a8  or a9  or a10 or a11;

   b(0) <= a(0) or a(1) or a(2);

   a(3) <= a12 or a13 or a14 or a15;
   a(4) <= a16 or a17 or a18 or a19;
   a(5) <= a20 or a21 or a22 or a23;

   b(1) <= a(3) or a(4) or a(5);

   a(6) <= a24 or a25 or a26 or a27;
   a(7) <= a28 or a29 or a30 or a31;
   a(8) <= a32 or a33 or a34 or a35;
   a(9) <= a36;

   b(2) <= a(6) or a(7) or a(8) or a(9);

   dout <= b(0) or b(1) or b(2);
  end if;
 end process;

end Behavorial;

