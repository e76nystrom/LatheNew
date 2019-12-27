--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:25:00 01/25/2015 
-- Design Name: 
-- Module Name:    SyncAccel - Behavioral 
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

use work.RegDef.ALL;

entity SyncAccel is
 generic (opBase : unsigned := x"00";
          opBits : positive := 8;
          synBits : positive := 32;
          posBits : positive := 18;
          countBits : positive := 18);
 port (
  clk : in std_logic;
  din : in std_logic;
  dshift : in std_logic;
  op : in unsigned (opBits-1 downto 0);
  copy : in std_logic;
  load : in std_logic;
  init : in std_logic;                  --reset
  ena : in std_logic;                   --enable operation
  decel : in std_logic;
  ch : in std_logic;
  dir : in std_logic;
  dout : out std_logic := '0';
  synStep : out std_logic := '0';
  accelFlag : out std_logic := '0'
  );
end SyncAccel;

architecture Behavioral of SyncAccel is

 component Shift is
  generic(n : positive);
  port (
   clk : in std_logic;
   shift : in std_logic;
   din : in std_logic;
   data : inout  unsigned (n-1 downto 0));
 end component;

 component DataSel4 is
  generic (n : positive);
  port (
   sel : in std_logic_vector (1 downto 0);
   data0 : in  unsigned (n-1 downto 0);
   data1 : in  unsigned (n-1 downto 0);
   data2 : in  unsigned (n-1 downto 0);
   data3 : in  unsigned (n-1 downto 0);
   data_out : out  unsigned (n-1 downto 0));
 end component;

 component Adder is
  generic (n : positive);
  port (
   clk : in std_logic;
   ena : in std_logic;
   load : in std_logic;
   func : in std_logic;
   a : in  unsigned (n-1 downto 0);
   sum : inout  unsigned (n-1 downto 0));
 end component;

 component Accumulator is
  generic (n : positive);
  port (
   clk : in std_logic;
   ena : in std_logic;
   clr : in std_logic;
   func : in std_logic;
   a : in unsigned (n-1 downto 0);
   sum : inout unsigned (n-1 downto 0);
   zero: inout std_logic);
 end component;

 component UpDownClrCtr is
  generic(n : positive);
  port (
   clk : in std_logic;
   ena : in std_logic;
   inc : in std_logic;
   clr : in std_logic;
   counter : inout unsigned(n-1 downto 0)
   );
 end component;

 component DownCounter is
  generic(n : positive);
  port (
   clk : in std_logic;
   ena : in std_logic;
   load : in std_logic;
   preset : in unsigned(n-1 downto 0);
   counter : inout unsigned(n-1 downto 0);
   zero : out std_logic
   );
 end component;

 component ShiftOut is
  generic(opVal : unsigned;
          opBits : positive;
          n : positive);
  port (
   clk : in std_logic;
   dshift : in std_logic;
   op : in unsigned (opBits-1 downto 0);
   load : in std_logic;
   data : in unsigned(n-1 downto 0);
   dout : out std_logic
   );
 end Component;

 type fsm is (idle, chk_dir, dir_upd1, dir_upd2,
                  upd_sum, upd_accel, clr_ena);
 signal state : fsm := idle;

 signal mux_sel : std_logic_vector(1 downto 0);
 constant selD     : std_logic_vector(1 downto 0) := "00";
 constant selIncr1 : std_logic_vector(1 downto 0) := "01";
 constant selIncr2 : std_logic_vector(1 downto 0) := "10";
 constant selAccel : std_logic_vector(1 downto 0) := "11";
 signal adder_ena  : std_logic;
 signal adder_load : std_logic;

 signal d      : unsigned(synBits-1 downto 0);
 signal incr1  : unsigned(synBits-1 downto 0);
 signal incr2  : unsigned(synBits-1 downto 0);
 signal accel  : unsigned(synBits-1 downto 0);
 signal aval   : unsigned(synBits-1 downto 0);

 signal decelActive : std_logic := '0';

 signal accelCount : unsigned(countBits-1 downto 0);
 --signal accelSum  : unsigned(synBits-1 downto 0);

 alias opD     : unsigned is F_Ld_Axis_D;
 alias opIncr1 : unsigned is F_Ld_Axis_Incr1;
 alias opIncr2 : unsigned is F_Ld_Axis_Incr2;
 alias opAccel : unsigned is F_Ld_Axis_Accel_Val;
 alias opAccelCount : unsigned is F_Ld_Axis_Accel_Count;

 signal lastDir : std_logic := '0';

 signal xinc    : std_logic := '0';
 signal yinc    : std_logic := '0';
 signal clr_pos : std_logic;
 
 signal dValShift       : std_logic;
 signal incr1Shift      : std_logic;
 signal incr2Shift      : std_logic;
 signal accelShift      : std_logic;
 signal accelCountShift : std_logic;

 signal accelAdd : std_logic := '0';
 signal accelClr : std_logic := '0';
 signal accelUpdate : std_logic := '0';

 signal accelCountDec : std_logic := '0';
 signal accelCountPreset : std_logic := '0';
 signal accelCounter : unsigned(countBits-1 downto 0);
 signal accelCounterZero : std_logic ;

 signal xpos : unsigned(posBits-1 downto 0);
 signal ypos : unsigned(posBits-1 downto 0);
 signal sum :  unsigned(synBits-1 downto 0);
 signal accelSum : unsigned(synBits-1 downto 0);

 signal xPosDout : std_logic;
 signal yPosDout : std_logic;
 signal accelSumDout : std_logic;

begin

 dout <= xPosDout or yPosDout or accelSumDout;
 
 dValShift <= '1' when ((op = (opBase + opD)) and (dshift = '1')) else '0';

 dreg: Shift
  generic map(synBits)
  port map (
   clk => clk,
   shift => dValShift,
   din => din,
   data => d);

 incr1Shift <= '1' when ((op = (opBase + opIncr1)) and (dshift = '1')) else '0';

 incr1reg: Shift
  generic map(synBits)
  port map (
   clk => clk,
   shift => incr1Shift,
   din => din,
   data => incr1);

 incr2Shift <= '1' when ((op = (opBase + opIncr2)) and (dshift = '1')) else '0';

 incr2reg: Shift
  generic map(synBits)
  port map (
   clk => clk,
   shift => incr2Shift,
   din => din,
   data => incr2);

 accelShift <= '1' when ((op = (opBase + opAccel)) and (dshift = '1')) else '0';

 accelreg: Shift
  generic map(synBits)
  port map (
   clk => clk,
   shift => accelShift,
   din => din,
   data => accel);

 accelCountShift <= '1' when ((op = (opBase + opAccelCount)) and
                            (dshift = '1')) else '0';

 accelCountReg: Shift
  generic map(n => countBits)
  port map (
   clk => clk,
   shift => accelCountShift,
   din => din,
   data => accelCount);

 mux: DataSel4
  generic map(n => synBits)
  port map (
   sel => mux_sel,
   data0 => d,
   data1 => incr1,
   data2 => incr2,
   data3 => accelSum,
   data_out => aval);

 xadder: Adder
  generic map(n => synBits)
  port map (
   clk => clk,
   ena => adder_ena,
   load => adder_load,
   func => dir,
   a => aval,
   sum => sum);

 accelAdd <= not decelActive;

 accelAccum: Accumulator
  generic map(n => synBits)
  port map (
   clk => clk,
   ena => accelUpdate,
   clr => accelClr,
   func => accelAdd,
   a => accel,
   sum => accelSum,
   zero => open
  );
 
 accelSum_Out: ShiftOut
  generic map(opVal => opBase + F_Rd_Accel_Sum,
              opBits => opBits,
              n => synBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   load => copy,
   data => accelSUm,
   dout => accelSumDout
   );

 accelCtr: DownCounter
  generic map(n => countBits)
  port map (
   clk => clk,
   ena => accelCountDec,
   load => accelCountPreset,
   preset => accelCount,
   counter => accelCounter,
   zero => accelCounterZero);

 xposreg: UpDownClrCtr
  generic map(n => posBits)
  port map (
   clk => clk,
   ena => xinc,
   inc => dir,
   clr => clr_pos,
   counter => xpos);

 xPos_Shift : ShiftOut
  generic map(opVal => opBase + F_Rd_XPos,
              opBits => opBits,
              n => posBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   load => copy,
   data => xPos,
   dout => xPosDout
   );

 yposreg: UpDownClrCtr
  generic map(n => posBits)
  port map (
   clk => clk,
   ena => yinc,
   inc => dir,
   clr => clr_pos,
   counter => ypos);

 yPos_Shift : ShiftOut
  generic map(opVal => opBase + F_Rd_YPos,
              opBits => opBits,
              n => posBits)
  port map (
   clk => clk,
   dshift => dshift,
   op => op,
   load => copy,
   data => yPos,
   dout => yPosDout
   );

 accelFlag <= '1' when decelActive = '0' and accelCounterZero = '0' else '0';

 syn_process: process(clk)
 begin
  if (rising_edge(clk)) then            --if clock active
   if (init = '1') then                 --initialize variables
    lastDir <= dir;
    --position counters
    xinc <= '0';                        --disable x inc
    yinc <= '0';                        --disable y inc
    clr_pos <= '1';                     --set to clear position
    --sum mux
    mux_sel <= SelD;                    --select d to load
    adder_load <= '1';                  --set to init adder
    mux_sel <= SelD;                    --select d to load
    adder_ena <= '1';                   --enable for loading
    --acceleration registers
    accelCountPreset <= '1';            --preset acceleration counter
    accelUpdate <= '1';                 --flag to update it
    accelClr <= '1';                    --clear acceleration sum
    decelActive <= '0';                 --clear deceleration flag
    --misc
    synStep <= '0';                      --clear output step
    state <= idle;                      --set to idle state
   else
    case state is                       --select state
     when idle =>                       --idle
      clr_pos <= '0';                   --finish clear operation

      adder_ena <= '0';                 --end enable
      mux_sel <= selIncr1;              --select increment 1
      adder_load <= '0';                --end load

      accelUpdate <= '0';               --end update
      accelClr <= '0';                  --end clear operation

      if (decel = '1') and (decelActive = '0') then --if starting decel
       decelActive <= '1';              --start deceleration
       accelCountPreset <= '1';         --start preset for decel countdown
      else
       accelCountPreset <= '0';         --stop preset
      end if;

      synStep <= '0';
      if (ena = '1') then               --if enabled
       if (ch = '1') then               --if encoder change
        state <= chk_dir;               --check for dir change
       end if;
      end if;

     when chk_dir =>                    --check direction for dir change
      accelCountPreset <= '0';          --end preset
      if (dir /= lastDir) then          --if direction change
       lastDir <= dir;                  --update last direction
       adder_ena <= '1';                --enable adder
       mux_sel <= selIncr1;
       state <= dir_upd1;
      else                              --if no direction change
       state <= upd_sum;                --advance to update sum state
      end if;

     when dir_upd1 =>                   --update direction part 1
      mux_sel <= selIncr2;
      state <= dir_upd2;

     when dir_upd2 =>                   --update direction part 2
      state <= upd_sum;

     when upd_sum =>                    --update sum
      adder_ena <= '1';                 --enable adder
      xinc <= '1';                      --enable x increment
      if (dir = '1') then               --if direction positive
       if (sum(synBits-1) = '1') then   --if negative (sign bit set)
        mux_sel <= selIncr1;
       else
        mux_sel <= selIncr2;
        synStep <= '1';                  --enable step pulse
        yinc <= '1';                    --enable y increment
       end if;
      else                              --if direction negative
       if (sum(synBits-1) = '1') then   --if negative (sign bit set)
        mux_sel <= selIncr2;
       else
        mux_sel <= selIncr1;
        synStep <= '1';                  --enable step pulse
        yinc <= '1';                    --enable y increment
       end if;
      end if;
      state <= upd_accel;

     when upd_accel =>                  --update acceleration
      synStep <= '0';                    --clear step pulse
      xinc <= '0';
      yinc <= '0';
      mux_sel <= selAccel;
      if (accelCounterZero = '0') then  --if accel active
       accelUpdate <= '1';
       accelCountDec <= '1';
      end if;
      state <= clr_ena;

     when clr_ena =>                    --clr enable wait for ch inactive
      adder_ena <= '0';                 --disable adder
      accelUpdate <= '0';
      accelCountDec <= '0';
      if (ch = '0') then                --if change flag cleared
       state <= idle;                   --return to idle state
      end if;
    end case;
   end if;
  end if;
 end process;

end Behavioral;
