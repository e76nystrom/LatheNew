--******************************************************************************

LIBRARY ieee;

USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

use work.RegDef.all;
use work.IORecord.all;

use work.DbgRecord.all;
use work.FpgaLatheBitsRec.all;
use work.FpgaLatheBitsFunc.all;

entity Axis is
 generic (
  opBase     : unsigned (opb-1 downto 0) := x"00";
  synBits    : positive := 32;
  posBits    : positive := 24;
  countBits  : positive := 18;
  distBits   : positive := 32;
  locBits    : positive := 18;
  outBits    : positive := 32;
  dbgBits    : positive := 4;
  synDbgBits : positive := 4
  );
 port (
  clk        : in std_logic;

  inp        : in DataInp;
  oRec       : in DataOut;

  extInit    : in std_logic;            --reset
  extEna     : in std_logic;            --enable operation
  extDone    : in std_logic;

  ch         : in std_logic;
  -- encDir     : in std_logic;
  sync       : in std_logic;

  droQuad    : in std_logic_vector(1 downto 0);
  axisIn     : in axisInRec;

  -- currentDir : in std_logic;
  eStop      : in std_logic;

  dbg        : out AxisDbg;
  initOut    : out std_logic := '0';
  enaOut     : out std_logic := '0';
  dout       : out AxisData;
  dirOut     : inout std_logic := '0';
  stepOut    : out std_logic := '0';
  doneInt    : out std_logic := '0'
  );
end Axis;

architecture Behavioral of Axis is

 signal axisStatusR   : axisStatusRec;
 signal axisStatusReg : unsigned(axisStatusSize-1 downto 0);

 signal axisCtlReg : axisCtlVec;
 signal axisCtlR   : axisCtlRec;
 signal syncCtlR   : syncCtlRec;

 signal axisCtlRdReg : unsigned(axisctlSize-1 downto 0);

 signal axisEna    : std_logic := '0';
 signal axisInit   : std_logic := '0';

 signal runInit    : std_logic;
 signal runEna     : std_logic;
 signal locDisable : std_logic := '0';

 signal encActive  : std_logic := '0';

 signal movDone    : std_logic;

 -- signal curDir     : std_logic;
 signal synDirOut  : std_logic;
 signal synStepOut : std_logic;
 signal step       : std_logic;

 signal synDbgData : std_logic_vector(synDbgBits-1 downto 0);
 signal doneDist   : std_logic;
 signal doneDro    : std_logic;
 signal doneLimit  : std_logic;
 signal doneHome   : std_logic;
 signal doneProbe  : std_logic;

 signal pulseOut   : std_logic;

 type run_fsm is (idle, loadReg, synWait, run, done);
 signal runState : run_fsm;         --z run state variable

 function convert(a: run_fsm) return unsigned is
 begin
  case a is
   when idle    => return("0001");
   when loadReg => return("0010");
   when synWait => return("0011");
   when run     => return("0100");
   when done    => return("0101");
   when others  => null;
  end case;
  return("0000");
 end;

begin

 AxStatReg : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Axis_Status,
              n       => axisStatusSize,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => axisStatusReg,
   dout => dout.status                  --doutStatus
   );

  axisStatusReg <= unsigned(axisStatusToVec(axisStatusR));

 AxCtlReg : entity work.CtlReg
  generic map(opVal => opBase + F_Ld_Axis_Ctl,
              n     => axisCtlSize)
  port map (
   clk  => clk,
   inp  => inp,
   data => axisCtlReg);

 axisCtlR <= axisCtlToRec(axisCtlReg);

 syncCtlR.ctlChDirect  <= axisCtlR.ctlChDirect;
 syncCtlR.ctlDroEnd    <= axisCtlR.ctlDroEnd;
 syncCtlR.ctlDistMode  <= axisCtlR.ctlDistMode;
 syncCtlR.ctlDir       <= axisCtlR.ctlDir;
 syncCtlR.ctlHome      <= axisCtlR.ctlHome;
 syncCtlR.ctlHomePol   <= axisCtlR.ctlHomePol;
 syncCtlR.ctlProbe     <= axisCtlR.ctlProbe;
 syncCtlR.ctlUseLimits <= axisCtlR.ctlUseLimits;

 AxCtlRegRd : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Axis_Ctl,
              n       => axisCtlSize,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => axisCtlRdReg,
   dout => dout.ctl                     --doutCtl
   );

 axisCtlRdReg <= unsigned(axisCtlToVec(axisCtlR));

 -- curDir <= currentDir;
 dirOut  <= synDirOut;

 AxisSyncAccel : entity work.SyncAccelDist
  generic map (opBase     => opBase + F_Sync_Base,
               synBits    => synBits,
               posBits    => posBits,
               countBits  => countBits,
               distBits   => distBits,
               droBits    => distBits,
               locBits    => locBits,
               outBits    => outBits,
               synDbgBits => synDbgBits)
  port map (
   clk        => clk,

   inp        => inp,
   oRec       => oRec,

   init       => runInit,
   ena        => runEna,
   extDone    => extDone,
   ch         => ch,

   -- curDir     => curDir,
   locDisable => locDisable,

   droQuad    => droQuad,
   axisIn     => axisIn,
   axisCtl    => SyncCtlR,
   axisStat   => axisStatusR,

   dbg        => dbg.sync,
   dout       => dout.sync,
   dirOut     => synDirOut,
   synStep    => synStepOut
   );

 dbgPulse : entity work.PulseGen
  generic map (pulseWidth => 25)
  port map (
   clk => clk,
   pulseIn => ch,
   PulseOut => pulseOut
   );

 dbg.ctlStart <= axisCtlR.ctlStart;
 dbg.axisEna  <= axisEna;
 dbg.doneDist <= axisStatusR.axDone;
 dbg.pulseOut <= pulseOut;

 runInit <= extInit when axisCtlR.ctlSlave = '1' else axisInit;
 runEna  <= extEna  when axisCtlR.ctlSlave = '1' else axisEna;

 step <= synStepOut;

 initOut   <= axisInit;
 enaOut    <= axisEna;

 stepOut <= step;

 z_run: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active

   if (ch = '1') then                   --if encoder pulse
    encActive <= '1';                   --set to active
   end if;

   if (eStop = '1') then                --if emergency stop
    axisEna  <= '0';                    --stop axis
    runState <= idle;                   --set idle state
   elsif (axisCtlR.ctlInit = '1') then  --if time to set new locaton
    runState <= idle;                   --clear state
    doneInt    <= '0';                  --clear interrupt
    axisEna    <= '0';                  --clear run flag
    locDisable <= '0';                  --enable loc updates
    axisInit   <= '1';                  --set flag to load accel and sync
    encActive  <= '0';                  --clear encoder active
   else                                 --if normal operation
    case runState is                    --check state
     when idle =>                       --idle state
      axisInit <= '0';                  --clear load flag
      if (axisCtlR.ctlStart = '1') then --if start requested
       runState <= loadReg;             --advance to load state
      end if;

     when loadReg =>                    --load state
      if (axisCtlR.ctlWaitSync = '1') then --if wating for sync
       runState <= synWait;             --advance to wait for sync state
      else                              --if not synchronous move
       axisEna  <= '1';                 --set run flag
       runState <= run;                 --advance to run state
       if (axisCtlR.ctlBacklash = '1') then --if backlash move
        locDisable <= '1';              --disable location update
       end if;
      end if;

     when synWait =>                    --sync wait state
      if (axisCtlR.ctlStart = '0') then --if start flag cleared
       runState <= idle;                --return to idle
      else                              --if start flag set
       if ((sync = '1') and (encActive = '1')) then --if time to sync
        axisEna    <= '1';              --set run flag
        runState   <= run;              --advance to run state
       end if;
      end if;

     when run =>                        --run state
      if (axisCtlR.ctlStart = '0') then
       runState <= idle;                --return to idle
      else
       if ((axisStatusR.axDone = '1') or
           (extDone = '1')) then        --if done
        doneInt    <= '1';              --set done interrupt
        locDisable <= '0';              --enable loc updates
        axisEna    <= '0';              --clear run flag
        runState   <= done;             --advance to done state
       end if;
      end if;

     when done =>                       --done state
      if (axisCtlR.ctlStart = '0') then --wait for start flag to clear
       doneInt   <= '0';                --clear done intterrupt
       runState  <= idle;               --to return to idle state
      end if;

     when others => null;               --all other states
    end case;
   end if;
  end if;
 end process;

end Behavioral;
