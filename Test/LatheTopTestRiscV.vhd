library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_arith.conv_integer;
use ieee.math_real.all;

use work.SimProc.all;
use work.RegDef.all;
use work.FpgaLatheBitsRec.all;
use work.FpgaLatheBitsFunc.all;

entity A_LatheTopTestRiscV is
end A_LatheTopTestRiscV;

architecture behavior OF A_LatheTopTestRiscV is

 constant synBits   : positive := 32;
 constant posBits   : positive := 18;
 constant countBits : positive := 18;
 constant distBits  : positive := 18;
 constant locBits   : positive := 18;
 constant readBits  : positive := 32;

 constant freqBits      : positive := 16;
 constant freqCountBits : positive := 16;

 signal sysClk : std_logic := '0';
 signal rstn_i : std_ulogic := '0';

 signal led   : std_logic_vector(7 downto 0) := (others => '0');
 signal dbg   : std_logic_vector(7 downto 0) := (others => '0');
 signal xOut  : std_logic_vector(3 downto 0) := (others => '0');
 signal anode : std_logic_vector(3 downto 0) := (others => '0');
 signal seg   : std_logic_vector(6 downto 0) := (others => '0');

 signal zDro : std_logic_vector(1 downto 0) := (others => '0');
 signal xDro : std_logic_vector(1 downto 0) := (others => '0');
 signal zMpg : std_logic_vector(1 downto 0) := (others => '0');
 signal xMpg : std_logic_vector(1 downto 0) := (others => '0');

 signal pinIn : std_logic_vector(13-1 downto 0) := (others => '0');
 signal aux   : std_logic_vector(7 downto 0) := (others => '0');

 signal pinOut : std_logic_vector(11 downto 0);
 signal extOut : std_logic_vector(2 downto 0);
 
 signal bufOut : std_logic_vector(3 downto 0);

 signal dclk     : std_logic := '0';
 signal dout     : std_logic := '0';
 signal din      : std_logic := '0';
 signal dsel     : std_logic := '0';
 signal aIn      : std_logic := '0';
 signal bIn      : std_logic := '0';
 signal syncIn   : std_logic := '0';
 signal zStep    : std_logic := '0';
 signal zDir     : std_logic := '0';
 signal xStep    : std_logic := '0';
 signal xDir     : std_logic := '0';
 signal zDoneInt : std_logic := '0';
 signal xDoneInt : std_logic := '0';

begin

 LatheTopSim : entity work.LatheTopSimRiscV
  port map (
   sysClk => sysClk,
   rstn_i => rstn_i,
   
   led   => led,
   dbg   => dbg,
   anode => anode,
   seg   => seg,

   dclk => dclk,
   dout => dout,
   xOut => xOut,
   din  => din,
   dsel => dsel,

   aIn => aIn,
   bIn => bIn,

   syncIn => syncIn,

   zDro => zDro,
   xDro => xDro,
   zMpg => zMpg,
   xMpg => xMpg,

   pinIn => pinIn,
   aux   => aux,

   pinOut => pinOut,
   extOut => extOut,

   zDoneInt => zDoneInt,
   xDoneInt => xDoneInt
   );

 -- Clock process definitions

 clkProcess :process
 begin
  sysClk <= '0';
  wait for clk_period/2;
  sysClk <= '1';
  wait for clk_period/2;
 end process;

 -- Stimulus process

 stimProc: process

  procedure delay(constant n : in integer) is
  begin
   for i in 0 to n-1 loop
    wait until (sysClk = '1');
    wait until (sysClk = '0');
   end loop;
  end procedure delay;

  variable count : integer := 0;
  variable indexCount : integer := 0;

  procedure delayQuad(constant n : in integer) is
  begin
   for i in 0 to n-1 loop
    count := count + 1;
    if (count > 3) then
     count := 0;
    end if;

    indexCount := indexCount + 1;
    if (indexCount > 127) then
     indexCount := 0;
     syncIn <= '1';
    else
     syncIn <= '0';
    end if;
    
    case count is
     when 0 =>
      bIn <= '0';
     when 1 =>
      aIn <= '1';
     when 2 =>
      bIn <= '1';
     when 3 =>
      aIn <= '0';
     when others =>
      count := 0;
    end case;
    delay(10);
   end loop;
  end procedure delayQuad;

  procedure delayQuadLim(constant n : in integer;
                         constant limit : in integer) is
   variable cur  : std_logic := '0';
   variable last : std_logic := '0';
   variable step : integer := 0;
  begin
   for i in 0 to n-1 loop
    count := count + 1;
    if (count > 3) then
     count := 0;
    end if;

    indexCount := indexCount + 1;
    if (indexCount > 127) then
     indexCount := 0;
     syncIn <= '1';
    else
     syncIn <= '0';
    end if;
    
    case count is
     when 0 =>
      bIn <= '0';
     when 1 =>
      aIn <= '1';
     when 2 =>
      bIn <= '1';
     when 3 =>
      aIn <= '0';
     when others =>
      count := 0;
    end case;

    for i in 0 to n-1 loop
     wait until (sysClk = '1');

     last := cur;
     cur := pinOut(1);
     if ((last = '0') and (cur = '1')) then
      step := step + 1;
     end if;
     
     wait until (sysClk = '0');
     if (step >= limit) then
      report "index" & integer'image(i);
      exit;
     end if;
    end loop;
   end loop;
  end procedure delayQuadLim;

  alias zMpgA : std_logic is zMpg(0);
  alias zMpgB : std_logic is zMpg(1);

  procedure delayMpgQuad(constant n : in integer;
                         constant dly : in integer;
                         constant dir : in integer) is
  begin
   for i in 0 to n-1 loop
    count := count + dir;
    if (count > 3) then
     count := 0;
    end if;
    if (count < 0) then
     count := 3;
    end if;
    
    case count is
     when 0 =>
      zMpgb <= '0';
     when 1 =>
      zMpga <= '1';
     when 2 =>
      zMpgb <= '1';
     when 3 =>
      zMpga <= '0';
     when others =>
      count := 0;
    end case;
    delay(dly);
   end loop;
  end procedure delayMpgQuad;

  procedure loadParm(constant parmIdx : in unsigned (opbx-1 downto 0)) is
   variable i : integer := 0;
   variable tmp : unsigned (opbx-1 downto 0);
  begin
   dsel <= '0';                          --start of load
   delay(10);

   tmp := parmIdx;
   -- report "parmIdx " & integer'image(to_integer(tmp));
   for i in 0 to opbx-1 loop             --load parameter
    dclk <= '0';
    din <= tmp(opbx-1);
    tmp := shift_left(tmp, 1);
    delay(2);
    dclk <= '1';
    delay(6);
   end loop;
   din <= '0';
   dclk <= '0';

   delay(10);
  end procedure loadParm;

  procedure loadValue(variable value : in integer;
                      constant bits : in natural) is
   variable tmp : std_logic_vector (32-1 downto 0);
  begin
   tmp := conv_std_logic_vector(value, 32);
   for i in 0 to bits-1 loop             --load value
    dclk <= '0';
    din <= tmp(bits-1);
    delay(6);
    dclk <= '1';
    tmp := tmp(31-1 downto 0) & tmp(31);
    delay(6);
   end loop;
   din <= '0';
   dclk <= '0';
   dsel <= '1';                          --end of load
   delay(10);
  end procedure loadValue;

  procedure loadValueC(constant value : in integer;
                       constant bits : in natural) is
   variable tmp : integer;
  begin
   tmp := value;
   loadValue(tmp, bits);
  end procedure loadValueC;
  
  procedure loadMid(variable value : in integer;
                    constant bits : in natural) is
   variable tmp : std_logic_vector (32-1 downto 0);
  begin
   tmp := conv_std_logic_vector(value, 32);
   for i in 0 to bits-1 loop             --load value
    dclk <= '0';
    din <= tmp(bits-1);
    delay(2);
    dclk <= '1';
    tmp := tmp(31-1 downto 0) & tmp(31);
    delay(6);
   end loop;
   din <= '0';
   dclk <= '0';
  end procedure loadMid;

  procedure loadMidC(constant value : in integer;
                     constant bits : in natural) is
   variable tmp : integer;
  begin
   tmp := value;
   loadMid(tmp, bits);
  end procedure loadMidC;
  
  procedure readValue(constant bits : in natural) is
   variable tmp : unsigned (bits-1 downto 0);
  begin
   tmp := (others => '0');
   din <= '0';
   for i in 0 to bits-1 loop            --read value
    dclk <= '0';
    delay(6);
    dclk <= '1';
    tmp := tmp(bits-2 downto 0) & dout;
    delay(6);
   end loop;
   report "readValue " & integer'image(to_integer(tmp));
   dclk <= '0';
   dsel <= '1';                          --end of load
   delay(10);
  end procedure readValue;

  -- procedure loadShift(variable value : in integer;
  --                     constant bits : in natural) is
  --  variable tmp: std_logic_vector(32-1 downto 0);
  -- begin
  --  tmp := conv_std_logic_vector(value, 32);
  --  dshift <= '1';
  --  for i in 0 to bits-1 loop691
  --   din <= tmp(bits - 1);
  --   wait until clk = '1';
  --   tmp := tmp(31-1 downto 0) & tmp(31);
  --   wait until clk = '0';
  --  end loop;
  --  dshift <= '0';
  -- end procedure loadShift;

--variables

  variable dx : integer;
  variable dy : integer;
  variable d  : integer;
  variable incr1 : integer;
  variable incr2 : integer;
  variable accelVal : integer;
  variable accelCount : integer;
  variable dist : integer;
  variable maxDist : integer;
  variable loc : integer;
  variable backlash : integer;

  variable ctl : integer;

  variable freq : integer;
  variable dbgCount : integer;
  variable base : unsigned(opb-1 downto 0);

  variable axisCtlReg : axisCtlRec;
  variable clkCtlReg  : clkCtlRec;

  variable jogTest : boolean := false;

  -- mpg
  
  constant mpgBits   : natural := 32;

  -- delta

  constant deltaMax  : natural := 50;
  constant deltaBits : natural := integer(ceil(log2(real(deltaMax))));
  variable delta     : unsigned(deltaBits-1 downto 0) := (others => '0');

  type deltaRec is record
   val : unsigned(deltaBits-1 downto 0);
  end record;

  constant deltaI0   : natural := 30;
  constant deltaI1   : natural := 15;
  constant deltaI2   : natural := 4;
  constant deltaI3   : natural := 0;

  constant regDeltaIni : unsigned(mpgBits-1 downto 0) :=
   (to_unsigned(deltaI3, 8) & to_unsigned(deltaI2, 8) &
    to_unsigned(deltaI2, 8) & to_unsigned(deltaI0, 8));

  variable mpgRegDelta : unsigned(mpgBits-1 downto 0) := regDeltaIni;

  alias delta0 : unsigned(deltaBits-1 downto 0) is
   mpgRegDelta(0 + deltaBits-1 downto 0);
  alias delta1 : unsigned(deltaBits-1 downto 0) is
   mpgRegDelta(8 + deltaBits-1 downto 8);
  alias delta2 : unsigned(deltaBits-1 downto 0) is
   mpgRegDelta(16 + deltaBits-1 downto 16);

  -- div
  
  constant divMax    : natural := 63;
  constant divBits   : natural := integer(ceil(log2(real(divMax)))); 
  variable chDiv     : unsigned(divBits-1 downto 0) := (others => '0');
  variable chCtr     : unsigned(divBits-1 downto 0) := (others => '0');

  constant divI0     : natural := 1;
  constant divI1     : natural := 3;
  constant divI2     : natural := 5;
  constant divI3     : natural := 7;

  constant regDivIni : unsigned(mpgBits-1 downto 0) :=
   (to_unsigned(divI3, 8) & to_unsigned(divI2, 8) &
    to_unsigned(divI2, 8) & to_unsigned(divI0, 8));

  variable mpgRegDiv   : unsigned(mpgBits-1 downto 0) := regDivIni;

  alias div0 : unsigned(divBits-1 downto 0) is
   mpgRegDiv(0 + divBits-1 downto 0);
  alias div1 : unsigned(divBits-1 downto 0) is
   mpgRegDiv(8 + divBits-1 downto 8);
  alias div2 : unsigned(divBits-1 downto 0) is
   mpgRegDiv(16 + divBits-1 downto 16);
  alias div3 : unsigned(divBits-1 downto 0) is
   mpgRegDiv(24 + divBits-1 downto 24);

  -- dist
  
  constant mpgDistMax  : natural := 200;
  constant mpgDistBits : natural := integer(ceil(log2(real(mpgDistMax))));
  variable mpgDistUpd  : std_logic := '0';
  variable mpgDist     : unsigned(mpgDistBits-1 downto 0) := (others => '0');
  variable mpgDistCtr  : unsigned(mpgDistBits-1 downto 0) := (others => '0');

  constant distI0    : natural := 1;
  constant distI1    : natural := 2;
  constant distI2    : natural := 4;
  constant distI3    : natural := 8;

  constant regDistIni : unsigned(mpgBits-1 downto 0) :=
   (to_unsigned(distI3, 8) & to_unsigned(distI2, 8) &
    to_unsigned(distI2, 8) & to_unsigned(distI0, 8));

  variable mpgRegDist  : unsigned(mpgBits-1 downto 0) := regDistIni;

  alias dist0 : unsigned(mpgDistBits-1 downto 0) is
   mpgRegDist(0 + mpgDistBits-1 downto 0);
  alias dist1 : unsigned(mpgDistBits-1 downto 0) is
   mpgRegDist(8 + mpgDistBits-1 downto 8);
  alias dist2 : unsigned(mpgDistBits-1 downto 0) is
   mpgRegDist(16 + mpgDistBits-1 downto 16);
  alias dist3 : unsigned(mpgDistBits-1 downto 0) is
   mpgRegDist(24 + mpgDistBits-1 downto 24);

 begin

-- hold reset state for 100 ns.

  rstn_i <= '1';
  wait for 100 ns;

  delay(100000);

  -- delay(10);

  -- -- insert stimulus here

  -- dx := 2540 * 8;
  -- dy := 600;

  -- --dx := 87381248;
  -- --dy := 341258;

  -- dist := 20;
  -- maxDist := 100;
  -- loc := 5;

  -- backlash := 10;

  -- incr1 := 2 * dy;
  -- -- incr2 := 2 * (dy - dx);
  -- -- incr2 := 2 * dy - 2 * dx;
  -- incr2 := incr1 - 2 * dx;
  -- d := incr1 - dx;

  -- accelVal := 8;
  -- accelCount := 100;

  -- base := F_ZAxis_Base;

  -- loadParm(base + F_Sync_Base + F_Ld_D);
  -- loadValue(d, synBits);

  -- delay(1);

  -- loadParm(base + F_Sync_Base + F_Ld_Incr1);
  -- loadValue(incr1, synBits);

  -- delay(1);

  -- loadParm(base + F_Sync_Base + F_Ld_Incr2);
  -- loadValue(incr2, synBits);

  -- delay(1);

  -- loadParm(base + F_Sync_Base + F_Ld_Accel_Val);
  -- loadValue(accelVal, synBits);

  -- delay(1);

  -- loadParm(base + F_Sync_Base + F_Ld_Accel_Count);
  -- loadValue(accelCount, countBits);
  
  -- delay(1);

  -- loadParm(base + F_Sync_Base + F_Ld_A_Dist);
  -- loadValue(dist, distBits);

  -- delay(1);

  -- loadParm(base + F_Sync_Base + F_Ld_Max_Dist);
  -- loadValue(maxDist, distBits);

  -- delay(1);

  -- loadParm(base + F_Sync_Base + F_Ld_Backlash);
  -- loadValue(backlash, distBits);

  -- delay(1);
  
  -- loadParm(base + F_Sync_Base + F_Ld_X_Loc);
  -- loadValue(loc, locBits);

  -- delay(1);
  
  -- loadParm(base + F_Sync_Base + F_Ld_Mpg_Delta);
  -- loadValue(to_integer(mpgRegDelta), mpgBits);

  -- delay(1);
  
  -- loadParm(base + F_Sync_Base + F_Ld_Mpg_Dist);
  -- loadValue(to_integer(mpgRegDist), mpgBits);

  -- delay(1);
  
  -- loadParm(base + F_Sync_Base + F_Ld_Mpg_Div);
  -- loadValue(to_integer(mpgRegDiv), mpgBits);

  -- delay(1);
  
  -- axisCtlReg := axisCtlToRec(axisCtlZero);
  -- axisCtlReg.ctlInit := '1';
  -- axisCtlReg.ctlSetLoc := '1';
  -- loadParm(base + F_Ld_Axis_Ctl);
  -- ctl := to_integer(unsigned(axisCtlToVec(axisCtlReg)));
  -- loadValue(ctl, axisCtlSize);

  -- delay(5);

  -- axisCtlReg := axisCtlToRec(axisCtlZero);
  -- loadParm(base + F_Ld_Axis_Ctl);

  -- delay(5);

  -- loadParm(base + F_Sync_Base + F_Rd_A_Dist);
  -- report "F_Rd_A_Dist";
  -- readValue(readBits);

  -- delay(5);

  -- dist := 15;
  -- loadParm(base + F_Sync_Base + F_Ld_A_Dist);
  -- loadValue(dist, distBits);

  -- delay(5);
  
  -- loadParm(base + F_Sync_Base + F_Rd_A_Dist);
  -- report "F_Rd_A_Dist";
  -- readValue(readBits);

  -- delay(5);

  -- if (jogTest) then
  --  axisCtlReg.ctlJogCmd := '0'; --enable jog command
  --  axisCtlReg.ctlJogMpg := '1'; --enable jog command
  --  -- ctlJogMode := to_unsigned(3, 2);
  --  report "axisCtlReg" &
  --   integer'image(to_integer(unsigned(axisCtlToVec(axisCtlReg))));
  -- end if;

  -- -- axisCtlReg(c_ctlInit) := '0';
  -- -- axisCtlReg(c_ctlSetLoc) := '0';

  -- axisCtlReg.ctlStart := '1';
  -- axisCtlReg.ctlDir := '1';
  -- --ctlChDirect := '1';
  -- loadParm(base + F_Ld_Axis_Ctl);
  -- ctl := to_integer(unsigned(axisCtlToVec(axisCtlReg)));
  -- loadValue(ctl, axisCtlSize);

  -- delay(1);

  -- freq := 10-1;
  -- loadParm(F_Dbg_Freq_Base + F_Ld_Dbg_Freq);
  -- loadValue(freq, freqBits);

  -- delay(1);

  -- dbgCount := 3000;
  -- loadParm(F_Dbg_Freq_Base + F_Ld_Dbg_Count);
  -- loadValue(dbgCount, freqCountBits);

  -- clkCtlReg := clkCtlToRec(clkCtlZero);
  -- clkCtlReg.zFreqSel := clkDbgFreq;                --to_unsigned(7, 3);
  -- clkCtlReg.clkDbgFreqEna := '1';
  
  -- loadParm(F_Ld_Clk_Ctl);
  -- ctl := to_integer(unsigned(axisCtlToVec(axisCtlReg)));
  -- loadValue(ctl, clkCtlSize);

  -- if (jogTest) then
  --  delayMpgQuad(32, 25*9, -1);
  -- else
  --  -- delayQuadLim(500, 14);
  --  delayQuad(500);
  -- end if;
  
  -- -- ********************
  -- -- clear done
  
  -- axisCtlReg := axisCtlToRec(axisCtlZero);
  -- axisCtlReg.ctlInit := '1';
  -- -- axisCtlReg.ctlDir := '1';

  -- loadParm(base + F_Ld_Axis_Ctl);
  -- ctl := to_integer(unsigned(axisCtlToVec(axisCtlReg)));
  -- loadValue(ctl, axisCtlSize);

  -- axisCtlReg.ctlInit := '1';
  -- loadParm(base + F_Ld_Axis_Ctl);
  -- ctl := to_integer(unsigned(axisCtlToVec(axisCtlReg)));
  -- loadValue(ctl, axisCtlSize);
  -- -- ********************

  -- -- delay(3600);
  -- dist := 10;
  -- loadParm(base + F_Sync_Base + F_Ld_A_Dist);
  -- loadValue(dist, distBits);
  -- -- delayQuad(500);
  -- delay(1000);

  -- axisCtlReg := axisCtlToRec(axisCtlZero);
  -- axisCtlReg.ctlStart := '1';
  -- axisCtlReg.ctlDir := '1';

  -- loadParm(base + F_Ld_Axis_Ctl);
  -- ctl := to_integer(unsigned(axisCtlToVec(axisCtlReg)));
  -- loadValue(ctl, axisCtlSize);

  -- clkCtlReg := clkCtlToRec(clkCtlZero);
  -- clkCtlReg.zFreqsel := clkDbgFreq;
  -- clkCtlReg.clkDbgFreqEna := '1';
  
  -- loadParm(F_Ld_Clk_Ctl);
  -- ctl := to_integer(unsigned(clkCtlToVec(clkCtlReg)));
  -- loadValue(ctl, clkCtlSize);

  -- delay(10);

  -- loadParm(F_Rd_Status);
  -- report "F_Rd_Status";
  -- readValue(readBits);

  -- loadParm(base + F_Sync_Base + F_Rd_X_Loc);
  -- report "F_Rd_X_loc";
  -- readValue(readBits);

  -- delay(20);

  -- accelCount := 1000;

  -- loadParm(base + F_Sync_Base + F_Ld_Accel_Count);
  -- loadValue(accelCount, countBits);

  -- axisCtlReg := axisCtlToRec(axisCtlZero);
  -- axisCtlReg.ctlInit := '1';
  -- axisCtlReg.ctlSetLoc := '1';
  -- loadParm(base + F_Ld_Axis_Ctl);
  -- ctl := to_integer(unsigned(axisCtlToVec(axisCtlReg)));
  -- loadValue(ctl, axisCtlSize);

  -- axisCtlReg := axisCtlToRec(axisCtlZero);
  -- axisCtlReg.ctlStart := '1';
  -- axisCtlReg.ctlDir := '1';
  -- loadParm(base + F_Ld_Axis_Ctl);
  -- ctl := to_integer(unsigned(axisCtlToVec(axisCtlReg)));
  -- loadValue(ctl, axisCtlSize);

  -- loadParm(base + F_Rd_Axis_Ctl);
  -- report "F_Rd_Axis_Ctl";
  -- readValue(readBits);

  -- delayQuadLim(50000, 100);
  
  wait;
 end process;

end;
