library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package RegDef is

constant opb : positive := 8;


-- phase control

constant F_Ld_Phase_Len     : unsigned(opb-1 downto 0) := x"00"; -- 'LLN' phase length
constant F_Rd_Phase_Syn     : unsigned(opb-1 downto 0) := x"01"; -- 'RSY' read phase at sync pulse
constant F_Phase_Max        : unsigned(opb-1 downto 0) := x"02"; -- number of phase registers

-- controller

constant F_Ld_Ctrl_Data     : unsigned(opb-1 downto 0) := x"00"; -- 'LCD' load controller data
constant F_Ctrl_Cmd         : unsigned(opb-1 downto 0) := x"01"; -- 'CMD' controller command
constant F_Ld_Seq           : unsigned(opb-1 downto 0) := x"02"; -- 'LSQ' load sequence
constant F_Rd_Seq           : unsigned(opb-1 downto 0) := x"03"; -- 'RSQ' read sequence
constant F_Rd_Ctr           : unsigned(opb-1 downto 0) := x"04"; -- 'RCT' read counter
constant F_Ctrl_Max         : unsigned(opb-1 downto 0) := x"05"; -- number of controller registers

-- reader

constant F_Ld_Read_Data     : unsigned(opb-1 downto 0) := x"00"; -- 'LDR' load reader data
constant F_Read             : unsigned(opb-1 downto 0) := x"01"; -- 'RD'  read data
constant F_Read_Max         : unsigned(opb-1 downto 0) := x"02"; -- number of reader registers

-- PWM

constant F_Ld_PWM_Max       : unsigned(opb-1 downto 0) := x"00"; -- 'MAX' pwm counter maximum
constant F_Ld_PWM_Trig      : unsigned(opb-1 downto 0) := x"00"; -- 'TRG' pwm trigger
constant F_PWM_Max          : unsigned(opb-1 downto 0) := x"01"; -- number of pwm registers

-- encoder

constant F_Ld_Enc_Cycle     : unsigned(opb-1 downto 0) := x"00"; -- 'LEC' load encoder cycle
constant F_Ld_Int_Cycle     : unsigned(opb-1 downto 0) := x"01"; -- 'LIC' load internal cycle
constant F_Rd_Cmp_Cyc_C     : unsigned(opb-1 downto 0) := x"02"; -- 'RCC' read cmp cycle clocks
constant F_Enc_Max          : unsigned(opb-1 downto 0) := x"03"; -- number of encoder registers

-- debug frequency

constant F_Ld_Dbg_Freq      : unsigned(opb-1 downto 0) := x"00"; -- 'DBF' debug frequency
constant F_Ld_Dbg_Count     : unsigned(opb-1 downto 0) := x"01"; -- 'DBC' debug count
constant F_Dbg_Freq_Max     : unsigned(opb-1 downto 0) := x"02"; -- number of debug frequency regs

-- sync accel

constant F_Ld_D             : unsigned(opb-1 downto 0) := x"00"; -- 'LIS' axis initial sum
constant F_Ld_Incr1         : unsigned(opb-1 downto 0) := x"01"; -- 'LI1' axis incr1
constant F_Ld_Incr2         : unsigned(opb-1 downto 0) := x"02"; -- 'LI2' axis incr2
constant F_Ld_Accel_Val     : unsigned(opb-1 downto 0) := x"03"; -- 'LAV' axis accel value
constant F_Ld_Accel_Count   : unsigned(opb-1 downto 0) := x"04"; -- 'LAC' axis accel count
constant F_Rd_XPos          : unsigned(opb-1 downto 0) := x"05"; -- 'RX'  axis x pos
constant F_Rd_YPos          : unsigned(opb-1 downto 0) := x"06"; -- 'RY'  axis y pos
constant F_Rd_Sum           : unsigned(opb-1 downto 0) := x"07"; -- 'RSU' axis sum
constant F_Rd_Accel_Sum     : unsigned(opb-1 downto 0) := x"08"; -- 'RAS' axis accel sum
constant F_Rd_Accel_Ctr     : unsigned(opb-1 downto 0) := x"09"; -- 'RAC' axis accel counter
constant F_Ld_Dist          : unsigned(opb-1 downto 0) := x"0a"; -- 'LDS' axis distance
constant F_Ld_Max_Dist      : unsigned(opb-1 downto 0) := x"0b"; -- 'LMD' jog maximum distance
constant F_Ld_Backlash      : unsigned(opb-1 downto 0) := x"0c"; -- 'LB'  jog backlash
constant F_Rd_Dist          : unsigned(opb-1 downto 0) := x"0d"; -- 'RDS' read axis distance
constant F_Rd_Accel_Steps   : unsigned(opb-1 downto 0) := x"0e"; -- 'RAS' read accel steps
constant F_Ld_Loc           : unsigned(opb-1 downto 0) := x"0f"; -- 'LLC' axis location
constant F_Rd_Loc           : unsigned(opb-1 downto 0) := x"10"; -- 'RLC' read axis location
constant F_Ld_Mpg_Delta     : unsigned(opb-1 downto 0) := x"11"; -- 'LMD' Mpg delta values
constant F_Ld_Mpg_Dist      : unsigned(opb-1 downto 0) := x"12"; -- 'LMS' Mpg dist values
constant F_Ld_Mpg_Div       : unsigned(opb-1 downto 0) := x"13"; -- 'LMV' Mpg div values
constant F_Ld_Dro           : unsigned(opb-1 downto 0) := x"14"; -- 'LDR' axis dro
constant F_Ld_Dro_End       : unsigned(opb-1 downto 0) := x"15"; -- 'LDE' axis dro end
constant F_Ld_Dro_Limit     : unsigned(opb-1 downto 0) := x"16"; -- 'LDL' axis dro decel limit
constant F_Rd_Dro           : unsigned(opb-1 downto 0) := x"17"; -- 'RDR' read axis dro
constant F_Sync_Max         : unsigned(opb-1 downto 0) := x"18"; -- number of sync registers

-- jog registers

constant F_Ld_Jog_Ctl       : unsigned(opb-1 downto 0) := x"00"; -- 'CT' jog control
constant F_Ld_Jog_Inc       : unsigned(opb-1 downto 0) := x"01"; -- 'IN' jog increment
constant F_Ld_Jog_Back      : unsigned(opb-1 downto 0) := x"02"; -- 'JB' jog backlash increment
constant F_Jog_Max          : unsigned(opb-1 downto 0) := x"03"; -- number of jog registers

-- axis

constant F_Rd_Axis_Status   : unsigned(opb-1 downto 0) := x"00"; -- 'RAS' read axis status
constant F_Ld_Axis_Ctl      : unsigned(opb-1 downto 0) := x"01"; -- 'LAC' set axis control reg
constant F_Rd_Axis_Ctl      : unsigned(opb-1 downto 0) := x"02"; -- 'RAC' read axis control reg
constant F_Ld_Freq          : unsigned(opb-1 downto 0) := x"03"; -- 'LFR' frequency
constant F_Sync_Base        : unsigned(opb-1 downto 0) := x"04"; -- sync registers
constant F_Axis_Max         : unsigned(opb-1 downto 0) := x"1c"; -- num of axis regs

-- spindle

constant F_Ld_Sp_Ctl        : unsigned(opb-1 downto 0) := x"00"; -- 'LCT' spindle control reg
constant F_Ld_Sp_Freq       : unsigned(opb-1 downto 0) := x"01"; -- 'LFR' freq for step spindle
constant F_Sp_Jog_Base      : unsigned(opb-1 downto 0) := x"02"; -- 'J' spindle jog
constant F_Sp_Sync_Base     : unsigned(opb-1 downto 0) := x"05"; -- spindle sync

-- register definitions

constant F_Noop             : unsigned(opb-1 downto 0) := x"00"; -- 'NO' reg 0

-- status registers

constant F_Rd_Status        : unsigned(opb-1 downto 0) := x"01"; -- 'RSTS' status reg
constant F_Rd_Inputs        : unsigned(opb-1 downto 0) := x"02"; -- 'RINP' inputs reg

-- control registers

constant F_Ld_Run_Ctl       : unsigned(opb-1 downto 0) := x"03"; -- 'LRUN' set run control reg
constant F_Rd_Run_Ctl       : unsigned(opb-1 downto 0) := x"04"; -- 'RRUN' read run control reg
constant F_Ld_Sync_Ctl      : unsigned(opb-1 downto 0) := x"05"; -- 'LSYN' sync control reg
constant F_Ld_Cfg_Ctl       : unsigned(opb-1 downto 0) := x"06"; -- 'LCFG' config control reg
constant F_Ld_Clk_Ctl       : unsigned(opb-1 downto 0) := x"07"; -- 'LCLK' clock control reg
constant F_Ld_Dsp_Reg       : unsigned(opb-1 downto 0) := x"08"; -- 'LDSP' display reg

-- controller

constant F_Ctrl_Base        : unsigned(opb-1 downto 0) := x"09"; -- 'C' controller

-- reader

constant F_Read_Base        : unsigned(opb-1 downto 0) := x"0e"; -- 'R' reader

-- debug frequency control

constant F_Dbg_Freq_Base    : unsigned(opb-1 downto 0) := x"10"; -- 'D' dbg frequency

-- spindle speed

constant F_Rd_Idx_Clks      : unsigned(opb-1 downto 0) := x"12"; -- 'RIDX' clocks per index

-- step spindle frequency generator


-- pwm

constant F_PWM_Base         : unsigned(opb-1 downto 0) := x"13"; -- 'P' pwm control

-- base for modules

constant F_Enc_Base         : unsigned(opb-1 downto 0) := x"15"; -- 'E' encoder registers
constant F_Phase_Base       : unsigned(opb-1 downto 0) := x"18"; -- 'H' phase registers
constant F_ZAxis_Base       : unsigned(opb-1 downto 0) := x"1a"; -- 'Z' z axis registers
constant F_XAxis_Base       : unsigned(opb-1 downto 0) := x"36"; -- 'X' x axis registers
constant F_Spindle_Base     : unsigned(opb-1 downto 0) := x"52"; -- 'S' spindle registers
constant F_Cmd_Max          : unsigned(opb-1 downto 0) := x"6f"; -- number of commands

end RegDef;

package body RegDef is

end RegDef;
