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
## VERSION "Version 22.1std.2 Build 922 07/20/2023 SC Lite Edition"

## DATE    "Tue Sep 26 09:55:42 2023"

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

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {sysClk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {sysClk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************

set_clock_latency -source   2.000 [get_clocks {sysClk}]


#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.500  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.500  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.500  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.500  
set_clock_uncertainty -rise_from [get_clocks {sysClk}] -rise_to [get_clocks {sysClk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {sysClk}] -fall_to [get_clocks {sysClk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {sysClk}] -rise_to [get_clocks {sysClk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {sysClk}] -fall_to [get_clocks {sysClk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {aIn}]
set_input_delay -add_delay  -clock [get_clocks {altera_reserved_tck}]  2.000 [get_ports {altera_reserved_tck}]
set_input_delay -add_delay  -clock [get_clocks {altera_reserved_tck}]  2.000 [get_ports {altera_reserved_tdi}]
set_input_delay -add_delay  -clock [get_clocks {altera_reserved_tck}]  2.000 [get_ports {altera_reserved_tms}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {bIn}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {dclk}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {din}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {dsel}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinIn[0]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinIn[1]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinIn[2]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinIn[3]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinIn[4]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {syncIn}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {xDro[0]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {xDro[1]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {xMpg[0]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {xMpg[1]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {zDro[0]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {zDro[1]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {zMpg[0]}]
set_input_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {zMpg[1]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {altera_reserved_tck}]  2.000 [get_ports {altera_reserved_tdo}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {anode[0]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {anode[1]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {anode[2]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {anode[3]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {aux[0]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {aux[1]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {aux[2]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {aux[3]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {aux[4]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {aux[5]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {aux[6]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {aux[7]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {bufOut[0]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {bufOut[1]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {bufOut[2]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {bufOut[3]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {dbg[0]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {dbg[1]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {dbg[2]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {dbg[3]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {dbg[4]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {dbg[5]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {dbg[6]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {dbg[7]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {dout}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {extOut[0]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {extOut[1]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {extOut[2]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {led[0]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {led[1]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {led[2]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {led[3]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {led[4]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {led[5]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {led[6]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {led[7]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[0]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[1]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[2]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[3]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[4]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[5]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[6]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[7]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[8]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[9]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[10]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {pinOut[11]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {seg[0]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {seg[1]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {seg[2]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {seg[3]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {seg[4]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {seg[5]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {seg[6]}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {xDoneInt}]
set_output_delay -add_delay  -clock [get_clocks {sysClk}]  2.000 [get_ports {zDoneInt}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


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

