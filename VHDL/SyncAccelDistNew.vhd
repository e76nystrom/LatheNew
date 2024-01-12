--******************************************************************************
library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.RegDef.all;
use work.IORecord.all;
use work.DbgRecord.all;
use work.FpgaLatheBitsRec.all;

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
  curDir     : in std_logic;            --current directin
  locDisable : in std_logic;            --disable location update

  axisIn     : in  AxisInRec;           --axis input signals
  axisCtl    : in  AxisCtlRec;          --axis control bits
  axisStat   : out axisStatusRec;       --axis status output

  droQuad    : in std_logic_vector(1 downto 0);

  dbg        : out SyncAccelDbg;
  dout       : out SyncData;
  dirOut     : out std_logic := '0';    --direction out
  synStep    : out std_logic := '0'     --output step pulse
  );
end SyncAccelDist;

architecture Behavioral of SyncAccelDist is

 -- state machine

 type SyncFsm is (syncInit, syncIdle, chDirect, enabled, updAccel, checkAccel, clkWait,
                  distWait);
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
   when others      => return("0000");
  end case;
  return("0000");
 end;

 type accelFsm is (accelInactive, accelActive, atSpeed, decelActive);
 signal accelState : accelFsm := accelInactive;

 signal droEndChk : std_logic;
 signal distMode  : std_logic;
 signal cmdDir    : std_logic;

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

 signal moveDone    : std_logic := '0';
 signal distZero    : std_logic := '0';
 signal doneHome    : std_logic := '0';
 signal doneLimit   : std_logic := '0';
 signal doneProbe   : std_logic := '0';

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
 signal droDone      : std_logic := '0';
 signal droLoad      : std_logic := '0';
 signal droLoadVal   : std_logic := '0';

 signal inHome       : std_logic;
 signal inMinus      : std_logic;
 signal inPlus       : std_logic;
 signal inProbe      : std_logic;

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

 locvalreg : entity work.ShiftOpLoad
  generic map(opVal  => opBase + F_Ld_Loc,
              n      => locBits)
  port map (
   clk   => clk,
   inp   => inp,
   load  => locLoad,
   data  => locVal);

 sum_out : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Sum,
              n       => synBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => sum,
   dout   => dout.sum
   );

 accelSum_Out : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Accel_Sum,
              n       => synBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => accelSUm,
   dout   => dout.accelSum
   );

 accelCtr_out : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Accel_Ctr,
              n       => countBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => accelCounter,
   dout   => dout.accelCtr
   );

 xPos_Shift : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_XPos,
              n       => posBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => xPos,
   dout   => dout.xPos
   );

 yPos_Shift : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_YPos,
              n       => posBits,
              outBits => outBits)
  port map (
   clk => clk,
   oRec   => oRec,
   data => yPos,
   dout => dout.yPos
   );

 DistShiftOut : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Dist,
              n       => distBits,
              outBits => outBits)
  port map (
   clk => clk,
   oRec   => oRec,
   data => distCtr,
   dout => dout.dist
   );
 
 LocShiftOut : entity work.ShiftOutNS
  generic map(opVal   => opBase + F_Rd_Loc,
              n       => locBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => loc,
   dout   => dout.loc
   );

 droShiftOut : entity work.ShiftOutNS
  generic map(opVal   => opBase + F_Rd_Dro,
              n       => droBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => unsigned(droVal),
   dout   => dout.dro
   );

 dirOut <= cmdDir;
 
 AccelShiftOut : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Accel_Steps,
              n       => distBits,
              outBits => outBits)
  port map (
   clk    => clk,
   oRec   => oRec,
   data   => accelSteps,
   dout   => dout.accelSteps
   );

 dbg.ena     <= ena;
 dbg.done    <= moveDone;
 dbg.distCtr <= std_logic(distCtr(0));
 dbg.loc     <= std_logic(loc(0));

 distzero <= '1' when (distCtr = 0) else '0';

 axisStat.axDone      <= moveDone;

 axisStat.axDistZero  <= distZero;
 axisStat.axDoneDro   <= droDone;
 axisStat.axDoneHome  <= doneHome;
 axisStat.axDoneLimit <= doneLimit;
 axisStat.axDoneProbe <= doneProbe;

 axisStat.axInHome    <= inHome;
 axisStat.axInMinus   <= inMinus;
 axisStat.axInPlus    <= inPlus;
 axisStat.axInProbe   <= inProbe;
 axisStat.axInFlag    <= (inHome or inMinus or inPlus or inProbe);

 droEndChk <= axisCtl.ctlDroEnd;
 distMode  <= axisCtl.ctlDistMode;
 cmdDir    <= axisCtl.ctlDir;
 
 syn_process: process(clk)

 begin
  
  if (rising_edge(clk)) then            --if clock active

   inHome  <= axisIn.axHome;
   inMinus <= axisIn.axMinus;
   inPlus  <= axisIn.axPlus;
   inProbe <= axisIn.axProbe;

   if ((axisCtl.ctlDistMode = '1') and
       (loadDist = '1')) then           --dist upd mode and update
    distReLoad <= '1';                  --set distance reload flag
   end if;

   if (locLoad = '1') then              --if new location
    locUpdate <= true;                  --set to load
   end if;

   if (init = '1') then                 --if initialization
    moveDone <= '0';                    --clear done
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
     -- moveDone <= '0';                 --clear move done
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

     if ((ena = '1') and                --if enabled
         (axisCtl.ctlChDirect = '1')) then --if ch controls step
       distCtr <= distVal;              --initialize distance counter
       syncState <= chDirect;           --go to ch direct state
     else                               --if step generation
      if (ena = '1') then               --if enabled
       distCtr <= distVal;              --initialize distance counter
       accelState <= accelActive;       --start acceleration
       syncState <= enabled;            --go to enabled state
      end if;
     end if;

    --chDirect
    when chDirect => --***********************************************
     if ((ena = '0') or (axisCtl.ctlChDirect = '0')) then --if disabled
      syncState <= syncInit;            --return to init state        
     else                               --if active

      if (distZero = '0') then          --if not done

       synStepTmp <= ch;                --copy ch to step
       if ((synStepLast = '0') and (synStepTmp = '1')) then --if stepping
        synStep <= '1';                 --output step
        distctr <= distCtr - 1;         --count off distance
       else                             --done stepping
        synStep <= '0';                 --clear step
       end if;

      else                              --if done
       synStep <= '0';                  --clear step
       moveDone <= '1';                 --move done
       syncState <= syncInit;           --return to init state        
      end if;

     end if;

    --enabled
    when enabled => --************************************************

     -- if (stop = '1') then               --if stop for mpg
     --  syncState <= syncInit;            --go to init state
     -- end if;

     synStep <= '0';                    --clear output step

     if ((ena = '0') or (extDone= '1')) then --if enable cleared
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

     if (axisCtl.ctlHome = '1') then
      if (axisCtl.ctlHomePol = '1') then
       doneHome <= inHome;
      else
       doneHome <= not inHome;
      end if;
     end if;

     doneProbe <= inProbe and axisCtl.ctlProbe;
     doneLimit <= (inMinus or inPlus) and axisCtl.ctlUseLimits;

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

      if (doneLimit or doneHome or doneProbe) = '1' then
       moveDone <= '1';                 --set done flag
       syncState <= syncInit;           --return to init state
      end if;

      if (droEndChk = '0') then         --if not using dro for end

       if (distZero = '0') then         --if not to distance
        syncState <= enabled;           --return to enabled state
       else                             --if distance 0

        if (distMode = '0') then        --if in distance mode
         moveDone <= '1';               --set done flag
         syncState <= syncInit;         --return to init state
        else                            --if distance update mode
         syncState <= distWait;         --wait for distance update
        end if;          

       end if;

      else                              --if using dro for end

       if (droDone = '0') then          --if not done
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

    when others => --*************************************************
     syncState <= syncInit;             --set to init

   end case;                            --end case sync state

   -- ********** dro  **********

   droA <= droA(0) & droQuad(0);
   droB <= droB(0) & droQuad(1);

   droQuadState <= droB(1) & droA(1) & droB(0) & droA(0);
   
   case (droQuadState) is
    when "0001" => droUpdate <= '1'; droDir <= '0';
    when "0111" => droUpdate <= '1'; droDir <= '0';
    when "1110" => droUpdate <= '1'; droDir <= '0';
    when "1000" => droUpdate <= '1'; droDir <= '0';
    when "0010" => droUpdate <= '1'; droDir <= '1';
    when "1011" => droUpdate <= '1'; droDir <= '1';
    when "1101" => droUpdate <= '1'; droDir <= '1';
    when "0100" => droUpdate <= '1'; droDir <= '1';
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
     droDone <= '0';
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
      droDone <= '1';
      droState <= droDoneWait;
     end if;

     when droDoneWait =>
     if (syncState = syncIdle) then
      droState <= droIdle;
     end if;

    when others =>
     droState <= droIdle;
   end case;                            --end case droState
  
   if ((synStepLast = '0') and (synStepTmp = '1')) then --if stepping
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
