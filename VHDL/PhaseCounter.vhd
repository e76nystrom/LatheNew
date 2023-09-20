--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:16:04 01/29/2015 
-- Design Name: 
-- Module Name:    PhaseCounter - Behavioral 
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

use work.regdef.all;

entity PhaseCounter is
 generic (opBase : unsigned;
          opBits : positive := 8;
          phaseBits : positive := 16;
          totalBits : positive := 32;
          outBits : positive);
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in boolean;
  op : in unsigned (opBits-1 downto 0);
  load : in boolean;
  dshiftR : in boolean;
  opR : in unsigned (opBits-1 downto 0);
  copyR : in boolean;
  init : in std_logic;
  genSync : in std_logic;
  ch : in std_logic;
  sync : in std_logic;
  dir : in std_logic;
  dout : out std_logic  := '0';
  syncOut : out std_logic := '0');
end PhaseCounter;

architecture Behavioral of PhaseCounter is

 type fsm is (idle, updPhase);
 signal state : fsm := idle;

 --signal totalInc : std_logic;
 signal lastSyn : std_logic_vector(1 downto 0);

 signal phaseSyn : unsigned(phaseBits-1 downto 0) :=
  (others => '0'); --phase value for sync pulse
 signal phaseCtr : unsigned(phaseBits-1 downto 0) :=
  (others => '0'); --current phase
 signal phaseVal : unsigned(phaseBits-1 downto 0); --pulses in one rotation

 signal dOutPhaseSyn : std_logic;

begin

 dout <= dOutPhaseSyn;

 phaseReg : entity work.ShiftOp
  generic map(opVal => opBase + F_Ld_Phase_len,
              opBits => opBits,
              n => phaseBits)
  port map (
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   data => phaseVal);

 phaseSynOut : entity work.ShiftOutN
  generic map(opVal => opBase + F_Rd_Phase_Syn,
              opBits => opBits,
              n => phaseBits,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dShiftR,
   op => opR,
   copy => copyR,
   data => phaseSyn,
   dout => doutPhaseSyn
   );
 
 --totalCounter: UpCounter
 -- generic map(totalBits)
 -- port map (
 --  clk => clk,
 --  clr => init,
 --  ena => totalInc,
 --  counter => totphase);

 -- update phase counter

 phase_ctr: process(clk)
 begin
  if (rising_edge(clk)) then
   if (init = '1') then                 --if load
    state <= idle;                      --set sart state
    --totalInc <= '0';
    syncOut <= '0';
    phaseCtr <= (phaseBits-1 downto 0 => '0');
   else                                 --if not initializing
    if ((lastSyn(0) = '1') and (lastSyn(1) = '0')) then --if rising edge
     phaseSyn <= phaseCtr;               --save phase counter
     if (genSync = '0') then             --if generating sync
      syncOut <= '1';                    --output sync pulse
     end if;
    else                                --if not rising edge
     if (genSync = '0') then            --if generating sync
      syncOut <= '0';                   --clear sync pulse
     end if;
    end if;
    lastSyn <= lastSyn(0) & sync;
    case state is
     when idle =>                       --idle
      if (genSync = '1') then           --if generating sync
       syncOut <= '0';                  --clear sync
      end if;
      if (ch = '1') then                --if clock
       --if (run_sync ='1') then
       -- totalInc <= '1';
       --end if;
       state <= updPhase;               --update phase
      end if;

     when updPhase =>                   --update phase
      --totalInc <= '0';
      
      if (dir = '1') then               --if forward
       if (phaseCtr = phaseVal) then    --if at maximum
        if (genSync = '1') then         --if generating sync
         syncOut <= '1';                --set sync pulse
        end if;
        phaseCtr <= (phaseBits-1 downto 0 => '0'); --reset to zero
       else                             --if not at maximum
        phaseCtr <= phaseCtr + 1;       --incrementt phase coounter
       end if;
      else                              --if reverse
       if (phaseCtr = 0) then
        if (genSync = '1') then
         syncOut <= '1';
        end if;
        phaseCtr <= phaseVal;
       else
        phaseCtr <= phaseCtr - 1;
       end if;
      end if;
      state <= idle;                    --return to idle state
    end case;
   end if;
  end if;
 end process;
 
 --phase_ctr: process(clk)
 --begin
 -- if (rising_edge(clk)) then           --if clock active
 --  lastSyn <= lastSyn(0) & sync;
 --  if (init = '1') then                 --if time to load
 --   phaseCtr <= (phaseBits-1 downto 0 => '0');
 --   totphase <= (totalBits-1 downto 0 => '0');
 --  else
 --   if (ch = '1') then                  --if clock active and change
 --    if (run_sync = '1') then           --if synchronized mode
 --     totphase <= totphase + 1;         --count total phase
 --    end if;

 --    if (dir = '1') then                --if encoder turning forward
 --     if (phaseCtr = phaseVal) then     --if at maximum count
 --      phaseCtr <= (phaseBits-1 downto 0 => '0'); --reset to zero
 --      syncOut <= '1';                 --output sync pulse
 --     else                              --if not at maximum
 --      phaseCtr <= phaseCtr + 1;        --increment counter
 --      syncOut <= '0';                 --clear sync pulse
 --     end if;
 --    else                               --if encoder turning backwards
 --     if (phaseCtr = 0) then            --if at minimum
 --      phaseCtr <= phaseVal;            --reset to maximum
 --      syncOut <= '1';                 --ouput sync pulse
 --     else                              --if not at minimum
 --      phaseCtr <= phaseCtr - 1;        --count down
 --      syncOut <= '0';                 --reset sync pulse
 --     end if;
 --    end if;
 --   end if;
 --  end if;
 -- end if;
 --end process;

end Behavioral;
