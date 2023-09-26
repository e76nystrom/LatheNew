library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RegDef.all;
use work.IORecord.all;
use work.FpgaLatheBitsRec.all;
use work.FpgaLatheBitsFunc.all;

entity Jog is
 generic (opBase  : unsigned (opb-1 downto 0) := x"00";
          outBits : positive := 32);
 port (
  clk        : in std_logic;

  inp        : DataInp;
  oRec       : DataOut;

  quad       : in std_logic_vector(1 downto 0);
  enable     : in std_logic;
  jogInvert  : in std_logic;
  currentDir : in std_logic;

  jogStep    : out std_logic := '0';
  jogDir     : out std_logic := '0';
  jogUpdLoc  : out std_logic := '1';
  dout       : out std_logic
  );
end Jog;

architecture Behavioral of Jog is

 alias a : std_logic is quad(0);
 alias b : std_logic is quad(1);

 signal lastA : std_logic_vector(1 downto 0) := (others => '0');
 signal lastB : std_logic_vector(1 downto 0) := (others => '0');
 signal dir :   std_logic := '0';

 signal update : std_logic := '0';

 constant timerMax : natural := 10;
 signal timer      : natural range 0 to timerMax-1 := timerMax-1;
 signal uSec       : std_logic := '0';

 constant deltaBits : positive := 16;
 constant distBits :  positive := 12;

 constant deltaMax  : natural := 50000;
 constant slowJog   : natural := 20000;
 constant fastSteps : natural := 14;

 signal deltaTimer : unsigned(deltaBits-1 downto 0) := (others => '0');
 signal jogTimer   : unsigned(deltaBits-1 downto 0) := (others => '0');
 signal deltaJog   : unsigned(deltaBits-1 downto 0) := (others => '0');

 signal jogDist    : unsigned(distBits-1 downto 0) := (others => '0');
 signal jogInc     : unsigned(distBits-1 downto 0) := (others => '0');

 signal jogActive : boolean := False;
 signal activeDir : std_logic := '0';

 signal incDist      : unsigned(distBits-1 downto 0);
 signal backlashDist : unsigned(distBits-1 downto 0);

 signal jogReg : jogVec;
 signal jogR   : jogRec;

begin

 dout <= '0';

 jogCtlReg : entity work.ctlReg 
  generic map(opVal => opBase + F_Ld_Jog_ctl,
              n =>     jogSize)
  port map (
   clk  => clk,
   inp  => inp,
   data =>  jogReg);

  jogR <= jogToRec(jogReg);

 jogIncReg: entity work.ShiftOp
  generic map(opVal =>  opBase + F_Ld_Jog_Inc,
              n =>      distBits)
  port map (
   clk  => clk,
   inp  => inp,
   data =>  incDist);

 jogBacklashReg: entity work.ShiftOp
  generic map(opVal =>  opBase + F_Ld_Jog_Back,
              n =>      DistBits)
  port map (
   clk  => clk,
   -- din =>   din,
   -- op =>    op,
   -- shift => dshift,
   inp  => inp,
   data => backlashDist);

 -- dout <= posDout;

 -- LocShiftOut : ShiftOutNS
 --  generic map(opVal => opBase + F_Rd_Dro,
 --              opBits => opBits,
 --              n => droBits,
 --              outBits => outBits)
 --  port map (
 --   clk => clk,
 --   dshift => dshiftR,
 --   op => opR,
 --   copy => copyR,
 --   data => posVal,
 --   dout => posDout
 --   );

 jogProc : process(clk)
  variable quadState : std_logic_vector(3 downto 0);
  variable ch : std_logic;
 begin
  if (rising_edge(clk)) then            --if time to process

   if ((enable = '1') and (uSec = '1')) then --if enabled and next uSec

    ch := (lastA(1) xor lastA(0)) or (lastB(1) xor lastB(0)); --input change
    if (ch = '1') then
     quadState := lastB(1) & lastA(1) & lastB(0) & lastA(0); --direction
     case (quadState) is
      when "0001" => dir <= jogInvert; update <= '1';
      -- when "0111" => dir <= jogInvert; update <= '1';
      -- when "1110" => dir <= jogInvert; update <= '1';
      -- when "1000" => dir <= jogInvert; update <= '1';
      when "0010" => dir <= not jogInvert; update <= '1';
      -- when "1011" => dir <= not jogInvert; update <= '1';
      -- when "1101" => dir <= not jogInvert; update <= '1';
      -- when "0100" => dir <= not jogInvert; update <= '1';
      when others => update <= '0';
     end case;
    else
     update <= '0';
    end if;

    lastA <= lastA(0) & a;
    lastB <= lastB(0) & b;

    if (update = '0') then              --if no update
     
     if (deltaTimer < deltaMax-1) then  --if timer in range
      deltaTimer <= deltaTimer + 1;     --increment timer
     end if;
     
     if (jogActive) then                --if timer active

      if (jogTimer < jogInc) then       --if time to jog
       if (jogDist /= 0) then           --if not done
        jogTimer <= deltaJog;           --reset timer
        jogDist <= jogDist - 1;         --update distance
        jogStep <= '1';                 --time to step set flag
       else                             --if done jogging
        jogActive <= false;             --disable jog
        jogUpdLoc <= '1';               --set to update
       end if;
      else                              --if not time
       jogTimer <= jogTimer - JogInc;   --count down
      end if;

     else                               --if timer not active
      jogStep <= '0';                   --clear step
      jogDist <= to_unsigned(0, distBits); --clear distance
     end if;                            --end jog active
     
    else                                --if input update
     update <= '0';                     --clear input update flag
     deltaJog <= deltaTimer;            --save time interval
     if (not jogActive) then            --if not active
      jogTimer <= deltaTimer;            --initialize timer
     end if;
     deltaTimer <= to_unsigned(0, deltaBits); --reset timer
     
     if (dir = currentDir) then         --if direction same

      if (jogR.jogContinuous = '1') then --if continuous jog
       if (deltaJog <= slowJog) then    --if fast jog
        jogInc <= to_unsigned(fastSteps, distBits); --set number of jog pulses
        jogDist <= jogDist + fastSteps; --add to distance
       else                             --if slow jog
        jogInc <= to_unsigned(fastSteps, distBits); --set to one jog pulse
        jogDist <= jogDist + 1;         --add to distance
       end if;
       jogActive <= true;
      else                              --if incremental jog

       if (not jogActive) then          --if jog not active
        jogInc <= to_unsigned(fastSteps, distBits); --set increment
        jogDist <= incDist;             --set distance
        jogActive <= true;              --set to active
       end if;                          --end jog active

      end if;                           --end continuous incremental

     else                               --if direction change

      if (jogActive) then               --if active
       jogActive <= false;              --stop
      else                              --if not active
       if (jogR.jogBacklash = '1') then --if backlash
        jogInc <= to_unsigned(fastSteps, distBits); --set speed
        jogDist <= backlashDist;        --set distance
        jogUpdLoc <= '0';               --disable location update
        jogActive <= true;              --set to active
       end if;                          --end backlash
       jogDir <= dir;                   --set current direction
      end if;                           --end active

     end if;                            --end direction change
     
    end if;                             --end change

   else                                 --if not enabled or not usec
    jogDir <= currentDir;               --keep direction current
    jogStep <= '0';                     --clear step flag
   end if;                              --end enable and usec
   
   if (timer = 0) then                  --if usec timer zero
    timer <= timerMax - 1;              --reset to maximum
    uSec <= '1';                        --output usec pulse
   else                                 --if non zero
    timer <= timer - 1;                 --decrement timer
    uSec <= '0';                        --clear usec pulse
   end if;                              --end usec timer

  end if;                               --end rising edge
 end process;

end Behavioral;
