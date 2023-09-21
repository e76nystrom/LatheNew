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

  inp         : in DataInp;
  -- din : in std_logic;
  -- dshift : in boolean;
  -- op : in unsigned (opBits-1 downto 0);
  -- load : in boolean;

  oRec        : in DataOut;
  -- dshiftR : in boolean;
  -- opR : in unsigned (opBits-1 downto 0);
  -- copyR : in boolean;

  init         : in std_logic;          --reset
  ena          : in std_logic;          --enable operation
  decel        : in std_logic;
  decelDisable : in boolean;
  ch           : in std_logic;
  dir          : in std_logic;
  dout         : out std_logic := '0';
  accelActive  : out std_logic := '0';
  decelDone    : out boolean := false;
  synStep      : out std_logic := '0'
  );
end SyncAccelNew;

architecture Behavioral of SyncAccelNew is

 type fsm is (idle, enabled, updAccel, doneWait);
 signal state : fsm := idle;

 signal d      : unsigned(synBits-1 downto 0);
 signal incr1  : unsigned(synBits-1 downto 0);
 signal incr2  : unsigned(synBits-1 downto 0);
 signal accel  : unsigned(synBits-1 downto 0);

 signal accelCount : unsigned(countBits-1 downto 0);
 signal accelCounter : unsigned(countBits-1 downto 0) := (others => '0');

 alias opD     : unsigned is F_Ld_D;
 alias opIncr1 : unsigned is F_Ld_Incr1;
 alias opIncr2 : unsigned is F_Ld_Incr2;
 alias opAccel : unsigned is F_Ld_Accel_Val;
 alias opAccelCount : unsigned is F_Ld_Accel_Count;

 signal xpos : unsigned(posBits-1 downto 0) := (others => '0');
 signal ypos : unsigned(posBits-1 downto 0) := (others => '0');
 signal sum :  unsigned(synBits-1 downto 0) := (others => '0');
 alias sumNeg : std_logic is sum(synBits-1);
 signal accelSum : unsigned(synBits-1 downto 0) := (others => '0');

 signal xPosDout : std_logic;
 signal yPosDout : std_logic;
 signal sumDout : std_logic;
 signal accelSumDout : std_logic;
 signal accelCtrDout : std_logic;

 signal synStepTmp : std_logic := '0';

begin

 dout <= xPosDout or yPosDout or sumDout or accelSumDout or accelCtrDout;
 
 dreg : entity work.ShiftOp
  generic map(opVal => opBase + opD,
              n =>     synBits)
  port map (
   clk  => clk,
   inp  => inp,
   -- shift => dshift,
   -- op => op,
   -- din => din,
   data => d);

 incr1reg : entity work.ShiftOp
  generic map(opVal => opBase + opIncr1,
              n     => synBits)
  port map (
   clk  => clk,
   inp  => inp,
   -- shift => dshift,
   -- op => op,
   -- din => din,
   data => incr1);

 incr2reg : entity work.ShiftOp
  generic map(opVal => opBase + opIncr2,
              n     => synBits)
  port map (
   clk  => clk,
   inp  => inp,
   -- shift => dshift,
   -- op => op,
   -- din => din,
   data => incr2);

 accelreg : entity work.ShiftOp
  generic map(opVal => opBase + opAccel,
              n     => synBits)
  port map (
   clk  => clk,
   inp  => inp,
   -- shift => dshift,
   -- op => op,
   -- din => din,
   data => accel);

 accelCountReg : entity work.ShiftOp
  generic map(opVal => opBase + opAccelCount,
              n     => countBits)
  port map (
   clk  => clk,
   inp  => inp,
   -- shift => dshift,
   -- op => op,
   -- din => din,
   data => accelCount);

 sum_out : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Sum,
              n       => synBits,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   -- dshift => dshiftR,
   -- op => opR,
   -- copy => copyR,
   data => sum,
   dout => sumDout
   );

 accelSum_Out : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Accel_Sum,
              n       => synBits,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   -- dshift => dshiftR,
   -- op => opR,
   -- copy => copyR,
   data => accelSUm,
   dout => accelSumDout
   );

 accelCtr_out : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Accel_Ctr,
              n       => countBits,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   -- dshift => dshiftR,
   -- op => opR,
   -- copy => copyR,
   data => accelCounter,
   dout => accelCtrDout
   );

 xPos_Shift : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_XPos,
              n       => posBits,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   -- dshift => dshiftR,
   -- op => opR,
   -- copy => copyR,
   data => xPos,
   dout => xPosDout
   );

 yPos_Shift : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_YPos,
              n       => posBits,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   -- dshift => dshiftR,
   -- op => opR,
   -- copy => copyR,
   data => yPos,
   dout => yPosDout
   );

 syn_process: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if (init = '1') then                 --initialize variables

    xPos <= (others => '0');
    yPos <= (others => '0');
    sum <= d;
    accelCounter <= (others => '0');
    accelSum <= (others => '0');

    accelActive <= '0';
    decelDone <= false;

    synStep <= '0';                     --clear output step
    synStepTmp <= '0';
    state <= idle;                      --set to idle state

   else                                 --if initialize not set

    case state is                       --select state
     when idle =>                       --idle
      if (ena = '1') then
       state <= enabled;
      end if;

     when enabled =>                    --enabled
      synStep <= '0';
      if (ena = '0') then               --if enable cleared
       decelDone <= false;              --clear deceldone
       state <= idle;                   --return to idle state
      elsif (ch = '1') then
       xPos <= xPos + 1; 
       if (sumNeg = '1') then           --if negative (sign bit set)
        sum <= sum + incr1;
       else
        sum <= sum + incr2;
        yPos <= yPos + 1;
        synStepTmp <= '1';              --enable step pulse
       end if;
       state <= updAccel;
      end if;

     when updAccel =>                   --update acceleration
      sum <= sum + accelSum;
      if (decel = '0') then             --if accelerating
       if (accelCounter /= accelCount) then
        accelSum <= accelSum + accel;
        accelCounter <= accelCounter + 1;
        accelActive <= '1';
       else
        accelActive <= '0';
       end if;
      else                              --if decelerating
       accelActive <= '0';
       if (not decelDisable) then
        if (accelCounter /= to_unsigned(0, countBits)) then
         accelSum <= accelSum - accel;
         accelCounter <= accelCounter - 1;
        else
         decelDone <= true;
        end if;
       end if;
      end if;
      state <= doneWait;

     when doneWait =>                   --clr enable wait for ch inactive
      synStep <= synStepTmp;            --output step
      synStepTmp <= '0';                --clear tmp value
      if (ch = '0') then                --if change flag cleared
       state <= enabled;                --return to enabled state
      end if;

     when others =>
      state <= idle;
    end case;
    
   end if;                              --end init
  end if;                               --end rising_edge
 end process;

end Behavioral;
