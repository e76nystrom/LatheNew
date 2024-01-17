-- Create Date:    09:00:00 12/12/2019

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RegDef.all;
use work.IORecord.all;

entity FreqGenCtr is
 generic(opBase    : unsigned;
         freqBits  : positive;
         countBits : positive;
         syncBits  : positive := 13);
 port (
  clk      : in  std_logic;
  inp      : in  DataInp;
  ena      : in  std_logic;
  syncOut  : out std_logic := '0';
  pulseOut : out std_logic := '0'
  );
end FreqGenCtr;

architecture Behavioral of FreqGenCtr is

 type fsm is (idle, run, updCount, chkCount, done);
 signal state : fsm := idle;
 
 signal freqVal       : unsigned(freqBits-1 downto 0);
 signal freqCounter   : unsigned(freqBits-1 downto 0) :=  (others => '0');

 signal countVal      : unsigned(countBits-1 downto 0);
 signal outputCounter : unsigned(countBits-1 downto 0) := (others => '0');

 signal syncActive    : std_logic;
 signal syncVal       : unsigned(syncBits-1 downto 0) := (others => '0');
 signal syncCounter   : unsigned(syncBits-1 downto 0) := (others => '0');

 signal countLoad     : std_logic;

begin

 freqReg : entity work.ShiftOp
  generic map(opVal => opBase + F_Ld_Dbg_Freq,
              n     => freqBits)
  port map (
   clk  => clk,
   inp  => inp,
   data => freqVal);

 countReg : entity work.ShiftOpLoad
  generic map(opVal  => opBase + F_Ld_Dbg_Count,
              n      => countBits)
  port map (
   clk  => clk,
   inp  => inp,
   load => countLoad,
   data => countVal);

 synctReg : entity work.ShiftOp
  generic map(opVal  => opBase + F_Ld_Sync_Count,
              n      => syncBits)
  port map (
   clk  => clk,
   inp  => inp,
   data => syncVal);

 syncActive <= '1' when (syncVal /= (syncBits-1 downto 0 => '0')) else '0';

 freqCtr: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if (inp.op = opBase + F_Ld_Dbg_Freq) then --if changing frequency
    state <= idle;                      --return to idle state
   else
    case state is
     when idle =>                        --idle
      if (ena = '1') then
       outputCounter <= countVal;
       freqCounter <= freqVal;
       syncCounter <= syncVal;
       state <= run;
      end if;

     when run =>                        --run
      if (ena = '0') then               --if enable cleared
       state <= idle;                   --return to idle state
      else
       if (freqCounter = (freqBits-1 downto 0 => '0')) then --if zero
        freqCounter <= freqVal;         --reload counter
        pulseOut <= '1';                --activate frequency pulse

        if ((syncActive = '1') and
            (syncCounter = (syncBits-1 downto 0 => '0'))) then
         syncOut <= '1';
        end if;

        state <= updCount;
       else                             --if counter non zero
        pulseOut <= '0';                --clear output pulse
        freqCounter <= freqCounter - 1; --count down
       end if;
      end if;

     when updCount =>                   --update count
      freqCounter <= freqCounter - 1;   --count down
      pulseOut <= '0';                  --clear output pulse
      
      if (syncActive = '1') then
       if (syncCounter = (syncBits-1 downto 0 => '0')) then
        syncCounter <= syncVal;         --start count again
       else
        syncCounter <= syncCounter - 1; --count sync Puls
       end if;
       syncOut <= '0';
      end if;
      
      if (outputCounter = (countBits-1 downto 0 => '0')) then --count zero

       state <= run;                    --return to run state
      else                              --if count non zero
       outputCounter <= outputCounter - 1; --count down
       state <= chkCount;               --adancee to check count state
      end if;

     when chkCount =>                   --check count
      freqCounter <= freqCounter - 1;   --count down

      if (outputCounter /= (countBits-1 downto 0 => '0')) then --non zero
       state <= run;                    --continue in run state
      else                              --if count zero
       state <= done;                   --wait for ena to clear
      end if;

     when done =>                       --done
      if (ena = '0') then               --if enable cleared
       state <= idle;                   --return to idle state
      end if;

      if (countLoad = '1') then         --if count loaded
       state <= idle;                   --restart with new counters
      end if;

    end case;
   end if;
  end if;
 end process freqCtr;

end Behavioral;
