library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package RegDef is

constant opb : positive := 8;


-- phase control

constant F_Ld_Phase_Len     : unsigned(opb-1 downto 0) := x"00"; -- phase length
constant F_Rd_Phase_Syn     : unsigned(opb-1 downto 0) := x"01"; -- read phase at sync pulse
constant F_Phase_Max        : unsigned(opb-1 downto 0) := x"02"; -- number of phase registers

-- encoder

constant F_Ld_Enc_Cycle     : unsigned(opb-1 downto 0) := x"00"; -- load encoder cycle
constant F_Ld_Int_Cycle     : unsigned(opb-1 downto 0) := x"01"; -- load internal cycle
constant F_Rd_Cmp_Cyc_Clks  : unsigned(opb-1 downto 0) := x"02"; -- read cmp cycle clocks
constant F_Enc_Max          : unsigned(opb-1 downto 0) := x"03"; -- number of encoder registers

-- debug frequency

constant F_Ld_Dbg_Freq      : unsigned(opb-1 downto 0) := x"00"; -- debug frequency
constant F_Ld_Dbg_Count     : unsigned(opb-1 downto 0) := x"01"; -- debug count
constant F_Dbg_Freq_Max     : unsigned(opb-1 downto 0) := x"02"; -- number of debug frequency regs

-- sync accel

constant F_Ld_Axis_D        : unsigned(opb-1 downto 0) := x"00"; -- axis d
constant F_Ld_Axis_Incr1    : unsigned(opb-1 downto 0) := x"01"; -- axis incr1
constant F_Ld_Axis_Incr2    : unsigned(opb-1 downto 0) := x"02"; -- axis incr2
constant F_Ld_Axis_Accel_Val : unsigned(opb-1 downto 0) := x"03"; -- axis accel value
constant F_Ld_Axis_Accel_Count : unsigned(opb-1 downto 0) := x"04"; -- axis accel count
constant F_Rd_XPos          : unsigned(opb-1 downto 0) := x"05"; -- axis x pos
constant F_Rd_YPos          : unsigned(opb-1 downto 0) := x"06"; -- axis y pos
constant F_Rd_Accel_Sum     : unsigned(opb-1 downto 0) := x"07"; -- axis accel sum
constant F_Sync_Max         : unsigned(opb-1 downto 0) := x"08"; -- number of sync registers

-- distance registers

constant F_Ld_Axis_Dist     : unsigned(opb-1 downto 0) := x"00"; -- axis distance
constant F_Rd_Axis_Dist     : unsigned(opb-1 downto 0) := x"01"; -- read axis distance
constant F_Dist_Max         : unsigned(opb-1 downto 0) := x"02"; -- number of distance registers

-- location registers

constant F_Ld_Axis_Loc      : unsigned(opb-1 downto 0) := x"02"; -- axis location
constant F_Rd_Axis_Loc      : unsigned(opb-1 downto 0) := x"03"; -- read axis location
constant F_Loc_Max          : unsigned(opb-1 downto 0) := x"04"; -- number of location registers

-- axis

constant F_Ld_Axis_Ctl      : unsigned(opb-1 downto 0) := x"00"; -- axis control register
constant F_Sync_Base        : unsigned(opb-1 downto 0) := x"01"; -- sync registers
constant F_Dist_Base        : unsigned(opb-1 downto 0) := x"09"; -- distance registers
constant F_Loc_Base         : unsigned(opb-1 downto 0) := x"0b"; -- location registers
constant F_Axis_Max         : unsigned(opb-1 downto 0) := x"0f"; -- number of axis registers

-- register definitions

constant F_Noop             : unsigned(opb-1 downto 0) := x"00"; -- register 0

-- control registers

constant F_Ld_Sync_Ctl      : unsigned(opb-1 downto 0) := x"01"; -- sync control register
constant F_Ld_Cfg_Ctl       : unsigned(opb-1 downto 0) := x"02"; -- config control register
constant F_Ld_Clk_Ctl       : unsigned(opb-1 downto 0) := x"03"; -- clock control register
constant F_Ld_Dsp_Reg       : unsigned(opb-1 downto 0) := x"04"; -- display register

-- frequency control

constant F_Ld_Z_Freq        : unsigned(opb-1 downto 0) := x"05"; -- z frequency
constant F_Ld_X_Freq        : unsigned(opb-1 downto 0) := x"06"; -- x frequency
constant F_Dbg_Freq_Base    : unsigned(opb-1 downto 0) := x"07"; -- dbg frequency

-- base for modules

constant F_Enc_Base         : unsigned(opb-1 downto 0) := x"09"; -- encoder registers
constant F_Phase_Base       : unsigned(opb-1 downto 0) := x"0c"; -- phase registers
constant F_ZAxis_Base       : unsigned(opb-1 downto 0) := x"0e"; -- z axis registers
constant F_XAxis_Base       : unsigned(opb-1 downto 0) := x"1d"; -- x axis registers
constant F_Cmd_Max          : unsigned(opb-1 downto 0) := x"2c"; -- number of commands

end RegDef;

package body RegDef is

end RegDef;
