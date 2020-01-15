LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

use work.RegDef.ALL;

entity Axis is
 generic (
  opBase : unsigned;
  opBits : positive := 8;
  synBits : positive;
  posBits : positive;
  countBits : positive;
  distBits : positive := 32;
  locBits : positive;
  outBits : positive;
  dbgBits : positive := 4
  );
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in boolean;
  op : in unsigned(opBits-1 downto 0);
  copy : in boolean;
  load : in boolean;
  extInit : in std_logic;               --reset
  extEna : in std_logic;                --enable operation
  extUpdLoc : in std_logic;
  ch : in std_logic;
  encDir : in std_logic;
  sync : in std_logic;
  dbgOut : out unsigned (dbgBits-1 downto 0) := (others => '0');
  initOut : out std_logic := '0';
  enaOut : out std_logic := '0';
  updLocOut : out std_logic := '0';
  dout : out std_logic := '0';
  stepOut : out std_logic := '0';
  dirOut : out std_logic := '0';
  doneInt : out std_logic := '0'
  );
end Axis;

architecture Behavioral of Axis is

 component CtlReg is
  generic(opVal : unsigned;
          opb : positive;
          n : positive);
  port (
   clk : in std_logic;                   --clock
   din : in std_logic;                   --data in
   op : in unsigned(opb-1 downto 0);     --current reg address
   shift : in boolean;                 --shift data
   load : in boolean;                  --load to data register
   data : inout  unsigned (n-1 downto 0)); --data register
 end Component;

 component SyncAccel is
  generic (opBase : unsigned;
           opBits : positive;
           synBits : positive;
           posBits : positive;
           countBits : positive);
  port (
   clk : in std_logic;
   din : in std_logic;
   dshift : in boolean;
   op : in unsigned (opBits-1 downto 0);
   copy : in boolean;
   load : in boolean;
   init : in std_logic;                  --reset
   ena : in std_logic;                   --enable operation
   decel : in std_logic;
   ch : in std_logic;
   dir : in std_logic;
   dout : out std_logic;
   accelActive : out std_logic;
   accelFlag : out std_logic;
   synStep : out std_logic
   );
 end Component;

 component DistCounter is
  generic (opBase : unsigned;
           opBits : positive;
           distBits : positive;
           outBits : positive);
  Port (
   clk : in  std_logic;
   din : in std_logic;
   dshift : in boolean;
   op : in unsigned(opBits-1 downto 0);  --current reg address
   copy : in boolean;
   load : in boolean;
   init : in std_logic;                  --reset
   step : in std_logic;                  --all steps
   accelFlag : in std_logic;             --acceleration step
   dout : out std_logic;                 --data output
   decel : inout std_logic;              --dist le acceleration steps
   distZero : out std_logic              --distance zero
   );
 end Component;

 component LocCounter is
  generic(opBase : unsigned;
          opBits : positive;
          locBits : positive;
          outBits : positive);
  Port (
   clk : in  std_logic;
   din : in std_logic;          --shift data in
   dshift : in boolean;       --shift clock in
   op : in unsigned(opBits-1 downto 0); --operation code
   copy : in boolean;         --copy location for output
   setLoc : in std_logic;       --set location
   updLoc : in std_logic;       --location update enabled
   step : in std_logic;         --input step pulse
   dir : in std_logic;          --direction
   dout : out std_logic;        --data out
   loc : inout unsigned(locBits-1 downto 0) --current location
   );
 end Component;

 component DataSel4_2 is
  port ( sel : in std_logic;
         a0 : in std_logic;
         a1 : in std_logic;
         a2 : in std_logic;
         a3 : in std_logic;
         b0 : in std_logic;
         b1 : in std_logic;
         b2 : in std_logic;
         b3 : in std_logic;
         y0 : out std_logic;
         y1 : out std_logic;
         y2 : out std_logic;
         y3 : out std_logic
         );
 end Component;

 component DataSel2_1 is
  port (
   sel : in std_logic;
   a : in std_logic;
   b : in std_logic;
   y : out std_logic
   );
 end Component;

--(++ axisCtl
-- axis control register

 constant axisCtlSize : integer := 8;
 signal axisCtlReg : unsigned(axisCtlSize-1 downto 0);
 alias ctlInit    : std_logic is axisCtlreg(0); -- x01 reset flag
 alias ctlStart   : std_logic is axisCtlreg(1); -- x02 start
 alias ctlBacklash : std_logic is axisCtlreg(2); -- x04 backlash move no pos upd
 alias ctlWaitSync : std_logic is axisCtlreg(3); -- x08 wait for sync to start
 alias ctlDir     : std_logic is axisCtlreg(4); -- x10 direction
 alias ctlDirPos  : std_logic is axisCtlreg(4); -- x10 move in positive dir
 alias ctlSetLoc  : std_logic is axisCtlreg(5); -- x20 set location
 alias ctlChDirect : std_logic is axisCtlreg(6); -- x40 ch input direct
 alias ctlSlave   : std_logic is axisCtlreg(7); -- x80 slave controlled by other

--++)

 signal axisEna : std_logic := '0';
 signal axisInit : std_logic := '0';
 signal axisUpdLoc : std_logic := '0';

 signal runInit : std_logic;
 signal runEna : std_logic;
 signal updLoc : std_logic;
 
 -- signal doneInt : std_logic;

 signal doutSync : std_logic;
 signal doutDist : std_logic;
 signal doutLoc : std_logic;

 signal distDecel: std_logic;
 signal distZero : std_logic;
 signal syncAccelFlag : std_logic;
 signal syncAccelActive : std_logic;

 signal synStepOut : std_logic;
 signal step : std_logic;

 signal enaCh : std_logic;

 signal loc : unsigned(locBits-1 downto 0);

type run_fsm is (idle, loadReg, synWait, run, done);
 signal runState : run_fsm;         --z run state variable

 function convert(a: run_fsm) return unsigned is
 begin
  case a is
   when idle    => return("0001");
   when loadReg => return("0010");
   when synWait => return("0011");
   when run     => return("0100");
   when done    => return("0101");
   when others  => null;
  end case;
  return("0000");
 end;

begin

 dbgOUt(0) <= runEna;
 dbgOut(1) <= distDecel;
 dbgOut(2) <= distZero;
 dbgOut(3) <= syncAccelActive;

 AxCtlReg : CtlReg
  generic map(opVal => opBase + F_Ld_Axis_Ctl,
              opb => opBits,
              n => axisCtlSize)
  port map (
   clk => clk,
   din => din,
   op => op,
   shift => dshift,
   load => load,
   data => axisCtlReg);

 AxisSyncAccel: SyncAccel
  generic map (opBase => opBase + F_Sync_Base,
               opBits => opBits,
               synBits => synBits,
               posBits => posBits,
               countBits => countBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   load => load,
   init => runInit,
   ena => runEna,
   decel => distDecel,
   ch => ch,
   dir => encDir,
   dout => doutSync,
   accelActive => syncAccelActive,
   accelFlag => syncAccelFlag,
   synStep => synStepOut
   );

 AxisDistCounter: DistCounter
  generic map (opBase => opBase + F_Dist_Base,
               opBits => opBits,
               distBits => distBits,
               outBits => outBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   load => load,
   init => runInit,
   step => step,
   accelFlag => syncAccelFlag,
   dout => doutDist,
   decel => distDecel,
   distZero => distZero
   );

 AxisLocCounter: LocCounter
  generic map(opBase => opBase + F_Loc_Base,
              opBits => opBits,
              locBits => locBits,
              outBits => outBits)
  port map (
   clk => clk,
   din => din,
   dshift => dshift,
   op => op,
   copy => copy,
   setLoc => ctlSetLoc,
   updLoc => updLoc,
   step => step,
   dir => ctlDir,
   dout => doutLoc,
   loc => loc
   );

  AxisCtlSelect : DataSel4_2
  port map (
   sel => ctlSlave,
   a0 => axisInit,
   a1 => axisEna,
   a2 => axisUpdLoc,
   a3 => '0',
   b0 => extInit,
   b1 => extEna,
   b2 => extUpdLoc,
   b3 => '0',
   y0 => runInit,
   y1 => runEna,
   y2 => updLoc,
   y3 => open
   );

 AxisStepSel : DataSel2_1
  port map (
   sel => ctlChDirect,
   a => synStepOut,
   b => enaCh,
   y => step
   );

 initOut <= axisInit;
 enaOut <= axisEna;
 updLocOut <= axisUpdLoc;
 enaCh <= runEna and ch;
 dout <= doutSync or doutDist or doutLoc;
 dirOut <= ctlDir;
 stepOut <= step;
 -- info <= convert(runState);

 z_run: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if (ctlInit = '1') then              --if time to set new locaton
    runState <= idle;                  --clear state
    doneInt <= '0';                    --clear interrupt
    axisEna <= '0';                     --clear run flag
    axisUpdLoc <= '0';
   else                                 --if normal operation
    case runState is                    --check state
     when idle =>                       --idle state
      if (ctlStart = '1') then          --if start requested
       runState <= loadReg;             --advance to load state
       axisInit <= '1';                --set flag to load accel and sync
      end if;

     when loadReg =>                    --load state
      axisInit <= '0';                  --clear load flag
      if (ctlWaitSync = '1') then       --if wating for sync
       runState <= synWait;             --advance to wait for sync state
      else                              --if not synchronous move
       runState <= run;                 --advance to run state
       axisEna <= '1';                  --set run flag
       if (ctlBacklash = '0') then      --if not a backlash move
        axisUpdLoc <= '1';              --enable location update
       end if;
      end if;

     when synWait =>                    --sync wait state

      if (ctlStart = '0') then          --if start flag cleared
       runState <= idle;                --return to idle
      else                              --if start flag set
       if (sync = '1') then             --if time to sync
        runState <= run;                --advance to run state
        axisEna <= '1';                 --set run flag
        axisUpdLoc <= '1';              --enable location update
       end if;
      end if;
      
     when run =>                        --run state
      if ((distZero = '1') or (ctlStart = '0')) then --if distance counter zero
       runState <= done;                --advance to done state
       doneInt <= '1';                  --set done interrupt
       axisUpdLoc <= '0';               --stop location updates
       axisEna <= '0';                  --clear run flag
      end if;

     when done =>                       --done state
      if (ctlStart = '0') then          --wait for start flag to clear
       doneInt <= '0';                  --clear done intterrupt
       runState <= idle;                --to return to idle state
      end if;

     when others => null;               --all other states
    end case;
   end if;
  end if;
 end process;

end Behavioral;
