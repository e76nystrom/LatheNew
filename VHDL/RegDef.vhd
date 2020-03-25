library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package RegDef is

constant opb : positive := 8;


-- phase control

constant F_Ld_Phase_Len     : unsigned(opb-1 downto 0) := x"00"; -- phase length
constant F_Rd_Phase_Syn     : unsigned(opb-1 downto 0) := x"01"; -- read phase at sync pulse
constant F_Phase_Max        : unsigned(opb-1 downto 0) := x"02"; -- number of phase registers

-- controller

constant F_Ld_Ctrl_Data     : unsigned(opb-1 downto 0) := x"00"; -- load controller data
constant F_Ctrl_Cmd         : unsigned(opb-1 downto 0) := x"01"; -- controller command
constant F_Ld_Seq           : unsigned(opb-1 downto 0) := x"02"; -- load sequence
constant F_Rd_Seq           : unsigned(opb-1 downto 0) := x"03"; -- read sequence
constant F_Rd_Ctr           : unsigned(opb-1 downto 0) := x"04"; -- read counter
constant F_Ctrl_Max         : unsigned(opb-1 downto 0) := x"05"; -- number of controller registers

-- reader

constant F_Ld_Read_Data     : unsigned(opb-1 downto 0) := x"00"; -- load reader data
constant F_Read             : unsigned(opb-1 downto 0) := x"01"; -- read data
constant F_Read_Max         : unsigned(opb-1 downto 0) := x"02"; -- number of reader registers

-- PWM

constant F_Ld_PWM_Max       : unsigned(opb-1 downto 0) := x"00"; -- pwm counter maximum
constant F_Ld_PWM_Trig      : unsigned(opb-1 downto 0) := x"00"; -- pwm trigger
constant F_PWM_Max          : unsigned(opb-1 downto 0) := x"01"; -- number of pwm registers

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

constant F_Ld_D             : unsigned(opb-1 downto 0) := x"00"; -- axis d
constant F_Ld_Incr1         : unsigned(opb-1 downto 0) := x"01"; -- axis incr1
constant F_Ld_Incr2         : unsigned(opb-1 downto 0) := x"02"; -- axis incr2
constant F_Ld_Accel_Val     : unsigned(opb-1 downto 0) := x"03"; -- axis accel value
constant F_Ld_Accel_Count   : unsigned(opb-1 downto 0) := x"04"; -- axis accel count
constant F_Rd_XPos          : unsigned(opb-1 downto 0) := x"05"; -- axis x pos
constant F_Rd_YPos          : unsigned(opb-1 downto 0) := x"06"; -- axis y pos
constant F_Rd_Sum           : unsigned(opb-1 downto 0) := x"07"; -- axis sum
constant F_Rd_Accel_Sum     : unsigned(opb-1 downto 0) := x"08"; -- axis accel sum
constant F_Rd_Accel_Ctr     : unsigned(opb-1 downto 0) := x"09"; -- axis accel counter
constant F_Sync_Max         : unsigned(opb-1 downto 0) := x"0a"; -- number of sync registers

-- distance registers

constant F_Ld_Dist          : unsigned(opb-1 downto 0) := x"00"; -- axis distance
constant F_Rd_Dist          : unsigned(opb-1 downto 0) := x"01"; -- read axis distance
constant F_Rd_Acl_Steps     : unsigned(opb-1 downto 0) := x"02"; -- read accel steps
constant F_Dist_Max         : unsigned(opb-1 downto 0) := x"03"; -- number of distance registers

-- location registers

constant F_Ld_Loc           : unsigned(opb-1 downto 0) := x"00"; -- axis location
constant F_Rd_Loc           : unsigned(opb-1 downto 0) := x"01"; -- read axis location
constant F_Loc_Max          : unsigned(opb-1 downto 0) := x"02"; -- number of location registers

-- dro registers

constant F_Ld_Dro           : unsigned(opb-1 downto 0) := x"00"; -- axis dro
constant F_Ld_Dro_End       : unsigned(opb-1 downto 0) := x"00"; -- axis dro end
constant F_Rd_Dro           : unsigned(opb-1 downto 0) := x"01"; -- read axis dro
constant F_Dro_Max          : unsigned(opb-1 downto 0) := x"02"; -- number of dro registers

-- jog registers

constant F_Ld_Jog_Ctl       : unsigned(opb-1 downto 0) := x"00"; -- jog control
constant F_Ld_Jog_Inc       : unsigned(opb-1 downto 0) := x"01"; -- jog increment
constant F_Ld_Jog_Back      : unsigned(opb-1 downto 0) := x"02"; -- jog backlash increment
constant F_Jog_Max          : unsigned(opb-1 downto 0) := x"03"; -- number of jog registers

-- axis

constant F_Ld_Axis_Ctl      : unsigned(opb-1 downto 0) := x"00"; -- axis control register
constant F_Ld_Freq          : unsigned(opb-1 downto 0) := x"01"; -- frequency
constant F_Sync_Base        : unsigned(opb-1 downto 0) := x"02"; -- sync registers
constant F_Dist_Base        : unsigned(opb-1 downto 0) := x"0c"; -- distance registers
constant F_Loc_Base         : unsigned(opb-1 downto 0) := x"0f"; -- location registers
constant F_Dro_Base         : unsigned(opb-1 downto 0) := x"11"; -- dro registers
constant F_Jog_Base         : unsigned(opb-1 downto 0) := x"14"; -- jog registers
constant F_Axis_Max         : unsigned(opb-1 downto 0) := x"17"; -- number of axis registers

-- register definitions

constant F_Noop             : unsigned(opb-1 downto 0) := x"00"; -- register 0

-- status registers

constant F_Rd_Status        : unsigned(opb-1 downto 0) := x"01"; -- status register

-- control registers

constant F_Ld_Run_Ctl       : unsigned(opb-1 downto 0) := x"02"; -- run control register
constant F_Ld_Sync_Ctl      : unsigned(opb-1 downto 0) := x"03"; -- sync control register
constant F_Ld_Cfg_Ctl       : unsigned(opb-1 downto 0) := x"04"; -- config control register
constant F_Ld_Clk_Ctl       : unsigned(opb-1 downto 0) := x"05"; -- clock control register
constant F_Ld_Dsp_Reg       : unsigned(opb-1 downto 0) := x"06"; -- display register

-- controller

constant F_Ctrl_Base        : unsigned(opb-1 downto 0) := x"07"; -- controller

-- reader

constant F_Read_Base        : unsigned(opb-1 downto 0) := x"0c"; -- reader

-- debug frequency control

constant F_Dbg_Freq_Base    : unsigned(opb-1 downto 0) := x"0e"; -- dbg frequency

-- spindle speed

constant F_Rd_Idx_Clks      : unsigned(opb-1 downto 0) := x"10"; -- read clocks between index pulses

-- pwm

constant F_PWM_Base         : unsigned(opb-1 downto 0) := x"11"; -- pwm control

-- base for modules

constant F_Enc_Base         : unsigned(opb-1 downto 0) := x"13"; -- encoder registers
constant F_Phase_Base       : unsigned(opb-1 downto 0) := x"16"; -- phase registers
constant F_ZAxis_Base       : unsigned(opb-1 downto 0) := x"18"; -- z axis registers
constant F_XAxis_Base       : unsigned(opb-1 downto 0) := x"2f"; -- x axis registers
constant F_Cmd_Max          : unsigned(opb-1 downto 0) := x"46"; -- number of commands

end RegDef;

package body RegDef is

end RegDef;
