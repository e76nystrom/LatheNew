library ieee;

use ieee.std_logic_1164.all;

use work.DbgRecord.all;

entity DbgMap is
 port (
  clk   : in  std_logic;
  debug : in  InterfaceDbg;
  dbg   : out std_logic_vector(7 downto 0)
  );
end DbgMap;

architecture Behavorial of DbgMap is

 signal test0 : std_logic;
 signal test1 : std_logic;
 signal test2 : std_logic;
 signal test3 : std_logic;
 
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

 doutProc : process(clk)
 begin
  if (rising_edge(clk)) then
   dbg(0) <= debug.ctl.x.ctlStart;
   dbg(1) <= debug.ctl.x.axisEna;
   dbg(2) <= debug.ctl.x.doneDist;
   dbg(3) <= debug.ctl.x.pulseOut;
   dbg(4) <= test0;
   dbg(5) <= test1;
   dbg(6) <= test2;
   dbg(7) <= test3;
  end if;
 end process;

end Behavorial;
