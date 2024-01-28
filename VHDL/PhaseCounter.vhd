-- Create Date:    19:16:04 01/29/2015 
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.regDef.all;
use work.IORecord.all;

entity PhaseCounter is
 generic (opBase : unsigned;
          phaseBits : positive := 16;
          totalBits : positive := 32;
          outBits : positive);
 port (
  clk     : in  std_logic;
  inp     : in  DataInp;
  oRec    : in  DataOut;
  init    : in  std_logic;
  genSync : in  std_logic;
  enc     : in  std_logic;
  sync    : in  std_logic;
  dir     : in  std_logic;
  dout    : out std_logic := '0';
  syncOut : out std_logic := '0');
end PhaseCounter;

architecture Behavioral of PhaseCounter is

 type fsm is (idle, updPhase);
 signal state : fsm := idle;

 signal lastEnc : std_logic := '0';
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
  generic map (opVal => opBase + F_Ld_Phase_len,
               n     => phaseBits)
  port map (
   clk  => clk,
   inp  => inp,
   data => phaseVal);

 phaseSynOut : entity work.ShiftOutN
  generic map (opVal   => opBase + F_Rd_Phase_Syn,
               n       => phaseBits,
               outBits => outBits)
  port map (
   clk  => clk,
   oRec => oRec,
   data => phaseSyn,
   dout => doutPhaseSyn
   );

 -- update phase counter

 phase_ctr: process(clk)
 begin
  if (rising_edge(clk)) then
   if (init = '1') then                 --if load
    state    <= idle;                   --set sart state
    syncOut  <= '0';
    phaseCtr <= (phaseBits-1 downto 0 => '0');
   else                                 --if not initializing
    
    if ((lastSyn(0) = '1') and (lastSyn(1) = '0')) then --if rising edge
     phaseSyn <= phaseCtr;               --save phase counter

     if (genSync = '0') then            --if generating sync
      syncOut <= '1';                   --output sync pulse
     end if;
    else                                --if not rising edge
     if (genSync = '0') then            --if generating sync
      syncOut <= '0';                   --clear sync pulse
     end if;
    end if;

    lastSyn <= lastSyn(0) & sync;
    lastEnc <= enc;

    case state is
     when idle =>                       --idle
      if (genSync = '1') then           --if generating sync
       syncOut <= '0';                  --clear sync
      end if;

      if (enc = '1' and lastEnc = '0') then --if clock
       state <= updPhase;               --update phase
      end if;

     when updPhase =>                   --update phase
      
      if (dir = '1') then               --if forward
       if (phaseCtr = phaseVal) then    --if at maximum
        phaseCtr <= (others => '0');    --reset to zero

        if (genSync = '1') then         --if generating sync
         syncOut <= '1';                --set sync pulse
        end if;

       else                             --if not at maximum
        phaseCtr <= phaseCtr + 1;       --incrementt phase coounter
       end if;

      else                              --if reverse
       if (phaseCtr = 0) then
        phaseCtr <= phaseVal;

        if (genSync = '1') then
         syncOut <= '1';
        end if;

       else
        phaseCtr <= phaseCtr - 1;
       end if;

      end if;
      state <= idle;                    --return to idle state
    end case;
   end if;
  end if;
 end process;

end Behavioral;
