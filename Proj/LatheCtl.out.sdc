## Generated SDC file "LatheCtl.out.sdc"

## Copyright (C) 2023  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 22.1std.1 Build 917 02/14/2023 SC Lite Edition"

## DATE    "Tue Jun 13 04:17:07 2023"

##
## DEVICE  "EP4CE22F17C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {sysClk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {sysClk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {sys_clk} -source [get_ports {sysClk}] -duty_cycle 50/1 -multiply_by 1 -master_clock {sysClk} [get_nets {sys_clk|altclkctrl_0|SystemClk_altclkctrl_0_sub_component|wire_clkctrl1_outclk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************

set_clock_latency -source   2.000 [get_clocks {sysClk}]
set_clock_latency -source   2.000 [get_clocks {sys_clk}]


#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {sysClk}] -rise_to [get_clocks {sysClk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {sysClk}] -fall_to [get_clocks {sysClk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {sysClk}] -rise_to [get_clocks {sysClk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {sysClk}] -fall_to [get_clocks {sysClk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

