-- Create Date:    09:25:00 01/25/2015

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.all;

entity SyncAccelNew is
 generic (opBase    : unsigned := x"00";
          synBits   : positive := 32;
          posBits   : positive := 18;
          countBits : positive := 18;
          outBits   : positive := 32);
 port (
  clk : in std_logic;
  inp          : in DataInp;
  oRec         : in DataOut;
  init         : in std_logic;          --reset
  ena          : in std_logic;          --enable operation
  decel        : in std_logic;
  ch           : in std_logic;
  dout         : out SpindleData;
  decelDone    : out std_logic := '0';
  synStep      : out std_logic := '0'
  );
end SyncAccelNew;

architecture Behavioral of SyncAccelNew is

 type SyncFsm is (idle, enabled, updAccel, encWait);
 signal syncState : SyncFsm := idle;

 type AccelFsm is (accelInactive, accelActive, atSpeed, decelSlow, decelActive);
 signal accelState : AccelFsm := accelInactive;

 signal d      : unsigned(synBits-1 downto 0);
 signal incr1  : unsigned(synBits-1 downto 0);
 signal incr2  : unsigned(synBits-1 downto 0);
 signal accel  : unsigned(synBits-1 downto 0);

 alias opD          : unsigned is F_Ld_Sp_D;
 alias opIncr1      : unsigned is F_Ld_Sp_Incr1;
 alias opIncr2      : unsigned is F_Ld_Sp_Incr2;
 alias opAccel      : unsigned is F_Ld_Sp_Accel_Val;
 alias opAccelMax   : unsigned is F_Ld_Sp_Accel_Max;

 signal xpos        : unsigned(posBits-1 downto 0) := (others => '0');
 signal ypos        : unsigned(posBits-1 downto 0) := (others => '0');
 signal sum         : unsigned(synBits-1 downto 0) := (others => '0');
 alias  sumNeg      : std_logic is sum(synBits-1);
 signal accelMax    : unsigned(synBits-1 downto 0);
 signal accelMaxTmp : std_logic_vector(synBits-1 downto 0);
 signal accelSum    : unsigned(synBits-1 downto 0) := (others => '0');

 signal synStepTmp : std_logic := '0';

begin

 -- dout <= xPosDout or yPosDout or sumDout or accelSumDout or accelCtrDout;

 dreg : entity work.ShiftOp
  generic map (opVal => opBase + opD,
               n     => synBits)
  port map (
   clk  => clk,
   inp  => inp,
   data => d
   );

 incr1reg : entity work.ShiftOp
  generic map (opVal => opBase + opIncr1,
               n     => synBits)
  port map (
   clk  => clk,
   inp  => inp,
   data => incr1
   );

 incr2reg : entity work.ShiftOp
  generic map (opVal => opBase + opIncr2,
               n     => synBits)
  port map (
   clk  => clk,
   inp  => inp,
   data => incr2
   );

 accelreg : entity work.ShiftOp
  generic map (opVal => opBase + opAccel,
               n     => synBits)
  port map (
   clk  => clk,
   inp  => inp,
   data => accel
   );

 accelMax <= unsigned(accelMaxTmp);

 accelMaxReg : entity work.ctlReg
  generic map (opVal => opBase + opAccelMax,
               n     => synBits)
  port map (
   clk  => clk,
   inp  => inp,
   data => accelMaxTmp
   );

 sumOut : entity work.ShiftOutN
  generic map (opVal   => opBase + F_Rd_Sp_Sum,
               n       => synBits,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => sum,
   dout => dout.sum
   );

 accelSumOut : entity work.ShiftOutN
  generic map (opVal   => opBase + F_Rd_Sp_Accel_Sum,
               n       => synBits,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => accelSum,
   dout => dout.accelSum
   );

 accelMaxOut : entity work.ShiftOutN
  generic map (opVal   => opBase + F_Rd_Sp_Accel_Max,
               n       => synBits,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => accelMax,
   dout => dout.accelMax
   );

 xPosOut : entity work.ShiftOutN
  generic map (opVal   => opBase + F_Rd_Sp_XPos,
               n       => posBits,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => xPos,
   dout => dout.xPos
   );

 yPosOut : entity work.ShiftOutN
  generic map (opVal   => opBase + F_Rd_Sp_YPos,
              n       => posBits,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => yPos,
   dout => dout.yPos
   );

 syn_process: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if (init = '1') then                 --initialize variables

    sum          <= d;
    accelSum     <= (others => '0');
    xPos         <= (others => '0');
    yPos         <= (others => '0');

    decelDone    <= '0';

    synStep      <= '0';                --clear output step
    synStepTmp   <= '0';
    syncState    <= idle;               --set to idle state
    accelState   <= accelInactive;      --set accel to inactive

   else                                 --if initialize not set

    case syncState is                   --select state
     when idle =>                       --idle
      if (ena = '1') then
       syncState  <= enabled;
       accelState <= accelActive;       --start acceleration
      end if;

     when enabled =>                    --enabled
      synStep <= '0';

      if (ena = '0') then               --if enable cleared
       decelDone <= '0';                --clear deceldone
       syncState <= idle;               --return to idle state
      else
       if (decel = '1') then           --if decel
        accelState <= decelActive;     --start deceleration
       end if;

       if (ch = '1') then               --if encoder
        xPos <= xPos + 1;

        if (sumNeg = '1') then          --if negative (sign bit set)
         sum <= sum + incr1;
        else
         sum <= sum + incr2;
         yPos <= yPos + 1;
         synStepTmp <= '1';             --enable step pulse
        end if;

        syncState <= updAccel;
       end if;
      end if;

     when updAccel =>                   --update acceleration
      sum <= sum + accelSum;

      case accelState is                --select accelState

       --inactive
       when accelInactive => 		--##############
        null;

       --acceleration
       when accelActive => 		--##############
        if (accelSum < accelMax) then   --if not at max
         accelSum <= accelSum + accel;  --update accel
        else                            --at max
         accelSum   <= accelMax;        --set to maximum
         accelState <= atSpeed;         --set state at speed
        end if;

       --at speed
       when atSpeed => 			--##############
        if (accelSum = accelMax) then   --if no change
         null;
        else
         if (accelSum > accelMax) then --if lower speed
          accelState <= decelSlow;     --set state to slow down
         else                          --if raise speed
          accelState <= accelActive;   --set state to accelerate
         end if;
        end if;

       --decel slow down
       when decelslow => 		--##############
        if (accelSum > accelMax) then
         accelSum <= accelSum - accel;
        else
         accelSum   <= accelMax;
         accelState <= atSpeed;
        end if;

       --deceleration
       when decelActive => 		--##############
        if (accelSum > accel) then      --if okay to continue
         accelSum <= accelSum - accel;  --subtract accel
        else                            --if doene
         decelDone  <= '1';             --set done flag
         accelSum   <= (others => '0'); --clear accel sum
         accelState <= accelInactive;   --set state inactive
        end if;

       --others
       when others => 			--##############
        accelState <= accelInactive;
      end case;                          --end accelState

      syncState <= encWait;

     when encWait =>                    --wait for encoder inactive
      synStep <= synStepTmp;            --output step
      synStepTmp <= '0';                --clear tmp value
      if (ch = '0') then                --if encoder pulse clear
       syncState <= enabled;            --return to enabled state
      end if;

     when others =>
      syncState <= idle;
    end case;                           --end syncState

   end if;                              --end init
  end if;                               --end rising_edge
 end process;

end Behavioral;
