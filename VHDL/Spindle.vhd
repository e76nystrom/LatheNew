library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.regdef.all;

entity Spindle is
 generic (opBase : unsigned;
          opBits : positive;
          synBits : positive;
          posBits : positive;
          countBits : positive;
          outBits : positive);
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in boolean;
  op : in unsigned(opBits - 1 downto 0);
  load : in boolean;
  dshiftR : in boolean;
  opR : in unsigned(opBits-1 downto 0);
  copyR : in boolean;
  ch : in std_logic;
  mpgQuad : in std_logic_vector(1 downto 0);
  jogInvert : in std_logic;
  eStop : in std_logic;
  spActive : out std_logic := '0';
  stepOut : out std_logic := '0';
  dirOut : out std_logic := '0';
  dout : out std_logic := '0'
  );
end Spindle;

architecture Behavioral of Spindle is

 type fsm is (idle, run, done);
 signal state : fsm;

 signal syncInit : std_logic := '0';
 signal syncEna : std_logic := '0';

 signal synStep : std_logic;
 signal jogStep : std_logic;

 signal jogDir : std_logic;
 signal jogEnable : std_logic;

 signal decelDone : boolean;

 signal decel : std_logic;

 signal doutSync : std_logic;
 signal doutJog : std_logic;

 constant spCtlSize : integer := 4;
 signal spCtlReg : unsigned(spCtlSize-1 downto 0);
 alias spInit       : std_logic is spCtlreg(0); -- x01 spindle init
 alias spEna        : std_logic is spCtlreg(1); -- x02 spindle enable
 alias spDir        : std_logic is spCtlreg(2); -- x04 spindle direction
 alias spJogEnable  : std_logic is spCtlreg(3); -- x08 spindle jog enable

begin
 
 dOut <= doutSync or doutJog;
 
 spindleCtlReg : entity work.CtlReg
  generic map(opVal => opBase + F_Ld_Sp_Ctl,
              opb => opBits,
              n => spCtlSize)
  port map (
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   load => load,
   data => spCtlReg);

 AxisSyncAccel : entity work.SyncAccel
  generic map (opBase => opBase + F_Sp_Sync_Base,
               opBits => opBits,
               synBits => synBits,
               posBits => posBits,
               countBits => countBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   load => load,
   dshiftR => dshiftR,
   opR => opR,
   copyR => copyR,
   init => syncInit,
   ena => syncEna,
   decel => decel,
   decelDisable => false,
   ch => ch,
   dir => '0',
   dout => doutSync,
   accelActive => open,
   decelDone => decelDone,
   synStep => synStep
   );

 AxisJog : entity work.Jog
  generic map (opBase => opBase + F_Sp_Jog_Base,
               opBits => opBits,
               outBits => outBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   load => load,
   dshiftR => dshiftR,
   opR => opR,
   copyR => copyR,
   quad => mpgQuad,
   enable => jogEnable,
   jogInvert => jogInvert,
   currentDir => jogDir,
   jogStep => jogStep,
   jogDir => jogDir,
   jogUpdLoc => open,
   dout => doutJog
   );

 jogEnable <= '1' when (eStop = '0') and (spJogEnable = '1') else '0';
 spActive <= '1' when state /= idle else '0';
 stepOut <= jogStep when spJogEnable = '1' else synstep;
 dirOut <= jogDir when spJogEnable = '1' else spDir;

 spindleRun: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active

   if (eStop = '1') then
    syncInit <= '0';
    syncEna <= '0';
    state <= idle;
   elsif (spInit = '1') then
    syncInit <= '1';
    state <= idle;
   else

    case state is
     when idle =>
      syncInit <= '0';
      if (spEna = '1') then
       syncInit <= '1';
       state <= run;
      end if;

     when run =>
      syncInit <= '0';
      syncEna <= '1';
      if (spEna = '0') then
       decel <= '1';
       state <= done;
      end if;

      when done =>
      if (decelDone) then
       syncEna <= '0';
       state <= idle;
      end if;
      
     when others =>
      state <= idle;
    end case;
   end if;

  end if;
 end process;

end Behavioral;




























