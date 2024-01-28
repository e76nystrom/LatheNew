library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.all;

entity IndexClocks is
 generic (opBase         : unsigned;
          indexClockBits : positive;
          turnCountBits  : positive := 24;
          encScaleBits   : positive := 12;
          encCountBits   : positive := 16;
          outBits        : positive);
 port (
  clk     : in  std_logic;
  inp     : in  DataInp;
  oRec    : in  DataOut;
  axisEna : in  std_logic;
  enc     : in  std_logic;
  index   : in  std_logic;
  dout    : out indexData
  );
end IndexClocks;

architecture behavioral of  IndexClocks is


 signal lastIndex     : std_logic := '0';
 signal lastEnc       : std_logic := '0';
 signal active        : std_logic := '0';
 signal clockCounter  : unsigned(indexClockBits-1 downto 0) := (others => '0');
 signal clockReg      : unsigned(indexClockBits-1 downto 0) := (others => '0');

 signal turnCount     : unsigned(turnCountBits-1 downto 0) := (others => '0');

 signal encScaleVal   : unsigned(encScaleBits-1 downto 0) := (others => '0');
 signal encScaleCount : unsigned(encScaleBits-1 downto 0) := (others => '0');
 signal encCounter    : unsigned(encCountBits-1 downto 0) := (others => '0');
 signal encCountVal   : unsigned(encCountBits-1 downto 0) := (others => '0');

 signal axisEnaLast   : std_logic;

 signal indexLE : std_logic;
 signal encLe   : std_logic;

begin

 indexOut : entity work.ShiftOutN
  generic map (opVal   => opBase + F_Rd_Index_Clks,
               n       => indexClockBits,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => clockReg,
   dout => dout.index
   );

 encCount : entity work.ShiftOp
  generic map (opVal  => opBase + F_Ld_Enc_Count,
               n      => encScaleBits)
  port map (
   clk   => clk,
   inp   => inp,
   data  => encScaleVal
   );

 encOut : entity work.ShiftOutN
  generic map (opVal   => opBase + F_Rd_Encoder_Clks,
               n       => encCountBits,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => encCountVal,
   dout => dout.encoder
   );

 turnOut : entity work.ShiftOutN
  generic map (opVal   => opBase + F_Rd_Turn_Count,
               n       => turnCountBits,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => turnCount,
   dout => dout.turnCount
   );

 indexLE <= '1' when ((index = '1') and (lastIndex = '0')) else '0';
 encLE   <= '1' when ((enc   = '1') and (lastenc   = '0')) else '0';

 clockProc: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock edge

   lastIndex   <= index;                --update last values
   lastEnc     <= enc;
   axisEnaLast <= axisEna;

   if (active = '1' ) then              --if active

    -- *** encoder leading edge
    if (encLE = '1') then               --if encoder rising edge

     if (encScaleCount = 0) then        --if encoder scaler zero
      encScaleCount <= encScaleVal;     --reload scaler
      encCountVal   <= encCounter;      --save count value
      encCounter    <= (others => '0'); --reset counter
     else                               --if not time to reset
      encCounter <= encCounter + 1;     --keep counting
      encScaleCount <= encScaleCount - 1; --update scaler
     end if;

    else                                --if not encodeer rising edge

     if (encCounter = (encCountBits-1 downto 0 => '1')) then --if overflow
      active       <= '0';              --clear everything
      encCounter   <= (others => '0');
      clockReg     <= (others => '0');
      clockCounter <= (others => '0');
     else                               --if no overflow
      encCounter <= encCounter + 1;     --keep counting
     end if;

    end if;                             --encoder rising edge

    -- index leading edge
    if (indexLE = '1') then             --if index rising edge
     clockReg     <= clockCounter;      --save to read register
     clockCounter <= (others => '0');   --reset counter
    else                                --if not rising edge
     clockCounter <= clockCounter + 1;  --update clock count
    end if;                             --index rising edge

    if (axisEna = '1') then             --if axis enabled

     if (axisEnaLast = '0') then        --rising edge of axis enable
      turnCount <= (others => '0');     --reset counter
     else
      if (encLE = '1') then             --if encoder leading edge
       turnCount <= turnCount + 1;      --update turn count for encoder pulse
      end if;

     end if;                            --axis enabled
     
    end if;                             --index leading edge

   else                                 --if not active
    if (indexLE = '1') then             --wait for index pulse
     active <= '1';                     --set to active
    end if;
   end if;                              --active

  end if;                               --end clock edge
 end process clockProc;
 
end behavioral;
