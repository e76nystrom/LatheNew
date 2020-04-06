--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:25:00 01/25/2015 
-- Design Name: 
-- Module Name:    SyncAccel - Behavioral 
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

entity SyncAccel is
 generic (opBase : unsigned := x"00";
          opBits : positive := 8;
          synBits : positive := 32;
          posBits : positive := 18;
          countBits : positive := 18;
          outBits : positive := 32);
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in boolean;
  op : in unsigned (opBits-1 downto 0);
  load : in boolean;
  dshiftR : in boolean;
  opR : in unsigned (opBits-1 downto 0);
  copyR : in boolean;
  init : in std_logic;                  --reset
  ena : in std_logic;                   --enable operation
  decel : in std_logic;
  decelDisable : in boolean;
  ch : in std_logic;
  dir : in std_logic;
  dout : out std_logic := '0';
  accelActive : out std_logic := '0';
  decelDone : out boolean := false;
  synStep : out std_logic := '0'
  );
end SyncAccel;

architecture Behavioral of SyncAccel is

 component ShiftOp is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive);
  port (
   clk : in std_logic;
   shift : in boolean;
   op : in unsigned (opBits-1 downto 0);
   din : in std_logic;
   data : inout  unsigned (n-1 downto 0));
 end component;

 component ShiftOutN is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive;
          outBits : positive);
  port (
   clk : in std_logic;
   dshift : in boolean;
   op : in unsigned (opBits-1 downto 0);
   copy : in boolean;
   data : in unsigned(n-1 downto 0);
   dout : out std_logic
   );
 end Component;

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
 
 dreg: ShiftOp
  generic map(opVal => opBase + opD,
              opBits => opBits,
              n => synBits)
  port map (
   clk => clk,
   shift => dshift,
   op => op,
   din => din,
   data => d);

 incr1reg: ShiftOp
  generic map(opVal => opBase + opIncr1,
              opBits => opBits,
              n => synBits)
  port map (
   clk => clk,
   shift => dshift,
   op => op,
   din => din,
   data => incr1);

 incr2reg: ShiftOp
  generic map(opVal => opBase + opIncr2,
              opBits => opBits,
              n => synBits)
  port map (
   clk => clk,
   shift => dshift,
   op => op,
   din => din,
   data => incr2);

 accelreg: ShiftOp
  generic map(opVal => opBase + opAccel,
              opBits => opBits,
              n => synBits)
  port map (
   clk => clk,
   shift => dshift,
   op => op,
   din => din,
   data => accel);

 accelCountReg: ShiftOp
  generic map(opVal => opBase + opAccelCount,
              opBits => opBits,
              n => countBits)
  port map (
   clk => clk,
   shift => dshift,
   op => op,
   din => din,
   data => accelCount);

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
