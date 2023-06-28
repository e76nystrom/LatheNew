--******************************************************************************
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

use work.RegDef.ALL;
use work.Common.All;

entity SyncAccelDistJog is
 generic (opBase    : unsigned := x"00";
          opBits    : positive := 8;
          synBits   : positive := 32;
          posBits   : positive := 18;
          countBits : positive := 18;
          distBits  : positive := 18;
          outBits   : positive := 32);
 port (
  clk :     in std_logic;

  din :     in std_logic;
  dshift :  in boolean;
  op :      in unsigned (opBits-1 downto 0);
  load :    in boolean;

  dshiftR : in boolean;
  opR :     in unsigned (opBits-1 downto 0);
  copyR :   in boolean;

  init :    in std_logic;               --reset
  ena :     in std_logic;               --enable operation
  extDone : in boolean;                 --external done input
  ch :      in std_logic;               --step input clock

  quad :    in std_logic_vector(1 downto 0);
  jogInvert :  in std_logic;
  jogMode : in std_logic_vector(1 downto 0);

  done :    inout boolean := false;     --done move
  dout :    out   std_logic := '0';     --read data out
  synStep : out   std_logic := '0'      --output step pulse
  );
end SyncAccelDistJog;

architecture Behavioral of SyncAccelDistJog is

 component ShiftOp is
  generic(opVal :  unsigned;
          opBits : positive;
          n :      positive);
  port (
   clk :   in std_logic;
   shift : in boolean;
   op :    in unsigned (opBits-1 downto 0);
   din :   in std_logic;
   data :  inout  unsigned (n-1 downto 0));
 end component;

 component ShiftOpLoad is
  generic(opVal :  unsigned;
          opBits : positive;
          n :      positive);
  port (
   clk :   in    std_logic;
   shift : in    boolean;
   op :    in    unsigned (opBits-1 downto 0);
   din :   in    std_logic;
   load :  out   std_logic;
   data :  inout unsigned (n-1 downto 0));
 end component;

 component ShiftOutN is
  generic(opVal :   unsigned;
          opBits :  positive;
          n :       positive;
          outBits : positive);
  port (
   clk :    in  std_logic;
   dshift : in  boolean;
   op :     in  unsigned (opBits-1 downto 0);
   copy :   in  boolean;
   data :   in  unsigned(n-1 downto 0);
   dout :   out std_logic
   );
 end Component;

 -- state machine

 type SyncFsm is (syncInit, idle, enabled, updAccel, checkAccel, clkWait,
                  doneWait, mpgEnabled, mpgEnabled1);
 signal syncState : syncFsm := syncInit;

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

 signal distVal  : unsigned(distBits-1 downto 0); --input distance
 signal distCtr  : unsigned(distBits-1 downto 0) := (others => '0');
 signal maxDist  : unsigned(distBits-1 downto 0) := (others => '0');
 signal backlash : unsigned(distBits-1 downto 0) := (others => '0');

 signal loadDist   : std_logic := '0';
 signal distUpdate : boolean := false;

 -- read output signals

 signal xPosDout       : std_logic;     --xPos read output
 signal yPosDout       : std_logic;     --yPos read output
 signal sumDout        : std_logic;     --sum read output
 signal accelSumDout   : std_logic;     --accel sum read output
 signal accelCtrDout   : std_logic;     --accel ctr read output
 signal distDout       : std_logic;     --distance read output
 signal accelStepsDout : std_logic;     --accel stesp read output

 signal synStepTmp : std_logic := '0';

 -- ********** mpg jog definitions **********

 -- mpg sync accel control signals

 signal stop     : std_logic := '0';    --stop sync accel
 signal mpgEna   : std_logic := '0';    --enable sync accel from mpg
 -- signal distLoad : std_logic := '0';    --load distance

 -- mpg state definitions

 type jog_fsm is (mpgUpdate, mpgDirChange, mpgBacklash, mpgMove, mpgX, mpgX1);
 signal jogState : jog_fsm;         --jog state variable

 -- mpg quadrature input

 alias a : std_logic is quad(0);
 alias b : std_logic is quad(1);

 signal lastA : std_logic_vector(1 downto 0) := (others => '0');
 signal lastB : std_logic_vector(1 downto 0) := (others => '0');

 signal update     : std_logic := '0';
 signal dir        : std_logic := '0';

 signal lastDir        : std_logic := '0';
 signal backlashActive : std_logic := '0';

 constant timerMax  : natural := 30; --50000;
 constant timerBits : natural := integer(ceil(log2(real(timerMax))));
 signal   timer     : unsigned(timerBits-1 downto 0) := (others => '0');
 signal   timerClr  : std_logic := '0';
 signal   chDiv     : unsigned(timerBits-1 downto 0) := (others => '0');
 signal   chCtr     : unsigned(timerBits-1 downto 0) := (others => '0');

 constant deltaMax  : natural := 50;
 constant deltaBits : natural := integer(ceil(log2(real(deltaMax))));
 signal   delta     : unsigned(deltaBits-1 downto 0) := (others => '0');

 constant delta0    : natural := 30;
 constant delta1    : natural := 15;
 constant delta2    : natural := 4;

 constant div0      : natural := 1;
 constant div1      : natural := 3;
 constant div2      : natural := 5;
 constant div3      : natural := 7;

 constant dist0     : natural := 1;
 constant dist1     : natural := 2;
 constant dist2     : natural := 4;
 constant dist3     : natural := 8;

 constant mpgDistMax  : natural := 200;
 constant mpgDistBits : natural := integer(ceil(log2(real(mpgDistMax))));
 signal   mpgDistUpd  : std_logic := '0';
 signal   mpgDist     : unsigned(mpgDistBits-1 downto 0) := (others => '0');
 signal   mpgDistCtr  : unsigned(mpgDistBits-1 downto 0) := (others => '0');

begin

 dout <= xPosDout or yPosDout or sumDout or accelSumDout or accelCtrDout or
         distDout or accelStepsDout;

 dreg: ShiftOp
  generic map(opVal =>  opBase + F_Ld_D,
              opBits => opBits,
              n =>      synBits)
  port map (
   clk =>   clk,
   shift => dshift,
   op =>    op,
   din =>   din,
   data =>  d);

 incr1reg: ShiftOp
  generic map(opVal =>  opBase + F_Ld_Incr1,
              opBits => opBits,
              n =>      synBits)
  port map (
   clk => clk,
   shift => dshift,
   op => op,
   din => din,
   data => incr1);

 incr2reg: ShiftOp
  generic map(opVal => opBase + F_Ld_Incr2,
              opBits => opBits,
              n => synBits)
  port map (
   clk => clk,
   shift => dshift,
   op => op,
   din => din,
   data => incr2);

 accelreg: ShiftOp
  generic map(opVal => opBase + F_Ld_Accel_Val,
              opBits => opBits,
              n => synBits)
  port map (
   clk => clk,
   shift => dshift,
   op => op,
   din => din,
   data => accel);

 accelCountReg: ShiftOp
  generic map(opVal => opBase + F_Ld_Accel_Count,
              opBits => opBits,
              n => countBits)
  port map (
   clk => clk,
   shift => dshift,
   op => op,
   din => din,
   data => accelCount);

  distShiftOp : ShiftOpLoad
  generic map(opVal => opBase + F_Ld_A_Dist,
              opBits => opBits,
              n => distBits)
  port map(
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   load => loadDist,
   data => distVal
   );

  maxDistShiftOp : ShiftOp
  generic map(opVal => opBase + F_Ld_Max_Dist,
              opBits => opBits,
              n => distBits)
  port map(
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   data => maxDist
   );

  BacklashShiftOp : ShiftOp
  generic map(opVal => opBase + F_Ld_Backlash,
              opBits => opBits,
              n => distBits)
  port map(
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   data => backlash
   );

 -- read registers

 sum_out : ShiftOutN
  generic map(opVal => opBase + F_Rd_Sum,
              opBits => opBits,
              n => synBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftR,
   op => opR,
   copy => copyR,
   data => sum,
   dout => sumDout
   );

 accelSum_Out: ShiftOutN
  generic map(opVal => opBase + F_Rd_Accel_Sum,
              opBits => opBits,
              n => synBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftR,
   op => opR,
   copy => copyR,
   data => accelSUm,
   dout => accelSumDout
   );

 accelCtr_out : ShiftOutN
  generic map(opVal => opBase + F_Rd_Accel_Ctr,
              opBits => opBits,
              n => countBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftR,
   op => opR,
   copy => copyR,
   data => accelCounter,
   dout => accelCtrDout
   );

 xPos_Shift : ShiftOutN
  generic map(opVal => opBase + F_Rd_XPos,
              opBits => opBits,
              n => posBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftR,
   op => opR,
   copy => copyR,
   data => xPos,
   dout => xPosDout
   );

 yPos_Shift : ShiftOutN
  generic map(opVal => opBase + F_Rd_YPos,
              opBits => opBits,
              n => posBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftR,
   op => opR,
   copy => copyR,
   data => yPos,
   dout => yPosDout
   );

 DistShiftOut: ShiftOutN
  generic map(opVal => opBase + F_Rd_A_Dist,
              opBits => opBits,
              n => distBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftR,
   op => opR,
   copy => copyR,
   data => distCtr,
   dout => distDout);

 AccelShiftOut: ShiftOutN
  generic map(opVal => opBase + F_Rd_A_Acl_Steps,
              opBits => opBits,
              n => distBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftR,
   op => opR,
   copy => copyR,
   data => accelSteps,
   dout => accelStepsDout);

 syn_process: process(clk)
  -- variable varSynEna  : boolean  := false;
  -- variable varMpgEna  : boolean  := false;
  -- variable varJogMode : jog_type := jogNone;

  variable quadState  : std_logic_vector(3 downto 0);
  variable quadChange : std_logic;
 begin
  if (rising_edge(clk)) then            --if clock active

   if ((jogMode = "01") and (loadDist = '1')) then --jog and dist update
    distUpdate <= true;                 --set distance update flag
   end if;

   -- varSynEna := (ena = '1')    and (varJogMode = jogNone);
   -- varMpgEna := (mpgEna = '1') and (varJogMode = jogMpg);

   case syncState is                    --select syncState

    -- initialization
    when syncInit =>
     xPos <= (others => '0');           --clear input count
     yPos <= (others => '0');           --clear output count
     sum <= d;                          --initialize sum
     accelCounter <= (others => '0');   --clear accel clock counter
     accelSum <= (others => '0');       --clear accel sum
     accelSteps <= (others => '0');     --clear accel steps
     accelState <= accelInactive;       --set to inactive state
     -- distCtr <= distVal;                --initialize distance counter

     synStep <= '0';                    --clear output step
     synStepTmp <= '0';                 --clear step
     distUpdate <= false;               --clear distance update
     done <= False;                     --clear done
     syncState <= idle;                 --set to idle state

    --idle
    when idle =>

     synStep <= '0';                    --clear output step

     if (((ena = '1')    and (jogMode = "00")) or
         ((mpgEna = '1') and (jogMode = "10"))) then
      syncState <= enabled;             --go to enabled state
      accelState <= accelActive;        --start acceleration
      -- if (distLoad = '1') then
      distCtr <= distVal;
      -- end if;
     elsif ((mpgEna = '1') and (jogMode = "11")) then --if mpg jog
      distCtr <= ((distCtr'length - mpgDist'length-1 downto 0 =>'0') &
                  mpgDist);             --load distance
      chCtr <= to_unsigned(0, chCtr'length); --initialize clock divider
      syncState <= mpgEnabled;          --advance to mpg jog state
     end if;

    --enabled
    when enabled =>

     if (stop = '1') then               --if stop for mpg
      syncState <= syncInit;            --go to init state
     end if;

     synStep <= '0';                    --clear output step

     if (ena = '0') or extDone then     --if enable cleared
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

      end if;                          --sumNeg
      syncState <= updAccel;

     end if;                            --ch

    --update acceleration
    when updAccel =>

     if (distUpdate) then               --if distance update
      distCtr <= distCtr + distVal;     --add to current distance
     end if;

     sum <= sum + accelSum;             --update sum value with accel

     case accelState is                 --select accelState
      when accelInactive =>             --inactive
       null;

      when accelActive =>               --acceleration
       if (accelCounter < accelCount) then
        accelSum <= accelSum + accel;
        accelCounter <= accelCounter + 1;
       end if;

       if (accelSteps >= distCtr) then  --if steps ge dist
        accelState <= decelActive;      --start decelerate
       end if;

      when decelActive =>               --deceleration
       accelSum <= accelSum - accel;
       accelCounter <= accelCounter - 1;

      when atSpeed =>                   --at speed
       if (accelSteps >= distCtr) then  --if steps ge dist
        accelState <= decelActive;      --start decelerate
       end if;

      when others =>                    --others
       accelState <= accelInactive;
     end case;                          --accelState

     syncState <= checkAccel;           --check acclerations

    -- check acceleration
    when checkAccel =>

     if (distUpdate) then               --if distance update
      distUpdate <= false;              --clear update flag
      if (distCtr > maxDist) then       --if distance out of range
       distCtr <= maxDist;              --set to maximum
      end if;
     end if;

     case accelState is                 --select accelState
      when accelActive =>               --acceleration
       if (accelCounter >= accelCount) then
        accelState <= atSpeed;
       end if;

      when atSpeed =>                   --at speed
       null;

      when decelActive =>               --deceleration
       if (distCtr > accelSteps) then
        accelState <= accelActive;
       end if;

       if (accelCounter = to_unsigned(0, countBits)) then
        accelState <= accelInactive;
       end if;

      when others =>                    --others
       accelState <= accelInactive;
     end case;                          --accelState
     syncState <= clkWait;

    -- wait for clock to clear
    when clkWait =>
     synStep <= synStepTmp;             --output step
     synStepTmp <= '0';                 --clear tmp value
     if (ch = '0') then                 --if change flag cleared
      if (distCtr /= 0) then            --if not to distance
       syncState <= enabled;            --return to enabled state
      else
       if (jogMode = "00") then         --if not jogging
        done <= true;                   --set done flag
        syncState <= syncInit;          --return to init state
       else                             --if jog mode
        syncState <= doneWait;          --wait to jog again
       end if;
      end if;
     end if;

    --wait for ch inactive
    when doneWait =>
     if (jogMode = "00") then           --if out of jog mode
      syncState <= syncInit;            --return to init state
     else                               --if jog mode
      if (jogState = mpgUpdate) then    --if jog waiting for an update
       syncState <= syncInit;           --return to init state
      end if;
     end if;

    -- mpg updates
    when mpgEnabled =>
     if (ch = '1') then                 --if clock
      if (chCtr = chDiv) then           --if time to step
       if (distCtr /= 0) then           --if not done
        chCtr <= to_unsigned(0, chCtr'length); --reset counter
        distCtr <= distCtr - 1;         --update distance
        synStep <= '1';                 --set step signal
        syncState <= mpgEnabled1;       --advance to next state
       else                             --if done
        syncState <= syncInit;          --return to init state
       end if;
      else                              --if not time to step
       chCtr <= chCtr + 1;              --increment counter
      end if;
     end if;

    when mpgEnabled1 =>
     synStep <= '0';                    --clear step pulse
     if (mpgDistUpd = '1') then         --if time for a distance update
      distCtr <= distCtr + mpgDist;     --update distance
     end if;
     syncState <= mpgEnabled;           --return to enable state

    when others =>                      --others
     syncState <= syncInit;             --set to init

   end case;                            --state

   if (jogMode(1) = '1') then           --if enabled mpg mode

    quadChange := (lastA(1) xor lastA(0)) or
                  (lastB(1) xor lastB(0)); --quadrature change

    if (quadChange = '0') then          --if no quadrature change
     -- if (delta < deltaMax) then
     --  delta <= delta + 1;
     -- end if;
     update <= '0';
    else                                --if quadrature change
     quadState := lastB(1) & lastA(1) & lastB(0) & lastA(0); --direction

     case (quadState) is
      when "0001" => update <= '1'; dir <= jogInvert;
   -- when "0111" => update <= '1'; dir <= jogInvert;
   -- when "1110" => update <= '1'; dir <= jogInvert;
   -- when "1000" => update <= '1'; dir <= jogInvert;

      when "0010" =>  update <= '1';dir <= not jogInvert;
   -- when "1011" =>  update <= '1';dir <= not jogInvert;
   -- when "1101" =>  update <= '1';dir <= not jogInvert;
   -- when "0100" =>  update <= '1';dir <= not jogInvert;

      when others => update <= '0';
     end case;
    end if;

    if (jogMode(0) = '1') then          --if continuous jog
     if (timerClr = '0') then
      if (timer = 0) then               --if msec timer zero
       timer <= to_unsigned(timerMax, timer'length); --reset to maximum
       if (delta /= to_unsigned(deltaMax, delta'length)) then
        delta <= delta + 1;             --update delta
       end if;
      else                              --if non zero
       timer <= timer - 1;              --decrement timer
      end if;
     else
      timer <= to_unsigned(timerMax, timer'length); --reset to maximum
      delta <= to_unsigned(0, delta'length); --clear delta
     end if;
    end if;                             --end usec timer

    lastA <= lastA(0) & a;
    lastB <= lastB(0) & b;

    case jogState is                    --select on jogState

     when mpgUpdate =>                  --process message update
      if (update = '1') then            --if mpg state changed

       if (dir /= lastDir) then         --if direction changed
        lastDir <= dir;                 --save direction
        stop <= '1';                    --stop
        jogState <= mpgDirChange;       --got to direction change state
       else                             --if direction the same
        mpgEna <= '1';
        if (jogMode(0) = '1') then      --if jog mpg continuous

         if (delta >= to_unsigned(delta0, delta'length)) then
          chDiv   <= to_unsigned(div0, chDiv'length);
          mpgDist <= to_unsigned(dist0, mpgDist'length);
         elsif (delta >= to_unsigned(delta1, delta'length)) then
          chDiv   <= to_unsigned(div1, chDiv'length);
          mpgDist <= to_unsigned(dist1, mpgDist'length);
         elsif (delta >= to_unsigned(delta2, delta'length)) then
          chDiv   <= to_unsigned(div2, chDiv'length);
          mpgDist <= to_unsigned(dist2, mpgDist'length);
         else
          chDiv   <= to_unsigned(div3, chDiv'length);
          mpgDist <= to_unsigned(dist3, mpgDist'length);
         end if;

         if (syncState = mpgEnabled) then --if moving
          mpgDistUpd <= '1';            --update distance
         end if;
         timerClr <= '1';
         jogState <= mpgX;
        else
         jogState <= mpgMove;
        end if;
       end if;                          --end direction change

      else                              --if not update

      end if;                           --end update

     when mpgDirChange =>               --direction change
      if (syncState = idle) then        --if syncAccel in idle state
       stop <= '0';                     --clear stop flag
       if (backlash = 0) then           --if no backlash
        jogState <= mpgMove;            --go to move state
       else                             --if backlash
        backlashActive <= '1';
        -- distLoad <= '1';
        mpgEna <= '1';
        jogState <= mpgBacklash;
       end if;
      end if;

     when mpgBacklash =>                --backlash
      if (syncState = doneWait) then    --if move done
       mpgEna <= '0';
       backlashActive <= '0';
       jogState <= mpgUpdate;
      -- elsif (syncState /= idle) then
      --  distLoad <= '0';
      end if;

     when mpgMove =>
      if (syncState = doneWait) then    --if move done
       mpgEna <= '0';
       jogState <= mpgUpdate;
      -- elsif (syncState /= idle) then
      --  distLoad <= '0';
      end if;

     when mpgX =>                       --
      timerClr <= '0';
      jogState <= mpgX1;

     when mpgX1 =>
      if (syncState = mpgEnabled1) then
       mpgDistUpd <= '0';
      end if;
      if (distCtr = to_unsigned(0, distCtr'length)) then
       mpgEna <= '0';
       jogState <= mpgUpdate;
      end if;

     when others => null;
    end case;

   end if;                              --enabled

  end if;                               --end rising_edge
 end process;

 -- jogProc : process(clk)
 --  variable quadState  : std_logic_vector(3 downto 0);
 --  variable quadChange : std_logic;
 -- -- variable jogType    : jog_type := jogNone;
 -- begin
 --  if (rising_edge(clk)) then            --if time to process

 --  end if;                               --end rising edge

 -- end process;

end Behavioral;
