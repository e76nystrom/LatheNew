library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.all;

entity IndexClocks is
 generic (opBase  : unsigned;
          n       : positive;
          outBits : positive);
 port (
  clk     : in  std_logic;
  inp     : in  DataInp;
  oRec    : in  DataOut;
  axisEna : in  std_logic;
  ch      : in  std_logic;
  index   : in  std_logic;
  dout    : out indexData
  );
end IndexClocks;

architecture behavioral of  IndexClocks is

 constant chCtrBits : positive := n-10;

 signal lastIndex    : std_logic := '0';
 signal lastCh       : std_logic := '0';
 signal active       : std_logic := '0';
 signal clockCounter : unsigned(n-1 downto 0) := (others => '0');
 signal clockReg     : unsigned(n-1 downto 0) := (others => '0');
 signal chCounter    : unsigned(chCtrBits-1 downto 0) := (others => '0');

 signal encClockReg  : unsigned(n-1 downto 0) := (others => '0');

 signal encScaleCount : unsigned(n-1 downto 0) := (others => '0');
 signal encScaleVal   : unsigned(n-1 downto 0) := (others => '0');
 signal encCounter    : unsigned(n-1 downto 0) := (others => '0');
 signal encCountVal   : unsigned(n-1 downto 0) := (others => '0');

 signal turnCount    : unsigned(n-1 downto 0) := (others => '0');
 signal axisEnaLast  : std_logic;

 signal indexLE : std_logic;
 signal chLe    : std_logic;

begin

 indexOut : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Index_Clks,
              n       => n,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => clockReg,
   dout => dout.index
   );

  encCount : entity work.ShiftOp
  generic map(opVal  => opBase + F_Ld_Enc_Count,
              n      => n)
  port map (
   clk   => clk,
   inp   => inp,
   data  => encScaleVal
   );

 encOut : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Encoder_Clks,
              n       => n,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => encCountVal,
   dout => dout.encoder
   );

 turnOut : entity work.ShiftOutN
  generic map(opVal   => opBase + F_Rd_Turn_Count,
              n       => n,
              outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => turnCount,
   dout => dout.turnCount
   );

 indexLE <= '1' when ((index = '1') and (lastIndex = '0')) else '0';
 chLE    <= '1' when ((ch    = '1') and (lastch    = '0')) else '0';

 clockProc: process(clk)
 begin
  if (rising_edge(clk)) then
   lastIndex   <= index;
   lastCh      <= ch;
   axisEnaLast <= axisEna;

   if (active = '1' ) then              --if active

    if (chLE = '1') then                --if encoder rising edge
     chCounter <= (others => '0');       --reset counter

     if (encScaleCount = 0) then        --if encoder scaler zero
      encScaleCount <= encScaleVal;     --reload scaler
      encCountVal <= encCounter;        --save count value
      encCounter <= (others => '0');    --reset counter
     else                               --if not time to reset
      encScaleCount <= encScaleCount - 1; --update scaler
      encCounter <= encCounter + 1;     --update clock counter
     end if;

    else                                --if not rising edge

     encCounter <= encCounter + 1;      --update clock counter

     if (chCounter = (chCtrBits-1 downto 0 => '1')) then --if overflow
      active       <= '0';              --clear everything
      chCounter    <= (others => '0');
      clockReg     <= (others => '0');
      clockCounter <= (others => '0');
     else                               --if no overflow
      chCounter <= chCounter + 1;       --keep counting
     end if;

    end if;                             --encoder rising edge

    if (indexLE = '1') then             --if index rising edge
     clockReg <= clockCounter;
     clockCounter <= (others => '0');
    else
     clockCounter <= clockCounter + 1;
    end if;                             --index rising edge

    if (axisEna = '1') then
     if (axisEnaLast = '0') then
      turnCount <= (others => '0');
     else
      if (chLE = '1') then
       turnCount <= turnCount + 1;
      end if;
     end if;
    end if;

   else                                 --if not active
    if (indexLE = '1') then             --wait for index pulse
     active <= '1';                     --set to active
    end if;
   end if;                              --active

  end if;
 end process clockProc;
 
end behavioral;
