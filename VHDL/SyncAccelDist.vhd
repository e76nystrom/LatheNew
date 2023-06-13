--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:25:00 01/25/2015 
-- Design Name: 
-- Module Name:    SyncAccelDist - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.RegDef.ALL;

entity SyncAccelDist is
 generic (opBase :    unsigned := x"00";
          opBits :    positive := 8;
          synBits :   positive := 32;
          posBits :   positive := 18;
          countBits : positive := 18;
          distBits :  positive := 18;
          outBits :   positive := 32);
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
  jogCmd :  in std_logic;               --jog command mode
  ch :      in std_logic;               --step input clock

  done :    inout boolean := false;     --done move
  dout :    out   std_logic := '0';     --read data out
  synStep : out   std_logic := '0'      --output step pulse
  );
end SyncAccelDist;

architecture Behavioral of SyncAccelDist is

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

 type fsm is (idle, enabled, updAccel, checkAccel, doneWait);
 signal state : fsm := idle;

 type accelFsm is (accelInactive, accelActive, atSpeed, decelActive);
 signal accelState : accelFsm := accelInactive;

 -- constant registers

 signal d      : unsigned(synBits-1 downto 0); --initial sum
 signal incr1  : unsigned(synBits-1 downto 0); --
 signal incr2  : unsigned(synBits-1 downto 0);
 signal accel  : unsigned(synBits-1 downto 0);

 -- accel registers
 
 signal accelCount :   unsigned(countBits-1 downto 0);
 signal accelCounter : unsigned(countBits-1 downto 0) := (others => '0');
 signal accelSum :     unsigned(synBits-1 downto 0) := (others => '0');
 signal accelSteps :   unsigned(distBits-1 downto 0) := (others => '0'); --accel steps

 -- sync registers

 signal xpos :   unsigned(posBits-1 downto 0) := (others => '0'); --sync in counter
 signal ypos :   unsigned(posBits-1 downto 0) := (others => '0'); --sync out counter
 signal sum :    unsigned(synBits-1 downto 0) := (others => '0'); --sum accumulator
 alias  sumNeg : std_logic is sum(synBits-1);           --sum sign bit

 -- distance registers

 signal distVal :    unsigned(distBits-1 downto 0); --input distance
 signal distCtr :    unsigned(distBits-1 downto 0) := (others => '0'); --current distance
 signal maxDist :    unsigned(distBits-1 downto 0) := (others => '0'); --max distance
 signal loadDist :   std_logic;
 signal distUpdate : boolean := false;

 -- read output signals

 signal xPosDout :       std_logic;     --xPos read output
 signal yPosDout :       std_logic;     --yPos read output
 signal sumDout :        std_logic;     --sum read output
 signal accelSumDout :   std_logic;     --accel sum read output
 signal accelCtrDout :   std_logic;     --accel ctr read output
 signal distDout :       std_logic;     --distance read output
 signal accelStepsDout : std_logic;     --accel stesp read output

 signal synStepTmp : std_logic := '0';

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
 begin
  if (rising_edge(clk)) then            --if clock active
   if (init = '1') then                 --initialize variables

    xPos <= (others => '0');            --clear input count
    yPos <= (others => '0');            --clear output count
    sum <= d;                           --initialize sum
    accelCounter <= (others => '0');    --clear accel clock counter
    accelSum <= (others => '0');        --clear accel sum
    accelSteps <= (others => '0');      --clear accel steps
    accelState <= accelInactive;        --set to inactive state
    distCtr <= distVal;                 --initialize distance counter

    synStep <= '0';                     --clear output step
    synStepTmp <= '0';                  --clear step
    distUpdate <= false;                --clear distance update
    done <= False;                      --clear done
    state <= idle;                      --set to idle state

   else                                 --if initialize not set

    if ((jogCmd = '1') and (loadDist = '1')) then --jog and dist update
     distUpdate <= true;                --set distance update flag
    end if;

    case state is                       --select state

     --idle
     when idle =>

      synStep <= '0';                   --clear output step

      if ((ena = '1') and not done) then --if enabled
       state <= enabled;                --go to enabled state
       accelState <= accelActive;       --start acceleration
      end if;

     --enabled
     when enabled =>

      synStep <= '0';                   --clear output step

      if (ena = '0') or extDone then    --if enable cleared
       state <= idle;                   --return to idle state
      elsif (ch = '1') then             --if input clock
       xPos <= xPos + 1;                --count input clock

       if (sumNeg = '1') then           --if negative (sign bit set)
        sum <= sum + incr1;             --update for negative
       else                             --if positive
        sum <= sum + incr2;             --update for positive
        yPos <= yPos + 1;               --update output count
        synStepTmp <= '1';              --enable step pulse

        distCtr <= distCtr - 1;         --count off distance
       
        if (accelState = accelActive) then --if accel active
         accelSteps <= accelSteps + 1;     --add an accel stesp
        elsif (accelState = decelActive) then --if decel active
         accelSteps <= accelSteps - 1;  --subtract an accel step
        end if;

       end if;                          --sumNeg
       state <= updAccel;
      end if;                           --ch

     --update acceleration
     when updAccel =>

      if (distUpdate) then              --if distance update
       distCtr <= distCtr + distVal;    --add to current distance
      end if;

      sum <= sum + accelSum;            --update sum value with accel

      case accelState is                --select accelState
       when accelInactive =>            --inactive
        null;

       when accelActive =>              --acceleration
        if (accelCounter < accelCount) then
         accelSum <= accelSum + accel;
         accelCounter <= accelCounter + 1;
        end if;

        if (accelSteps >= distCtr) then --if steps ge dist
         accelState <= decelActive;     --start decelerate
        end if;

       when decelActive =>              --deceleration
        accelSum <= accelSum - accel;
        accelCounter <= accelCounter - 1;

       when atSpeed =>                  --at speed
        if (accelSteps >= distCtr) then --if steps ge dist
         accelState <= decelActive;     --start decelerate
        end if;

       when others =>                   --others
        accelState <= accelInactive;
      end case;                         --accelState

      state <= checkAccel;              --check acclerations

     -- check acceleration
     when checkAccel =>

      if (distUpdate) then              --if distance update
       distUpdate <= false;             --clear update flag
       if (distCtr > maxDist) then      --if distance out of range
        distCtr <= maxDist;             --set to maximum
       end if;
      end if;

      case accelState is                --select accelState
       when accelActive =>              --acceleration
        if (accelCounter >= accelCount) then
         accelState <= atSpeed;
        end if;

       when atSpeed =>                  --at speed
        null;

       when decelActive =>              --deceleration
        if (distCtr > accelSteps) then
         accelState <= accelActive;
        end if;

        if (accelCounter = to_unsigned(0, countBits)) then
         accelState <= accelInactive;
        end if;

       when others =>                   --others
        accelState <= accelInactive;
      end case;                         --accelState
      state <= doneWait;

     --wait for ch inactive
     when doneWait =>

      synStep <= synStepTmp;            --output step
      synStepTmp <= '0';                --clear tmp value
      if (ch = '0') then                --if change flag cleared
       if (distCtr /= 0) then           --if not to distance
        state <= enabled;               --return to enabled state
       else                             --if distance counter zero
        if (jogCmd = '0') then          --if not jogging
         done <= true;                  --set done flag
         state <= idle;                 --return to idle state
        else                            --if jog mode
         if (distUpdate) then           --if distance update
          state <= enabled;             --return to enabled state
         end if;
        end if;
       end if;
      end if;

     when others =>                     --others
      state <= idle;                    --set to idle

    end case;                           --state
    
   end if;                              --end init
  end if;                               --end rising_edge
 end process;

end Behavioral;
