# Copyright (C) 2023  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: LatheCtl.tcl
# Generated on: Sun Oct  1 16:32:48 2023

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "LatheCtl"]} {
		puts "Project LatheCtl is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists LatheCtl]} {
		project_open -revision LatheCtl LatheCtl
	} else {
		project_new -revision LatheCtl LatheCtl
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone IV E"
	set_global_assignment -name DEVICE EP4CE22F17C6
	set_global_assignment -name TOP_LEVEL_ENTITY LatheTop
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 22.1STD
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "05:58:23  DECEMBER 06, 2019"
	set_global_assignment -name LAST_QUARTUS_VERSION "22.1std.2 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name EDA_SIMULATION_TOOL "Questa Intel FPGA (VHDL)"
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
	set_global_assignment -name ENABLE_SIGNALTAP ON
	set_global_assignment -name USE_SIGNALTAP_FILE stp1.stp
	set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON
	set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
	set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
	set_global_assignment -name VHDL_SHOW_LMF_MAPPING_MESSAGES OFF
	set_global_assignment -name SLD_NODE_CREATOR_ID 110 -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_ENTITY_NAME sld_signaltap -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_RAM_BLOCK_TYPE=AUTO" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_DATA_BITS=2" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STORAGE_QUALIFIER_BITS=2" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_NODE_INFO=805334528" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_POWER_UP_TRIGGER=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STORAGE_QUALIFIER_INVERSION_MASK_LENGTH=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_SEGMENT_SIZE=8192" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ATTRIBUTE_MEM_MODE=OFF" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STATE_FLOW_USE_GENERATED=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_STATE_BITS=11" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_BUFFER_FULL_STOP=1" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_CURRENT_RESOURCE_WIDTH=1" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INCREMENTAL_ROUTING=1" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_LEVEL=1" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_SAMPLE_DEPTH=8192" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_IN_ENABLED=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_PIPELINE=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_RAM_PIPELINE=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_COUNTER_PIPELINE=0" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ADVANCED_TRIGGER_ENTITY=basic,1," -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_LEVEL_PIPELINE=1" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_ENABLE_ADVANCED_TRIGGER=0" -section_id auto_signaltap_0
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_TRIGGER_BITS=2" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INVERSION_MASK=000000000000000000000000000000000" -section_id auto_signaltap_0
	set_global_assignment -name SLD_NODE_PARAMETER_ASSIGNMENT "SLD_INVERSION_MASK_LENGTH=33" -section_id auto_signaltap_0
	set_global_assignment -name PROJECT_IP_REGENERATION_POLICY ALWAYS_REGENERATE_IP
	set_global_assignment -name VHDL_FILE ../VHDL/LatheTopNano.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/ClockA.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/ExtDataRec.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/FpgaLatheRec.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/FpgaLatheFunc.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/IORecord.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/LatheInterface.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/LatheCtl.vhd
	set_global_assignment -name SDC_FILE LatheNew.sdc
	set_global_assignment -name VHDL_FILE ../VHDL/Conversion.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/CtlReg.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/ExtSignal.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/RegDef.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/ClockEnaN.vhd
	set_global_assignment -name QSYS_FILE SystemClk.qsys
	set_global_assignment -name QIP_FILE SystemClock10.qip
	set_global_assignment -name QIP_FILE CMem.qip
	set_global_assignment -name QIP_FILE RdMem.qip
	set_global_assignment -name QIP_FILE CmpTmrMem2.qip
	set_global_assignment -name VHDL_FILE ../VHDL/Encoder.vhd
	set_global_assignment -name VHDL_FILE ../../Encoder/VHDL/IntTmrNew.vhd
	set_global_assignment -name VHDL_FILE ../../Encoder/VHDL/CmpTmrNewMem.vhd
	set_global_assignment -name VHDL_FILE ../../Encoder/VHDL/Display.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/Controller.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/Reader.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/SPI.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/Jog.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/PWM.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/IndexClocks.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/PhaseCounter.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/QuadEncoder.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/Spindle.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/SyncAccelNew.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/FreqGen.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/FreqGenCtr.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/Axis.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/PulseGen.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/SyncAccelDistJog.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/DisplayCtl.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/ShiftOp.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/ShiftOpLoad.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/ShiftOpSel.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/ShiftOutN.vhd
	set_global_assignment -name VHDL_FILE ../VHDL/ShiftOutNS.vhd
	set_global_assignment -name SIGNALTAP_FILE stp1.stp
	set_global_assignment -name SLD_FILE db/stp1_auto_stripped.stp
	set_location_assignment PIN_R8 -to sysClk
	set_location_assignment PIN_A15 -to led[0]
	set_location_assignment PIN_A13 -to led[1]
	set_location_assignment PIN_B13 -to led[2]
	set_location_assignment PIN_A11 -to led[3]
	set_location_assignment PIN_D1 -to led[4]
	set_location_assignment PIN_F3 -to led[5]
	set_location_assignment PIN_B1 -to led[6]
	set_location_assignment PIN_L3 -to led[7]
	set_location_assignment PIN_A8 -to dsel
	set_location_assignment PIN_D3 -to dclk
	set_location_assignment PIN_B8 -to din
	set_location_assignment PIN_C3 -to dout
	set_location_assignment PIN_A2 -to zDoneInt
	set_location_assignment PIN_A3 -to xDoneInt
	set_location_assignment PIN_A4 -to bIn
	set_location_assignment PIN_B5 -to aIn
	set_location_assignment PIN_A5 -to syncIn
	set_location_assignment PIN_B6 -to bufOut[0]
	set_location_assignment PIN_A6 -to bufOut[1]
	set_location_assignment PIN_B7 -to bufOut[2]
	set_location_assignment PIN_D6 -to bufOut[3]
	set_location_assignment PIN_A7 -to dbg[1]
	set_location_assignment PIN_C6 -to dbg[0]
	set_location_assignment PIN_C8 -to dbg[3]
	set_location_assignment PIN_E6 -to dbg[2]
	set_location_assignment PIN_E7 -to dbg[5]
	set_location_assignment PIN_D8 -to dbg[4]
	set_location_assignment PIN_E8 -to dbg[7]
	set_location_assignment PIN_F8 -to dbg[6]
	set_location_assignment PIN_B11 -to seg[0]
	set_location_assignment PIN_C9 -to seg[1]
	set_location_assignment PIN_F9 -to seg[2]
	set_location_assignment PIN_D9 -to seg[3]
	set_location_assignment PIN_E10 -to seg[4]
	set_location_assignment PIN_C11 -to seg[5]
	set_location_assignment PIN_E11 -to seg[6]
	set_location_assignment PIN_A12 -to anode[3]
	set_location_assignment PIN_D11 -to anode[0]
	set_location_assignment PIN_D12 -to anode[2]
	set_location_assignment PIN_B12 -to anode[1]
	set_location_assignment PIN_T9 -to zDro[1]
	set_location_assignment PIN_F13 -to zDro[0]
	set_location_assignment PIN_R9 -to xDro[0]
	set_location_assignment PIN_T15 -to xDro[1]
	set_location_assignment PIN_T14 -to zMpg[0]
	set_location_assignment PIN_T13 -to zMpg[1]
	set_location_assignment PIN_R13 -to xMpg[0]
	set_location_assignment PIN_T12 -to xMpg[1]
	set_location_assignment PIN_R12 -to extOut[0]
	set_location_assignment PIN_T11 -to extOut[1]
	set_location_assignment PIN_P15 -to extOut[2]
	set_location_assignment PIN_T10 -to pinOut[8]
	set_location_assignment PIN_R11 -to pinOut[9]
	set_location_assignment PIN_P11 -to pinOut[0]
	set_location_assignment PIN_R10 -to pinOut[1]
	set_location_assignment PIN_N12 -to pinOut[10]
	set_location_assignment PIN_P9 -to pinOut[2]
	set_location_assignment PIN_N9 -to pinOut[11]
	set_location_assignment PIN_N11 -to pinOut[3]
	set_location_assignment PIN_L16 -to pinOut[4]
	set_location_assignment PIN_K16 -to pinOut[5]
	set_location_assignment PIN_R16 -to pinOut[6]
	set_location_assignment PIN_L15 -to pinOut[7]
	set_location_assignment PIN_P16 -to pinIn[4]
	set_location_assignment PIN_R14 -to pinIn[0]
	set_location_assignment PIN_N16 -to pinIn[1]
	set_location_assignment PIN_N15 -to pinIn[2]
	set_location_assignment PIN_P14 -to pinIn[3]
	set_location_assignment PIN_L14 -to aux[7]
	set_location_assignment PIN_N14 -to aux[6]
	set_location_assignment PIN_M10 -to aux[5]
	set_location_assignment PIN_L13 -to aux[4]
	set_location_assignment PIN_J16 -to aux[3]
	set_location_assignment PIN_K15 -to aux[2]
	set_location_assignment PIN_J13 -to aux[1]
	set_location_assignment PIN_J14 -to aux[0]
	set_instance_assignment -name CONNECT_TO_SLD_NODE_ENTITY_PORT acq_clk -to sysClk -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[4] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[7] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[8] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[16] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[17] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[18] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[19] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[24] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[25] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[26] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[27] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[1] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[2] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[6] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[9] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[12] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sysClk
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to led[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to led[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to led[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to led[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[4]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to led[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[5]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to led[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[6]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to led[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[7]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to led[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dsel
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dclk
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to din
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dout
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dout
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to zDoneInt
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to zDoneInt
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to xDoneInt
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to xDoneInt
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to bIn
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aIn
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to syncIn
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to bufOut[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to bufOut[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to bufOut[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to bufOut[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to bufOut[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to bufOut[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to bufOut[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to bufOut[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[5]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[4]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[7]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[6]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to seg[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to seg[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to seg[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to seg[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to seg[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to seg[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to seg[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to seg[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to seg[4]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to seg[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to seg[5]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to seg[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to seg[6]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to seg[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to anode[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to anode[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to anode[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to anode[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to anode[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to anode[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to anode[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to anode[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to zDro[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to zDro[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to xDro[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to xDro[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to zMpg[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to zMpg[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to xMpg[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to xMpg[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to extOut[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to extOut[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to extOut[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to extOut[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to extOut[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to extOut[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[8]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[8]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[9]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[9]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[10]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[10]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[11]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[11]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[4]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[5]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[6]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[7]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinIn[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinIn[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinIn[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinIn[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinIn[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[7]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[6]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[5]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[4]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[0]
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[0] -to "LatheInterface:latheInt|LatheCtl:latheCtlProc|Axis:z_Axis|axisEna" -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT acq_trigger_in[1] -to "LatheInterface:latheInt|LatheCtl:latheCtlProc|Axis:z_Axis|runState.run" -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[0] -to "LatheInterface:latheInt|LatheCtl:latheCtlProc|Axis:z_Axis|axisEna" -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT acq_data_in[1] -to "LatheInterface:latheInt|LatheCtl:latheCtlProc|Axis:z_Axis|runState.run" -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[0] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[3] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[5] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[10] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[11] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[13] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[14] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[15] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[20] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[21] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[22] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[23] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[28] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[29] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[30] -to auto_signaltap_0|vcc -section_id auto_signaltap_0
	set_instance_assignment -name POST_FIT_CONNECT_TO_SLD_NODE_ENTITY_PORT crc[31] -to auto_signaltap_0|gnd -section_id auto_signaltap_0
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
