--******************************************************************************
library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.RegDef.all;
use work.IORecord.all;
use work.DbgRecord.all;

entity SyncAccelDist is
 generic (opBase     : unsigned := x"00";
          synBits    : positive := 32;
          posBits    : positive := 18;
          countBits  : positive := 18;
          distBits   : positive := 18;
          droBits    : positive := 18;
          locBits    : positive := 18;
          outBits    : positive := 32;
          synDbgBits : positive := 4);
 port (
  clk        : in std_logic;
  inp        : DataInp;
  oRec       : DataOut;
  init       : in std_logic;            --reset
  ena        : in std_logic;            --enable operation
  extDone    : in std_logic;            --external done input
  ch         : in std_logic;            --step input clock
  cmdDir     : in std_logic;            --direction in
  curDir     : in std_logic;            --current directin
  locDisable : in std_logic;            --disable location update
  distMode   : in std_logic;            --distance update mode

  -- mpgQuad    : in std_logic_vector(1 downto 0);
  -- jogInvert  : in std_logic;
  -- jogMode    : in std_logic_vector(1 downto 0);

  droQuad    : in std_logic_vector(1 downto 0);
  droInvert  : in std_logic;
  droEndChk  : in std_logic;

  dbg        : out SyncAccelDbg;
  movDone    : out std_logic := '0';    --done move
  droDone    : out std_logic := '0';    --dro move done
  distZero   : out std_logic := '0';    --distance zero
  dout       : out SyncData;
  dirOut     : out std_logic := '0';    --direction out
  synStep    : out std_logic := '0'     --output step pulse
  );
end SyncAccelDist;

architecture Behavioral of SyncAccelDist is

 -- state machine

 type SyncFsm is (syncInit, syncIdle, enabled, updAccel, checkAccel, clkWait,
                  distWait, doneWait, mpgEnabled, mpgEnabled1);
 signal syncState : syncFsm := syncInit;

 function syncConv(a: Syncfsm) return std_logic_vector is
 begin
  case a is
   when syncInit    => return("0001");
   when syncIdle    => return("0010");
   when enabled     => return("0011");
   when updAccel    => return("0100");
   when checkAccel  => return("0101");
   when clkWait     => return("0110");
   when distWait    => return("0111");
   when doneWait    => return("1000");
   -- when mpgEnabled  => return("1001");
   -- when mpgEnabled1 => return("1010");
   when others      => return("0000");
  end case;
  return("0000");
 end;

 type accelFsm is (accelInactive, accelActive, atSpeed, decelActive);
 signal accelState : accelFsm := accelInactive;

 -- constant registers

 signal d      : unsigned(synBits-1 downto 0); --initial sum
 signal incr1  : unsigned(synBits-1 downto 0); --
 signal incr2  : unsigned(synBits-1 downto 0);
 signal accel  : unsigned(synBits-1 downto 0);

 -- accel registers

 signal accelCount   : unsigned(countBits-1 downto 0);
 signal accelCounter : unsigned(countBits-1 downto 0) := (others => '0');
 signal accelSum     : unsigned(synBits-1 downto 0) := (others => '0');
 signal accelSteps   : unsigned(distBits-1 downto 0) := (others => '0');

 -- sync registers

 signal xpos   : unsigned(posBits-1 downto 0) := (others => '0'); --sync in
 signal ypos   : unsigned(posBits-1 downto 0) := (others => '0'); --sync out
 signal sum    : unsigned(synBits-1 downto 0) := (others => '0'); --sum
 alias  sumNeg : std_logic is sum(synBits-1); --sum sign bit

 -- distance registers

 signal distVal     : unsigned(distBits-1 downto 0); --input distance
 signal distCtr     : unsigned(distBits-1 downto 0) := (others => '0');
 signal maxDist     : unsigned(distBits-1 downto 0) := (others => '0');
 signal backlash    : unsigned(distBits-1 downto 0) := (others => '0');

 signal loadDist    : std_logic := '0';
 signal distUpdate  : std_logic := '0';
 signal distReLoad  : std_logic := '0';

 signal movDoneInt  : std_logic := '0';
 signal distZeroInt : std_logic := '0';

 signal synStepTmp  : std_logic := '0';
 signal synStepLast : std_logic := '0';

  -- ********** location definitions **********

 signal locVal : unsigned(locBits-1 downto 0); --location input
 signal loc    : unsigned(locBits-1 downto 0) := (others => '0'); --cur loc
 
 signal locLoad   : std_logic := '0';
 signal locUpdate : boolean   := false;

 -- ********** dro definitions **********

 type droFSM is (droIdle, droCalcDist, droChkDisable, droChkDone,
                 droDoneWait);
 signal droState : droFSM := droIdle;

 signal droQuadState : std_logic_vector(3 downto 0) := (others => '0');
 signal droA         : std_logic_vector(1 downto 0) := (others => '0');
 signal droB         : std_logic_vector(1 downto 0) := (others => '0');
 signal droUpdate    : std_logic := '0';
 signal droDir       : std_logic := '0';

 signal droInput     : unsigned(droBits-1 downto 0);
 signal droVal       : unsigned(droBits-1 downto 0) := (others => '0');
 signal droDist      : signed(droBits-1 downto 0) := (others => '0');
 signal droEnd       : unsigned(droBits-1 downto 0);
 signal decelLimit   : unsigned(droBits-1 downto 0);
 signal droDecelStop : std_logic := '0';
 signal droDoneInt   : std_logic := '0';
 signal droLoad      : std_logic := '0';
 signal droLoadVal   : std_logic := '0';

 -- -- ********** mpg jog definitions **********

 -- -- mpg sync accel control signals

 -- signal stop     : std_logic := '0';    --stop sync accel
 -- signal mpgEna   : std_logic := '0';    --enable sync accel from mpg
 -- -- signal distLoad : std_logic := '0';    --load distance

 -- -- mpg state definitions

 -- type jog_fsm is (mpgUpdate, mpgDirChange, mpgBacklash, mpgMove, mpgX, mpgX1);
 -- signal jogState : jog_fsm;         --jog state variable

 -- -- mpg quadrature input

 -- alias a : std_logic is mpgQuad(0);
 -- alias b : std_logic is mpgQuad(1);

 -- signal lastA : std_logic_vector(1 downto 0) := (others => '0');
 -- signal lastB : std_logic_vector(1 downto 0) := (others => '0');

 -- signal mpgQuadState   : std_logic_vector(3 downto 0) := (others => '0');
 -- signal mpgQuadUpdate  : std_logic := '0';
 -- signal mpgDir         : std_logic := '0';
 -- signal lastMpgDir     : std_logic := '0';
 -- signal jogdir         : std_logic := '0';
 -- signal backlashActive : std_logic := '0';

 -- constant timerMax  : natural := 30; --50000;
 -- constant timerBits : natural := integer(ceil(log2(real(timerMax))));
 -- signal   timer     : unsigned(timerBits-1 downto 0) := (others => '0');
 -- signal   timerClr  : std_logic := '0';

 -- constant divMax    : natural := 63;
 -- constant divBits   : natural := integer(ceil(log2(real(divMax)))); 
 -- signal   chDiv     : unsigned(divBits-1 downto 0) := (others => '0');
 -- signal   chCtr     : unsigned(divBits-1 downto 0) := (others => '0');

 -- constant deltaMax  : natural := 50;
 -- constant deltaBits : natural := integer(ceil(log2(real(deltaMax))));
 -- signal   delta     : unsigned(deltaBits-1 downto 0) := (others => '0');

 -- type deltaRec is record
 --  val : unsigned(deltaBits-1 downto 0);
 -- end record;

 -- constant deltaI0   : natural := 30;
 -- constant deltaI1   : natural := 15;
 -- constant deltaI2   : natural := 4;
 -- constant deltaI3   : natural := 0;

 -- constant divI0     : natural := 1;
 -- constant divI1     : natural := 3;
 -- constant divI2     : natural := 5;
 -- constant divI3     : natural := 7;

 -- constant distI0    : natural := 1;
 -- constant distI1    : natural := 2;
 -- constant distI2    : natural := 4;
 -- constant distI3    : natural := 8;

 -- constant mpgBits   : natural := 32;

 -- constant regDeltaIni : unsigned(mpgBits-1 downto 0) :=
 --  (to_unsigned(deltaI3, 8) & to_unsigned(deltaI2, 8) &
 --   to_unsigned(deltaI2, 8) & to_unsigned(deltaI0, 8));

 -- constant regDivIni : unsigned(mpgBits-1 downto 0) :=
 --  (to_unsigned(divI3, 8) & to_unsigned(divI2, 8) &
 --   to_unsigned(divI2, 8) & to_unsigned(divI0, 8));

 -- constant regDistIni : unsigned(mpgBits-1 downto 0) :=
 --  (to_unsigned(distI3, 8) & to_unsigned(distI2, 8) &
 --   to_unsigned(distI2, 8) & to_unsigned(distI0, 8));

 -- signal mpgRegDelta : unsigned(mpgBits-1 downto 0) := regDeltaIni;
 -- signal mpgRegDiv   : unsigned(mpgBits-1 downto 0) := regDivIni;
 -- signal mpgRegDist  : unsigned(mpgBits-1 downto 0) := regDistIni;

 -- constant mpgDistMax  : natural := 200;
 -- constant mpgDistBits : natural := integer(ceil(log2(real(mpgDistMax))));
 -- signal   mpgDistUpd  : std_logic := '0';
 -- signal   mpgDist     : unsigned(mpgDistBits-1 downto 0) := (others => '0');
 -- signal   mpgDistCtr  : unsigned(mpgDistBits-1 downto 0) := (others => '0');

 -- alias delta0 : unsigned(deltaBits-1 downto 0) is
 --  mpgRegDelta(0 + deltaBits-1 downto 0);
 -- alias delta1 : unsigned(deltaBits-1 downto 0) is
 --  mpgRegDelta(8 + deltaBits-1 downto 8);
 -- alias delta2 : unsigned(deltaBits-1 downto 0) is
 --  mpgRegDelta(16 + deltaBits-1 downto 16);

 --  alias div0 : unsigned(timerBits-1 downto 0) is
 --  mpgRegDiv(0 + timerBits-1 downto 0);
 -- alias div1 : unsigned(timerBits-1 downto 0) is
 --  mpgRegDiv(8 + timerBits-1 downto 8);
 -- alias div2 : unsigned(timerBits-1 downto 0) is
 --  mpgRegDiv(16 + timerBits-1 downto 16);
 -- alias div3 : unsigned(timerBits-1 downto 0) is
 --  mpgRegDiv(24 + timerBits-1 downto 24);

 --  alias dist0 : unsigned(mpgDistBits-1 downto 0) is
 --  mpgRegDist(0 + mpgDistBits-1 downto 0);
 -- alias dist1 : unsigned(mpgDistBits-1 downto 0) is
 --  mpgRegDist(8 + mpgDistBits-1 downto 8);
 -- alias dist2 : unsigned(mpgDistBits-1 downto 0) is
 --  mpgRegDist(16 + mpgDistBits-1 downto 16);
 -- alias dist3 : unsigned(mpgDistBits-1 downto 0) is
 --  mpgRegDist(24 + mpgDistBits-1 downto 24);

 -- constant mpgBits   : natural := 32;

 -- constant deltaMax  : natural := 50;
 -- constant deltaBits : natural := integer(ceil(log2(real(deltaMax))));
 -- signal   delta     : unsigned(deltaBits-1 downto 0) := (others => '0');

 -- type deltaRec is record
 --  val : unsigned(deltaBits-1 downto 0);
 -- end record;

 -- -- delta

 -- constant deltaI0   : natural := 30;
 -- constant deltaI1   : natural := 15;
 -- constant deltaI2   : natural := 4;
 -- constant deltaI3   : natural := 0;

 -- constant regDeltaIni : unsigned(mpgBits-1 downto 0) :=
 --  (to_unsigned(deltaI3, 8) & to_unsigned(deltaI2, 8) &
 --   to_unsigned(deltaI2, 8) & to_unsigned(deltaI0, 8));

 -- signal mpgRegDelta : unsigned(mpgBits-1 downto 0) := regDeltaIni;

 -- alias delta0 : unsigned(deltaBits-1 downto 0) is
 --  mpgRegDelta(0 + deltaBits-1 downto 0);
 -- alias delta1 : unsigned(deltaBits-1 downto 0) is
 --  mpgRegDelta(8 + deltaBits-1 downto 8);
 -- alias delta2 : unsigned(deltaBits-1 downto 0) is
 --  mpgRegDelta(16 + deltaBits-1 downto 16);

 -- -- div
 
 -- constant divMax    : natural := 63;
 -- constant divBits   : natural := integer(ceil(log2(real(divMax)))); 
 -- signal   chDiv     : unsigned(divBits-1 downto 0) := (others => '0');
 -- signal   chCtr     : unsigned(divBits-1 downto 0) := (others => '0');

 -- constant divI0     : natural := 1;
 -- constant divI1     : natural := 3;
 -- constant divI2     : natural := 5;
 -- constant divI3     : natural := 7;

 -- constant regDivIni : unsigned(mpgBits-1 downto 0) :=
 --  (to_unsigned(divI3, 8) & to_unsigned(divI2, 8) &
 --   to_unsigned(divI2, 8) & to_unsigned(divI0, 8));

 -- signal mpgRegDiv   : unsigned(mpgBits-1 downto 0) := regDivIni;

 -- alias div0 : unsigned(divBits-1 downto 0) is
 --  mpgRegDiv(0 + divBits-1 downto 0);
 -- alias div1 : unsigned(divBits-1 downto 0) is
 --  mpgRegDiv(8 + divBits-1 downto 8);
 -- alias div2 : unsigned(divBits-1 downto 0) is
 --  mpgRegDiv(16 + divBits-1 downto 16);
 -- alias div3 : unsigned(divBits-1 downto 0) is
 --  mpgRegDiv(24 + divBits-1 downto 24);

 -- -- dist
 
 -- constant mpgDistMax  : natural := 200;
 -- constant mpgDistBits : natural := integer(ceil(log2(real(mpgDistMax))));
 -- signal   mpgDistUpd  : std_logic := '0';
 -- signal   mpgDist     : unsigned(mpgDistBits-1 downto 0) := (others => '0');
 -- signal   mpgDistCtr  : unsigned(mpgDistBits-1 downto 0) := (others => '0');

 -- constant distI0    : natural := 1;
 -- constant distI1    : natural := 2;
 -- constant distI2    : natural := 4;
 -- constant distI3    : natural := 8;

 -- constant regDistIni : unsigned(mpgBits-1 downto 0) :=
 --  (to_unsigned(distI3, 8) & to_unsigned(distI2, 8) &
 --   to_unsigned(distI2, 8) & to_unsigned(distI0, 8));

 -- signal mpgRegDist  : unsigned(mpgBits-1 downto 0) := regDistIni;

 -- alias dist0 : unsigned(mpgDistBits-1 downto 0) is
 --  mpgRegDist(0 + mpgDistBits-1 downto 0);
 -- alias dist1 : unsigned(mpgDistBits-1 downto 0) is
 --  mpgRegDist(8 + mpgDistBits-1 downto 8);
 -- alias dist2 : unsigned(mpgDistBits-1 downto 0) is
 --  mpgRegDist(16 + mpgDistBits-1 downto 16);
 -- alias dist3 : unsigned(mpgDistBits-1 downto 0) is
 --  mpgRegDist(24 + mpgDistBits-1 downto 24);

begin

 dreg : entity work.ShiftOp
  generic map(opVal  => opBase + F_Ld_D,
              n      => synBits)
  port map (
   clk   => clk,
   inp   => inp,
   data  => d);

 incr1reg : entity work.ShiftOp
  generic map(opVal =>  opBase + F_Ld_Incr1,
              n =>      synBits)
  port map (
   clk   => clk,
   inp   => inp,
   data  => incr1);

 incr2reg : entity work.ShiftOp
  generic map(opVal  => opBase + F_Ld_Incr2,
              n      => synBits)
  port map (
   clk   => clk,
   inp   => inp,
   data  => incr2);

 accelreg : entity work.ShiftOp
  generic map(opVal  => opBase + F_Ld_Accel_Val,
              n      => synBits)
  port map (
   clk   => clk,
   inp   => inp,
   data  => accel);

 accelCountReg : entity work.ShiftOp
  generic map(opVal  => opBase + F_Ld_Accel_Count,
              n      => countBits)
  port map (
   clk   => clk,
   inp   => inp,
   data  => accelCount);

  distShiftOp : entity work.ShiftOpLoad
  generic map(opVal  => opBase + F_Ld_Dist,
              n      => distBits)
  port map(
   clk   => clk,
   inp   => inp,
   load  => loadDist,
   data  => distVal
   );

  maxDistShiftOp : entity work.ShiftOp
  generic map(opVal  => opBase + F_Ld_Max_Dist,
              n      => distBits)
  port map(
   clk   => clk,
   inp   => inp,
   data  => maxDist
   );

 droPosReg : entity work.ShiftOpLoad
  generic map(opVal  => opBase + F_Ld_Dro,
              n      => droBits)
  port map (
   clk   => clk,
   inp   => inp,
   load  => droLoad,
   data  => droInput);

 droEndReg : entity work.ShiftOp
  generic map(opVal  => opBase + F_Ld_Dro_End,
              n      => droBits)
  port map (
   clk   => clk,
   inp   => inp,
   data  => droEnd);

 droLimitReg : entity work.ShiftOp
  generic map(opVal  => opBase + F_Ld_Dro_Limit,
              n      => droBits)
  port map (
   clk   => clk,
   inp   => inp,
   data  => decelLimit);

  -- BacklashShiftOp : entity work.ShiftOp
  -- generic map(opVal  => opBase + F_Ld_Backlash,
  --             n      => distBits)
  -- port map (
  --  clk   => clk,
  --  inp   => inp,
  --  data  => backlash
  --  );

 locvalreg : entity work.ShiftOpLoad
  generic map(opVal  => opBase + F_Ld_Loc,
              n      => locBits)
  port map (
   clk   => clk,
   inp   => inp,
   load  => locLoad,
   data  => locVal);

 -- MpgDeltaOp : entity work.ShiftOp
 --  generic map(opVal  => opBase + F_Ld_Mpg_Delta,
 --              n      => mpgBits)
 --  port map (
 --   clk   => clk,
 --   inp   => inp,
 --   data  => mpgRegDelta
 --   );

 --  MpgDivOp : entity work.ShiftOp
 --  generic map(opVal  => opBase + F_Ld_Mpg_Div,
 --              n      => mpgBits)
 --  port map (
 --   clk   => clk,
 --   inp   => inp,
 --   data  => mpgRegDiv
 --   );

 --  MpgDistOp : entity work.ShiftOp
 --  generic map(opVal  => opBase + F_Ld_Mpg_Dist,
 --              n      => mpgBits)
 --  port map (
 --   clk   => clk,
 --   inp   => inp,
 --   data  => mpgRegDist
 --   );

 -- read registers

 sum_out : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Sum,
              n       => synBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => sum,
   dout   => dout.sum                   --sumDout
   );

 accelSum_Out : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Accel_Sum,
              n       => synBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => accelSUm,
   dout   => dout.accelSum              --accelSumDout
   );

 accelCtr_out : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Accel_Ctr,
              n       => countBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => accelCounter,
   dout   => dout.accelCtr              --accelCtrDout
   );

 xPos_Shift : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_XPos,
              n       => posBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => xPos,
   dout   => dout.xPos                  --xPosDout
   );

 yPos_Shift : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_YPos,
              n       => posBits,
              outBits => outBits)
  port map (
   clk => clk,
   oRec   => oRec,
   data => yPos,
   dout => dout.yPos                    --yPosDout
   );

 DistShiftOut : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Dist,
              n       => distBits,
              outBits => outBits)
  port map (
   clk => clk,
   oRec   => oRec,
   data => distCtr,
   dout => dout.dist                    --distDout
   );
 
 LocShiftOut : entity work.ShiftOutNS
  generic map(opVal   => opBase + F_Rd_Loc,
              n       => locBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => loc,
   dout   => dout.loc                   --locDout
   );

 droShiftOut : entity work.ShiftOutNS
  generic map(opVal   => opBase + F_Rd_Dro,
              n       => droBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => unsigned(droVal),
   dout   => dout.dro                   --droDout
   );

 -- dirOut <= cmdDir when (jogMode(1) = '0') else jogDir;
 dirOut <= cmdDir;
 
 AccelShiftOut : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Accel_Steps,
              n       => distBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => accelSteps,
   dout   => dout.accelSteps            --accelStepsDout
   );

 movDone <= movDoneInt;

 dbg.ena     <= ena;
 dbg.done    <= movDoneInt;
 dbg.distCtr <= std_logic(distCtr(0));
 dbg.loc     <= std_logic(loc(0));

 distZeroInt <= '1' when (distCtr = 0) else '0';
 distZero    <= distZeroInt;

 syn_process: process(clk)

  -- variable mpgQuadChange : std_logic;

 begin
  
  if (rising_edge(clk)) then            --if clock active

   droDone <= droDoneInt;

   -- if ((jogMode = "01") and (loadDist = '1')) then --jog and dist update
   --  distUpdate <= '1';                  --set distance update flag
   -- end if;

   if ((distMode = '1') and (loadDist = '1')) then --dist upd mode and update
    distReLoad <= '1';                  --set distance reload flag
   end if;

   if (locLoad = '1') then              --if new location
    locUpdate <= true;                  --set to load
   end if;

   if (init = '1') then                 --if initialization
    movDoneInt <= '0';                  --clear done
    droDone <= '0';                     --clear dro done
    xPos <= (others => '0');            --clear input count
    yPos <= (others => '0');            --clear output count
    sum <= d;                           --initialize sum
    accelCounter <= (others => '0');    --clear accel clock counter
    accelSum <= (others => '0');        --clear accel sum
    accelSteps <= (others => '0');      --clear accel steps
    syncState <= syncInit;              --set sync to init state
   end if;

   case syncState is                    --select syncState

    -- initialization
    when syncInit => --***********************************************
     -- movDone <= '0';                 --clear move done
     accelState <= accelInactive;       --set to inactive state
     synStep <= '0';                    --clear output step
     synStepTmp <= '0';                 --clear step
     distUpdate <= '0';                 --clear distance update
     distReload <= '0';                 --clear reload flag
     if (ena = '0') and  (init = '0') then --if enable cleared
      syncState <= syncIdle;            --set to yncIdle state
     end if;

    --idle
    when syncIdle => --***********************************************

     synStep <= '0';                    --clear output step

     if (ena = '1') then
     -- if (((ena = '1')    and (jogMode = "00")) or
     --     ((mpgEna = '1') and (jogMode = "10"))) then
      distCtr <= distVal;
      accelState <= accelActive;        --start acceleration
      syncState <= enabled;             --go to enabled state
     -- elsif ((mpgEna = '1') and (jogMode = "11")) then --if mpg jog

     --  if (backlashActive /= '0') then   --if backlash
     --   distCtr <= backlash;             --set to move backlash dist
     --   syncState <= enabled;            --go to enabled state
     --  else
     --   distCtr <= ((distCtr'length - mpgDist'length-1 downto 0 =>'0') &
     --               mpgDist);            --load distance
     --   chCtr <= to_unsigned(0, chCtr'length); --initialize clock divider
     --   syncState <= mpgEnabled;          --advance to mpg jog state
     --  end if;
     end if;

    --enabled
    when enabled => --************************************************

     -- if (stop = '1') then               --if stop for mpg
     --  syncState <= syncInit;            --go to init state
     -- end if;

     synStep <= '0';                    --clear output step

     if ((ena = '0') or (extDone = '1')) then --if enable cleared
      syncState <= syncInit;            --return to init state
     elsif (ch = '1') then              --if input clock

      xPos <= xPos + 1;                 --count input clock

      if (sumNeg = '1') then            --if negative (sign bit set)
       sum <= sum + incr1;              --update for negative
      else                              --if positive
       sum <= sum + incr2;              --update for positive
       yPos <= yPos + 1;                --update output count
       synStepTmp <= '1';               --enable step pulse

       distctr <= distCtr - 1;          --count off distance

       if (accelState = accelActive) then --if accel active
        accelSteps <= accelSteps + 1;     --add an accel stesp
       elsif (accelState = decelActive) then --if decel active
        accelSteps <= accelSteps - 1;   --subtract an accel step
       end if;

      end if;                           --sumNeg
      syncState <= updAccel;
     end if;                            --ch

    --update acceleration
    when updAccel => --***********************************************

     if (distUpdate = '1') then         --if distance update
      distCtr <= distCtr + distVal;     --add to current distance
     end if;

     if (distReload = '1') then         --if reload distance
      distReload <= '0';                --clear reload flag
      distCtr <= distVal;               --reload register
     end if;

     sum <= sum + accelSum;             --update sum value with accel

     case accelState is                 --select accelState
      
      --inactive
      when accelInactive => --##########
       null;

      --acceleration
      when accelActive => --############
       if (accelCounter < accelCount) then
        accelSum <= accelSum + accel;
        accelCounter <= accelCounter + 1;
       end if;

       if (accelSteps >= distCtr) then  --if steps ge dist
        accelState <= decelActive;      --start decelerate
       end if;

     --at speed
      when atSpeed => --################
       if (accelSteps >= distCtr) then  --if steps ge dist
        accelState <= decelActive;      --start decelerate
       end if;

     --deceleration
      when decelActive => --############
       if (droDecelStop = '0') then     --if not stopped by dro
        accelSum <= accelSum - accel;
        accelCounter <= accelCounter - 1;
       end if;

      --others
      when others => --#################
       accelState <= accelInactive;
     end case;                          --accelState

     syncState <= checkAccel;           --check acclerations

    -- check acceleration
    when checkAccel => --*********************************************

     if (distUpdate = '1') then         --if distance update
      distUpdate <= '0';                --clear update flag
      if (distCtr > maxDist) then       --if distance out of range
       distCtr <= maxDist;              --set to maximum
      end if;
     end if;

     case accelState is                 --select accelState

      --acceleration
      when accelActive =>  --###########
       if (accelCounter >= accelCount) then
        accelState <= atSpeed;
       end if;

      --at speed
      when atSpeed => --################
       null;

      --deceleration
      when decelActive => --############
       if (distCtr > accelSteps) then
        accelState <= accelActive;
       end if;

       if (accelCounter = to_unsigned(0, countBits)) then
        accelState <= accelInactive;
       end if;

      --others
      when others => --#################
       accelState <= accelInactive;
     end case;                          --accelState

     syncState <= clkWait;

    -- wait for clock to clear
    when clkWait => --************************************************

     synStep <= synStepTmp;             --output step
     synStepTmp <= '0';                 --clear tmp value

     if (ch = '0') then                 --if change flag cleared

      if (droEndChk = '0') then         --if not using dro for end

       if (distZeroInt = '0') then      --if not to distance
        syncState <= enabled;           --return to enabled state
       else                             --if distance 0

        -- if (jogMode = "00") then        --if not jogging
         if (distMode = '0') then       --if in distance mode
          movDoneInt <= '1';            --set done flag
          syncState <= syncInit;        --return to init state
         else                           --if distance update mode
          syncState <= distWait;        --wait for distance update
         end if;          
        -- else                            --if jog mode
        --  syncState <= doneWait;         --wait to jog again
        -- end if;

       end if;

      else                              --if using dro for end

       if (droDoneInt = '0') then       --if not done
        syncState <= enabled;           --return to enabled
       else                             --if dro done
        droDone <= '1';                 --set done flag
        syncState <= syncInit;          --return to init state
       end if;

      end if;       

     end if;

    --wait for distance update
    when distWait => --***********************************************

     if (ena = '0') then                --if enable cleared
      syncState <= syncInit;            --return to init state
     end if;

     if (distReLoad = '1') then         --if distance reloaded
      distReload <= '0';                --clear reload flag
      distCtr <= distVal;               --reload distance
      accelState <= accelInactive;      --set accel to inactive state
      syncState <= enabled;             --return to enabled
     end if;      

    --wait for mpg
    when doneWait => --***********************************************

     -- if (jogMode = "00") then           --if out of jog mode
      syncState <= syncInit;            --return to init state
     -- else                               --if jog mode
     --  if (jogState = mpgUpdate) then    --if jog waiting for an update
     --   syncState <= syncInit;           --return to init state
     --  end if;
     -- end if;

    -- mpg updates
    -- when mpgEnabled => --*********************************************

    --  synStep <= '0';                    --clear step output
    --  if (ch = '1') then                 --if clock
    --   if (chCtr = chDiv) then           --if time to step
    --    if (distZeroInt = '0') then      --if not done
    --     chCtr <= to_unsigned(0, chCtr'length); --reset counter
    --     distCtr <= distCtr - 1;         --update distance
    --     synStepTmp <= '1';              --set step signal
    --     syncState <= mpgEnabled1;       --advance to next state
    --    else                             --if done
    --     syncState <= syncInit;          --return to init state
    --    end if;
    --   else                              --if not time to step
    --    chCtr <= chCtr + 1;              --increment counter
    --   end if;
    --  end if;

    -- -- mpg updates
    -- when mpgEnabled1 => --********************************************

    --  synStep <= synStepTmp;             --output step pulse
    --  synStepTmp <= '0';                 --clear step pulse
    --  if (mpgDistUpd = '1') then         --if time for a distance update
    --   distCtr <= distCtr + mpgDist;     --update distance
    --  elsif (distCtr > maxDist) then     --if distctr gt max
    --   distCtr <= maxDist;               --reset to max
    --  end if;

    --  syncState <= mpgEnabled;           --return to enable state

    -- others
    when others => --*************************************************
     syncState <= syncInit;             --set to init

   end case;                            --end case sync state

   -- ********** dro  **********

   droA <= droA(0) & droQuad(0);
   droB <= droB(0) & droQuad(1);

   droQuadState <= droB(1) & droA(1) & droB(0) & droA(0);
   
   case (droQuadState) is
    when "0001" => droUpdate <= '1'; droDir <= droInvert;
    when "0111" => droUpdate <= '1'; droDir <= droInvert;
    when "1110" => droUpdate <= '1'; droDir <= droInvert;
    when "1000" => droUpdate <= '1'; droDir <= droInvert;
    when "0010" => droUpdate <= '1'; droDir <= not droInvert; 
    when "1011" => droUpdate <= '1'; droDir <= not droInvert; 
    when "1101" => droUpdate <= '1'; droDir <= not droInvert; 
    when "0100" => droUpdate <= '1'; droDir <= not droInvert; 
    when others => droUpdate <= '0';
   end case;                            --end case droQuadChange

   if (droLoad = '1') then              --if new value
    droLoadVal <= '1';                  --set load value flag
   end if;

   if (droUpdate = '1') then            --if update

    if (droDir = '1') then              --if positive direction
     droVal <= droVal + 1;              --increment position
    else                                --if negative direction
     droVal <= droVal - 1;              --decrement position
    end if;                             --end direction chekc

    if (droEndChk = '1') then           --if using dro for end
     droState <= droCalcDist;           --start end check
    end if;
    
   else                                --if not update
    if (droLoadVal = '1') then         --if new dro value
     droVal <= droInput;               --set new value
     droLoadVal <= '0';                --clear load value flag
    end if;
   end if;                              --end update

   case droState is                     --select state
    when droIdle =>                     --idle
     droDoneInt <= '0';
     droDecelStop <= '0';

    when droCalcDist =>                 --calculate distance
     if ((droUpdate and droEndChk) = '1') then --if using dro for end
      if (drodir = '1') then            --if positive direction
       droDist <= signed(droEnd) - signed(droVal); --dist for pos Dir
      else                              --if negative direction
       droDist <= signed(droVal) - signed(droEnd); --dist for neg dir
      end if;
      droState <= droChkDisable;
     end if;                            --end direction check

    when droChkDisable =>               --check for decel disable
     if (droDist < signed(decelLimit)) then
      droDecelStop <= '1';
      droState <= droChkDone;
     end if;
     
    when droChkDone =>                     --check for done
     if (droDist < to_signed(0, droBits)) then
      droDoneInt <= '1';
      droState <= droDoneWait;
     end if;

     when droDoneWait =>
     if (syncState = syncIdle) then
      droState <= droIdle;
     end if;

    when others =>
     droState <= droIdle;
   end case;                            --end case droState
  
   -- ********** jog and mpg **********

   -- if (jogMode(1) = '1') then           --if enabled mpg mode

   --  mpgQuadChange := (lastA(1) xor lastA(0)) or
   --                   (lastB(1) xor lastB(0)); --quadrature change

   --  if (mpgQuadChange = '0') then          --if no quadrature change
   --   -- if (delta < deltaMax) then
   --   --  delta <= delta + 1;
   --   -- end if;
   --   mpgQuadUpdate <= '0';
   --  else                                --if quadrature change
   --   mpgQuadState <= lastB(1) & lastA(1) & lastB(0) & lastA(0); --direction

   --   case (mpgQuadState) is
   --    when "0001" => mpgQuadUpdate <= '1'; mpgDir <= jogInvert;
   -- -- when "0111" => mpgQuadUpdate <= '1'; mpgDir <= jogInvert;
   -- -- when "1110" => mpgQuadUpdate <= '1'; mpgDir <= jogInvert;
   -- -- when "1000" => mpgQuadUpdate <= '1'; mpgDir <= jogInvert;

   --    when "0010" =>  mpgQuadUpdate <= '1'; mpgDir <= not jogInvert;
   -- -- when "1011" =>  mpgQuadUpdate <= '1'; mpgDir <= not jogInvert;
   -- -- when "1101" =>  mpgQuadUpdate <= '1'; mpgDir <= not jogInvert;
   -- -- when "0100" =>  mpgQuadUpdate <= '1'; mpgDir <= not jogInvert;

   --    when others => mpgQuadUpdate <= '0';
   --   end case;
   --  end if;

   --  if (jogMode(0) = '1') then          --if continuous jog
   --   if (timerClr = '0') then
   --    if (timer = 0) then               --if msec timer zero
   --     timer <= to_unsigned(timerMax, timer'length); --reset to maximum
   --     if (delta /= to_unsigned(deltaMax, delta'length)) then
   --      delta <= delta + 1;             --update delta
   --     end if;
   --    else                              --if non zero
   --     timer <= timer - 1;              --decrement timer
   --    end if;
   --   else
   --    timer <= to_unsigned(timerMax, timer'length); --reset to maximum
   --    delta <= to_unsigned(0, delta'length); --clear delta
   --   end if;
   --  end if;                             --end usec timer

   --  lastA <= lastA(0) & a;
   --  lastB <= lastB(0) & b;

   --  case jogState is                    --select on jogState

   --   when mpgUpdate =>                  --process message update
   --    if (mpgQuadUpdate = '1') then     --if mpg state changed

   --     -- if (mpgDir /= lastMpgDir) then   --if direction changed
   --     --  lastMpgDir <= mpgDir;           --save direction

   --     if (mpgDir /= curDir) then       --if direction changed
   --      stop <= '1';                    --stop
   --      jogState <= mpgDirChange;       --got to direction change state
   --     else                             --if direction the same
   --      mpgEna <= '1';
   --      if (jogMode(0) = '1') then      --if jog mpg continuous

   --       if (delta >= delta0) then
   --        chDiv   <= div0;
   --        mpgDist <= dist0;
   --       elsif (delta >= delta1) then
   --        chDiv   <= div1;
   --        mpgDist <= dist1;
   --       elsif (delta >= delta2) then
   --        chDiv   <= div2;
   --        mpgDist <= dist2;
   --       else
   --        chDiv   <= div3;
   --        mpgDist <= dist3;
   --       end if;

   --       if (syncState = mpgEnabled) then --if moving
   --        mpgDistUpd <= '1';            --update distance
   --       end if;
   --       timerClr <= '1';
   --       jogState <= mpgX;
   --      else
   --       jogState <= mpgMove;
   --      end if;
   --     end if;                          --end direction change

   --    else                              --if not update

   --    end if;                           --end update

   --   when mpgDirChange =>               --direction change
   --    if (syncState = syncIdle) then    --if syncAccel in idle state
   --     stop <= '0';                     --clear stop flag
   --     if (backlash = 0) then           --if no backlash
   --      jogState <= mpgMove;            --go to move state
   --     else                             --if backlash
   --      jogDir <= mpgDir;
   --      backlashActive <= '1';
   --      -- distLoad <= '1';
   --      mpgEna <= '1';
   --      jogState <= mpgBacklash;
   --     end if;
   --    end if;

   --   when mpgBacklash =>                --backlash
   --    if (syncState = doneWait) then    --if move done
   --     mpgEna <= '0';
   --     backlashActive <= '0';
   --     jogState <= mpgUpdate;
   --    -- elsif (syncState /=syncIdle) then
   --    --  distLoad <= '0';
   --    end if;

   --   when mpgMove =>
   --    if (syncState = doneWait) then    --if move done
   --     mpgEna <= '0';
   --     jogState <= mpgUpdate;
   --    -- elsif (syncState /=syncIdle) then
   --    --  distLoad <= '0';
   --    end if;

   --   when mpgX =>                       --
   --    timerClr <= '0';
   --    jogState <= mpgX1;

   --   when mpgX1 =>
   --    if (syncState = mpgEnabled1) then
   --     mpgDistUpd <= '0';
   --    end if;
   --    if (distCtr = to_unsigned(0, distCtr'length)) then
   --     mpgEna <= '0';
   --     jogState <= mpgUpdate;
   --    end if;

   --   when others => null;
   --  end case;                           --end case jog

   -- -- else                                 --if not mpg mode
   -- --  lastMpgDir <= dirIn;                --update last direction
   -- end if;                              --enabled

   if ((synStepLast = '0') and (synStepTmp = '1')) then --if stepping
    -- if ((locDisable = '0') and (backlashActive = '0')) then --enabled
    if (locDisable = '0') then          --if loc updates not disabled
     if (cmdDir = '1') then             --if forward
      loc <= loc + 1;                   --increment location
     else                               --if backwards
      loc <= loc - 1;                   --decrement location
     end if;
    end if;
   else
    if (locUpdate) then                 --if time to update
     locUpdate <= false;                --clear update flag
     loc <= locVal;                     --set new location
    end if;
   end if;

   synStepLast <= synStepTmp;

  end if;                               --end rising_edge
 end process;

end Behavioral;
