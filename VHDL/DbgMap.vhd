library ieee;

use ieee.std_logic_1164.all;

use work.DbgRecord.all;

entity DbgMap is
 port (
  clk   : in  std_logic;
  debug : in  InterfaceDbg;
  dbg   : out std_logic_vector(7 downto 0);
  sink  : out std_logic
  );
end DbgMap;

architecture Behavorial of DbgMap is

 signal test0 : std_logic;
 signal test1 : std_logic;
 signal test2 : std_logic;
 signal test3 : std_logic;

 alias a0  : std_logic is debug.ctl.xCh;
 alias a1  : std_logic is debug.ctl.zCh;
 alias a2  : std_logic is debug.ctl.sync;
 alias a3  : std_logic is debug.ctl.dbgFreq;
 alias a4  : std_logic is debug.ctl.xDone;
 alias a5  : std_logic is debug.ctl.zDone;

 alias a6  : std_logic is debug.ctl.z.sync.ena;
 alias a7  : std_logic is debug.ctl.z.sync.done;
 alias a8  : std_logic is debug.ctl.z.sync.distCtr;
 alias a9  : std_logic is debug.ctl.z.sync.loc;

 alias a10 : std_logic is debug.ctl.z.ctlStart;
 alias a11 : std_logic is debug.ctl.z.axisEna;
 alias a12 : std_logic is debug.ctl.z.doneDist;
 alias a13 : std_logic is debug.ctl.z.pulseOut;

 alias a14 : std_logic is debug.ctl.x.sync.ena;
 alias a15 : std_logic is debug.ctl.x.sync.done;
 alias a16 : std_logic is debug.ctl.x.sync.distCtr;
 alias a17 : std_logic is debug.ctl.x.sync.loc;

 alias a18 : std_logic is debug.ctl.x.ctlStart;
 alias a19 : std_logic is debug.ctl.x.axisEna;
 alias a20 : std_logic is debug.ctl.x.doneDist;
 alias a21 : std_logic is debug.ctl.x.pulseOut;

 alias a22 : std_logic is debug.ctl.encscale.cycleDone;
 alias a23 : std_logic is debug.ctl.encscale.cmpUpd;
 alias a24 : std_logic is debug.ctl.encscale.intClk;

 signal a : std_logic_vector(9 downto 0);
 signal b : std_logic_vector(2 downto 0);

begin

 -- test 0 output pulse

 testOut0 : entity work.PulseGen
  generic map (pulseWidth => 50)
  port map (
   clk => clk,
   -- pulseIn => debug.ctl.xCh,
   pulseIn => debug.ctl.encScale.cmpUpd,
   PulseOut => test0
   );

-- test 1 output pulse

 testOut1 : entity work.PulseGen
  generic map (pulseWidth => 50)
  port map (
   clk => clk,
   -- pulseIn => debug.ctl.zCh,
   pulseIn => debug.ctl.encScale.intClk,
   pulseOut => test1
   );

-- test 2 output pulse

 testOut2 : entity work.PulseGen
  generic map (pulseWidth => 50)
  port map (
   clk => clk,
   pulseIn => debug.ctl.sync,
   pulseOut => test2
   );

-- test 2 output pulse

 testOut3 : entity work.PulseGen
  generic map (pulseWidth => 50)
  port map (
   clk => clk,
   -- pulseIn => debug.ctl.dbgFreq,
   pulseIn => debug.ctl.encScale.cycleDone,
   pulseOut => test3
   );

 dbgProc : process(clk)
 begin
  if (rising_edge(clk)) then
   dbg(0) <= debug.ctl.z.ctlStart;
   dbg(1) <= debug.ctl.z.axisEna;
   dbg(2) <= debug.ctl.z.doneDist;
   dbg(3) <= debug.ctl.z.pulseOut;
   dbg(4) <= test0;
   dbg(5) <= test1;
   dbg(6) <= test2;
   dbg(7) <= test3;
  end if;
 end process;

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

   a(6) <= a24;

   b(2) <= a(6);

   sink <= b(0) or b(1) or b(2);
  end if;
 end process;

end Behavorial;
