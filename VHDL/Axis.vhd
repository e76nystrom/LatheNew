LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

use work.RegDef.ALL;

entity Axis is
 generic (
  opBase    :  unsigned (opb-1 downto 0) := x"00";
  opBits    : positive := 8;
  synBits   : positive := 32;
  posBits   : positive := 24;
  countBits : positive := 18;
  distBits  : positive := 32;
  locBits   : positive := 18;
  outBits   : positive := 32;
  dbgBits   : positive := 4
  );
 port (
  clk        : in std_logic;

  din        : in std_logic;
  dshift     : in boolean;
  op         : in unsigned(opBits-1 downto 0);
  load       : in boolean;

  dshiftR    : in boolean;
  opR        : in unsigned(opBits-1 downto 0);
  copyR      : in boolean;

  extInit    : in std_logic;               --reset
  extEna     : in std_logic;               --enable operation
  extUpdLoc  : in std_logic;

  ch         : in std_logic;
  encDir     : in std_logic;
  sync       : in std_logic;

  droQuad    : in std_logic_vector(1 downto 0);
  droInvert  : in std_logic;
  mpgQuad    : in std_logic_vector(1 downto 0);
  jogInvert  : in std_logic;

  currentDir : in std_logic;
  switches   : in std_logic_vector(3 downto 0);
  eStop      : in std_logic;

  dbgOut     : out unsigned (dbgBits-1 downto 0) := (others => '0');
  initOut    : out std_logic := '0';
  enaOut     : out std_logic := '0';
  updLocOut  : out std_logic := '0';
  dout       : out std_logic := '0';
  stepOut    : out std_logic := '0';
  dirOut     : inout std_logic := '0';
  doneInt    : out std_logic := '0'
  );
end Axis;

architecture Behavioral of Axis is

 component CtlReg is
  generic(opVal : unsigned;
          opb   : positive;
          n     : positive);
  port (
   clk   : in std_logic;                --clock
   din   : in std_logic;                --data in
   op    : in unsigned(opb-1 downto 0); --current reg address
   shift : in boolean;                  --shift data
   load  : in boolean;                  --load to data register
   data  : inout  unsigned (n-1 downto 0)); --data register
 end Component;

 component ShiftOutN is
  generic(opVal   : unsigned;
          opBits  : positive;
          n       : positive;
          outBits : positive);
  port (
   clk    : in std_logic;
   dshift : in boolean;
   op     : in unsigned (opBits-1 downto 0);
   copy   : in boolean;
   data   : in unsigned(n-1 downto 0);
   dout   : out std_logic
   );
 end Component;

 component SyncAccelDistJog is
  
  generic (opBase    : unsigned := x"00";
           opBits    : positive := 8;
           synBits   : positive := 32;
           posBits   : positive := 18;
           distBits  : positive := 18;
           countBits : positive := 18);
  port (
   clk       : in std_logic;

   din       : in std_logic;
   dshift    : in boolean;
   op        : in unsigned (opBits-1 downto 0);
   load      : in boolean;

   dshiftR   : in boolean;
   opR       : in unsigned (opBits-1 downto 0);
   copyR     : in boolean;

   init      : in std_logic;            --reset
   ena       : in std_logic;            --enable operation
   extDone   : in boolean;              --external done input
   ch        : in std_logic;

   quad      : in std_logic_vector(1 downto 0);
   jogInvert : in std_logic;
   jogMode   : in std_logic_vector(1 downto 0);

   done      : inout  boolean;
   dout      : out    std_logic;
   synStep   : out    std_logic
   );
 end Component;

 component LocCounter is
  generic(opBase  : unsigned;
          opBits  : positive;
          locBits : positive;
          outBits : positive);
  Port (
   clk : in  std_logic;
   din : in std_logic;          --shift data in
   dshift : in boolean;       --shift clock in
   op : in unsigned(opBits-1 downto 0); --operation code
   dshiftR : in boolean;       --shift clock in
   opR : in unsigned(opBits-1 downto 0); --operation code
   copyR : in boolean;         --copy location for output
   setLoc : in std_logic;       --set location
   updLoc : in std_logic;       --location update enabled
   step : in std_logic;         --input step pulse
   dir : in std_logic;          --direction
   dout : out std_logic         --data out
   -- loc : inout unsigned(locBits-1 downto 0) --current location
   );
 end Component;

 component QuadDro is
 generic (opBase : unsigned;
          opBits : positive;
          droBits : positive;
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
  quad : in std_logic_vector(1 downto 0);
  dirInvert : in std_logic;
  endCheck : in std_logic;
  decelDisable : out boolean;
  done : out boolean;
  dout : out std_logic
  );
 end Component;

 component PulseGen is
  generic(pulseWidth : positive);
  port ( clk : in std_logic;
         pulseIn : in std_logic;
         pulseOut : out std_logic);
 end Component;

--(++ axisCtl
-- axis status register

 constant axisStatusSize : integer := 4;
 signal axisStatusReg : unsigned(axisStatusSize-1 downto 0);
 alias axDoneDist   : std_logic is axisStatusreg(0); -- x01 axis done distance
 alias axDoneDro    : std_logic is axisStatusreg(1); -- x02 axis done dro
 alias axDoneHome   : std_logic is axisStatusreg(2); -- x04 axis done home
 alias axDoneLimit  : std_logic is axisStatusreg(3); -- x08 axis done limit

 constant c_axDoneDist   : integer :=  0; -- x01 axis done distance
 constant c_axDoneDro    : integer :=  1; -- x02 axis done dro
 constant c_axDoneHome   : integer :=  2; -- x04 axis done home
 constant c_axDoneLimit  : integer :=  3; -- x08 axis done limit

-- axis control register

 constant axisCtlSize : integer := 13;
 signal axisCtlReg : unsigned(axisCtlSize-1 downto 0);
 alias ctlInit      : std_logic is axisCtlreg(0); -- x01 reset flag
 alias ctlStart     : std_logic is axisCtlreg(1); -- x02 start
 alias ctlBacklash  : std_logic is axisCtlreg(2); -- x04 backlash move no pos upd
 alias ctlWaitSync  : std_logic is axisCtlreg(3); -- x08 wait for sync to start
 alias ctlDir       : std_logic is axisCtlreg(4); -- x10 direction
 alias ctlDirPos    : std_logic is axisCtlreg(4); -- x10 move in positive dir
 alias ctlDirNeg    : std_logic is axisCtlreg(4); -- x10 move in negative dir
 alias ctlSetLoc    : std_logic is axisCtlreg(5); -- x20 set location
 alias ctlChDirect  : std_logic is axisCtlreg(6); -- x40 ch input direct
 alias ctlSlave     : std_logic is axisCtlreg(7); -- x80 slave controlled by other axis
 alias ctlDroEnd    : std_logic is axisCtlreg(8); -- x100 use dro to end move
 alias ctlJogCmd    : std_logic is axisCtlreg(9); -- x200 jog with commands
 alias ctlJogMpg    : std_logic is axisCtlreg(10); -- x400 jog with mpg
 alias ctlHome      : std_logic is axisCtlreg(11); -- x800 homing axis
 alias ctlIgnoreLim : std_logic is axisCtlreg(12); -- x1000 ignore limits

--++)

 signal axisEna    : std_logic := '0';
 signal axisInit   : std_logic := '0';
 signal axisUpdLoc : std_logic := '0';
 -- signal jogUpdLoc  : std_logic;

 signal runInit : std_logic;
 signal runEna  : std_logic;
 signal updLoc  : std_logic;
 
 -- signal doneInt : std_logic;

 signal doutSync   : std_logic;
 -- signal doutDist : std_logic;
 signal doutLoc    : std_logic;
 signal doutDro    : std_logic;
 -- signal doutJog    : std_logic;
 signal doutStatus : std_logic;
 signal doutCtl    : std_logic;

 -- signal distDecel: std_logic;
 signal distZero : boolean;

 signal syncAccelEna : std_logic;
 -- signal syncAccelActive : std_logic;

 signal synStepOut : std_logic;
 signal step : std_logic;

 signal enaCh : std_logic;

 signal doneDist  : boolean;
 signal doneDro   : boolean;
 signal doneLimit : boolean;
 signal doneHome  : boolean;
 signal doneMove  : boolean;

 -- signal loc : unsigned(locBits-1 downto 0) := (others => '0');

 -- signal jogEna  : std_logic;
 -- signal jogStep : std_logic;
 signal jogDir  : std_logic;

 signal decelDisable : boolean;
 signal droDone : boolean;

 alias swHome     : std_logic is switches(0);
 alias swLimMinus : std_logic is switches(1);
 alias swLimPlus  : std_logic is switches(2);

 signal dbgStep : std_logic;

 signal jogMode : std_logic_vector(1 downto 0);

 -- signal currentDir : std_logic := '0';

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

 AxStatReg: ShiftOutN
  generic map(opVal => opBase + F_Rd_Axis_Status,
              opBits => opBits,
              n => axisStatusSize,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftr,
   op => opR,
   copy => copyR,
   data => axisStatusReg,
   dout => doutStatus
   );

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

 AxCtlRegRd: ShiftOutN
  generic map(opVal => opBase + F_Rd_Axis_Ctl,
              opBits => opBits,
              n => axisCtlSize,
              outBits => outBits)
  port map (
   clk => clk,
   dshift => dshiftr,
   op => opR,
   copy => copyR,
   data => axisCtlReg,
   dout => doutCtl
   );

 syncAccelEna <= runEna when ctlChDirect = '0' else '0';

 jogMode <= ctlJogMpg & ctlJogCmd;

 AxisSyncAccel: SyncAccelDistJog
  generic map (opBase    => opBase + F_Sync_Base,
               opBits    => opBits,
               synBits   => synBits,
               posBits   => posBits,
               distBits  => distBits,
               countBits => countBits)
  port map (
   clk       => clk,

   din       => din,
   dshift    => dshift,
   op        => op,
   load      => load,

   dshiftR   => dshiftR,
   opR       => opR,
   copyR     => copyR,

   init      => runInit,
   ena       => syncAccelEna,
   extDone   => doneMove,
   ch        => ch,

   quad      => mpgQuad,
   jogInvert => jogInvert,
   jogMode   => jogMode,

   done      => distZero,
   dout      => doutSync,
   synStep   => synStepOut
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
   dshiftR => dshiftR,
   opR => opR,
   copyR => copyR,
   setLoc => ctlSetLoc,
   updLoc => updLoc,
   step => step,
   dir => ctlDir,
   dout => doutLoc
   -- loc => loc
   );

 AxisDro : QuadDro
  generic map (opBase => opBase + F_Dro_Base,
               opBits => opBits,
               droBits => locBits,
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
   quad => droQuad,
   dirInvert => droInvert,
   endCheck => ctlDroEnd,
   decelDisable => decelDisable,
   done => droDone,
   dout => doutDro
   );

 dbgPulse : PulseGen
  generic map (pulseWidth => 25)
  port map (
   clk => clk,
   pulseIn => step,
   PulseOut => dbgStep
   );

 dbgOut(0) <= ctlStart;  --updLoc;
 -- dbgOut(1) <= ctlWaitSync;
 -- dbgOut(1) <= distDecel; --distZero;
 dbgOut(2) <= '1' when distZero else '0';
 dbgOut(3) <= dbgStep;

 runInit <= extInit when ctlSlave = '1' else axisInit;
 runEna  <= extEna when ctlSlave = '1' else axisEna;
 updLoc  <= extUpdLoc when ctlSlave = '1'; --else
            -- jogUpdLoc when ctlJogMpg = '1' else axisUpdLoc;

 step    <= synStepOut when ctlChDirect = '0' else enaCh;

 initOut   <= axisInit;
 enaOut    <= axisEna;
 updLocOut <= axisUpdLoc;
 
 enaCh   <= runEna and ch;
 -- dirOut  <= JogDir when ctlJogMpg = '1' else ctlDir;
 -- stepOut <= jogStep when ctlJogMpg = '1' else step;
 -- stepOut <= (jogStep and ctlJogMpg) or (step and not(ctlJogMpg));
 dirOut <= ctlDir;
 stepOut <= step;

 axDoneDist  <= '1' when doneDist else '0';
 axDoneDro   <= '1' when doneDro else '0';
 axDoneHome  <= '1' when doneHome else '0';
 axDoneLimit <= '1' when doneLimit else '0';

 z_run: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active

   -- dout <= doutSync or doutDist or doutLoc or doutDro or doutJog or doutStatus or doutCtl;
   dout <= doutSync or doutLoc or doutDro or doutStatus or doutCtl;

   doneDist  <= distZero       and (ctlDroEnd = '0');
   doneDro   <= droDone        and (ctlDroEnd = '1');
   doneHome  <= (swHome = '1') and (ctlHome = '1');
   doneLimit <= ((swLimMinus = '1') or (swLimPlus = '1')) and
                (ctlIgnoreLim = '0');

   doneMove <= doneDist; -- or doneDro or doneLimit or doneHome;

   if (eStop = '1') then                --if emergency stop
    axisEna  <= '0';                    --stop axis
    runState <= idle;                   --set idle state
   elsif (ctlInit = '1') then           --if time to set new locaton
    runState <= idle;                   --clear state
    doneInt    <= '0';                  --clear interrupt
    dbgOut(1)  <= '0';
    axisEna    <= '0';                  --clear run flag
    axisUpdLoc <= '0';
    axisInit   <= '1';                  --set flag to load accel and sync
   else                                 --if normal operation
    case runState is                    --check state
     when idle =>                       --idle state
      axisInit <= '0';                  --clear load flag
      if (ctlStart = '1') then          --if start requested
       runState <= loadReg;             --advance to load state
      end if;

     when loadReg =>                    --load state
      if (ctlWaitSync = '1') then       --if wating for sync
       runState <= synWait;             --advance to wait for sync state
      else                              --if not synchronous move
       axisEna  <= '1';                 --set run flag
       runState <= run;                 --advance to run state
       if (ctlBacklash = '0') then      --if not a backlash move
        axisUpdLoc <= '1';              --enable location update
       end if;
      end if;

     when synWait =>                    --sync wait state
      if (ctlStart = '0') then          --if start flag cleared
       runState <= idle;                --return to idle
      else                              --if start flag set
       if (sync = '1') then             --if time to sync
        axisEna    <= '1';              --set run flag
        axisUpdLoc <= '1';              --enable location update
        runState   <= run;              --advance to run state
       end if;
      end if;
      
     when run =>                        --run state
      if (doneMove or (ctlStart = '0')) then --if done
       doneInt    <= '1';               --set done interrupt
       dbgOut(1)  <= '1';
       axisUpdLoc <= '0';               --stop location updates
       axisEna    <= '0';               --clear run flag
       runState   <= done;              --advance to done state
      end if;

     when done =>                       --done state
      if (ctlStart = '0') then          --wait for start flag to clear
       doneInt   <= '0';                --clear done intterrupt
       dbgOut(1) <= '0';
       runState  <= idle;               --to return to idle state
      end if;

     when others => null;               --all other states
    end case;
   end if;
  end if;
 end process;

end Behavioral;
