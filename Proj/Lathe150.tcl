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
# File: Lathe150.tcl
# Generated on: Sun Oct  1 16:33:22 2023

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "Lathe150"]} {
		puts "Project Lathe150 is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists Lathe150]} {
		project_open -revision Lathe150 Lathe150
	} else {
		project_new -revision Lathe150 Lathe150
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone IV GX"
	set_global_assignment -name DEVICE EP4CGX150DF27I7
	set_global_assignment -name TOP_LEVEL_ENTITY LatheTop
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 22.1STD.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "04:06:02  JULY 22, 2023"
	set_global_assignment -name LAST_QUARTUS_VERSION "22.1std.2 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP "-40"
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
	set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
	set_global_assignment -name VHDL_SHOW_LMF_MAPPING_MESSAGES OFF
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/LatheTopCore150.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/neorv32/neorv32_top.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/neorv32/neorv32_cfs.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/ExtDataRec.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/IORecord.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/FpgaLatheRec.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/Interface.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/FpgaLatheFunc.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/LatheInterface.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/LatheCtl.vhd
	set_global_assignment -name SDC_FILE Lathe150.sdc
	set_global_assignment -name QSYS_FILE ../LatheNew/Proj/SystemClk.qsys
	set_global_assignment -name QIP_FILE ../LatheNew/Proj/CmpTmrMem2.qip
	set_global_assignment -name QIP_FILE ../LatheNew/Proj/CMem.qip
	set_global_assignment -name QIP_FILE ../LatheNew/Proj/RdMem.qip
	set_global_assignment -name VHDL_FILE ../Encoder/VHDL/Display.vhd
	set_global_assignment -name VHDL_FILE ../Encoder/VHDL/CmpTmrNewMem.vhd
	set_global_assignment -name VHDL_FILE ../Encoder/VHDL/IntTmrNew.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/SPI.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/ShiftOpSel.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/PulseGen.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/DisplayCtl.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/ClockEnaN.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/ClockA.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/ShiftOutNS.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/PhaseCounter.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/IndexClocks.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/Conversion.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/Reader.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/Encoder.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/QuadEncoder.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/SyncAccelNew.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/PWM.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/Spindle.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/FreqGen.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/FreqGenCtr.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/CtlReg.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/ShiftOutN.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/Jog.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/Controller.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/ShiftOpLoad.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/ShiftOp.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/RegDef.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/FpgaLatheBits.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/Axis.vhd
	set_global_assignment -name VHDL_FILE ../LatheNew/VHDL/SyncAccelDistJog.vhd
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_application_image.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_bootloader_image.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_boot_rom.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu_alu.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu_control.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu_cp_bitmanip.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu_cp_cfu.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu_cp_fpu.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu_cp_muldiv.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu_cp_shifter.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu_decompressor.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu_lsu.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu_pmp.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_cpu_regfile.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_crc.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_dcache.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_debug_dm.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_debug_dtm.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_dma.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_fifo.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_gpio.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_gptmr.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_icache.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_intercon.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_mtime.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_neoled.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_onewire.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../LatheNew/neorv32/neorv32_package.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_pwm.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_sdi.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_slink.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_spi.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_sysinfo.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_trng.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_twi.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_uart.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_wdt.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_wishbone.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_xip.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_xirq.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_imem.entity.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/neorv32_dmem.entity.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/mem/neorv32_imem.default.vhd -library neorv32
	set_global_assignment -name VHDL_FILE ../../../neorv32/rtl/core/mem/neorv32_dmem.default.vhd -library neorv32
	set_location_assignment PIN_B14 -to sysClk
	set_location_assignment PIN_A24 -to led[0]
	set_location_assignment PIN_A25 -to led[1]
	set_location_assignment PIN_D23 -to rstn_i
	set_location_assignment PIN_C1 -to dbg_txd_o
	set_location_assignment PIN_D1 -to dbg_rxd_i
	set_location_assignment PIN_B1 -to jtag_tdi_i
	set_location_assignment PIN_B2 -to jtag_tms_i
	set_location_assignment PIN_A2 -to jtag_trst_i
	set_location_assignment PIN_A3 -to jtag_tdo_o
	set_location_assignment PIN_C5 -to jtag_tck_i
	set_location_assignment PIN_C4 -to dsel
	set_location_assignment PIN_B4 -to dclk
	set_location_assignment PIN_A4 -to din
	set_location_assignment PIN_B5 -to dout
	set_location_assignment PIN_B6 -to zDoneInt
	set_location_assignment PIN_B7 -to xDoneInt
	set_location_assignment PIN_A10 -to bIn
	set_location_assignment PIN_B10 -to aIn
	set_location_assignment PIN_B11 -to syncIn
	set_location_assignment PIN_A9 -to bufOut[0]
	set_location_assignment PIN_A8 -to bufOut[1]
	set_location_assignment PIN_C10 -to bufOut[2]
	set_location_assignment PIN_B9 -to bufOut[3]
	set_location_assignment PIN_A13 -to dbg[0]
	set_location_assignment PIN_A12 -to dbg[1]
	set_location_assignment PIN_C12 -to dbg[2]
	set_location_assignment PIN_C11 -to dbg[3]
	set_location_assignment PIN_C13 -to dbg[4]
	set_location_assignment PIN_B13 -to dbg[5]
	set_location_assignment PIN_C15 -to dbg[6]
	set_location_assignment PIN_C14 -to dbg[7]
	set_location_assignment PIN_B15 -to aux[0]
	set_location_assignment PIN_A15 -to aux[1]
	set_location_assignment PIN_A17 -to aux[2]
	set_location_assignment PIN_A16 -to aux[3]
	set_location_assignment PIN_C16 -to aux[4]
	set_location_assignment PIN_B17 -to aux[5]
	set_location_assignment PIN_C17 -to aux[6]
	set_location_assignment PIN_B18 -to aux[7]
	set_location_assignment PIN_C21 -to seg[0]
	set_location_assignment PIN_B23 -to seg[1]
	set_location_assignment PIN_B22 -to seg[2]
	set_location_assignment PIN_A23 -to seg[3]
	set_location_assignment PIN_B19 -to seg[4]
	set_location_assignment PIN_B21 -to seg[5]
	set_location_assignment PIN_A22 -to seg[6]
	set_location_assignment PIN_A18 -to anode[0]
	set_location_assignment PIN_A19 -to anode[1]
	set_location_assignment PIN_A20 -to anode[2]
	set_location_assignment PIN_A21 -to anode[3]
	set_location_assignment PIN_AC17 -to zDro[0]
	set_location_assignment PIN_AD17 -to zDro[1]
	set_location_assignment PIN_AF15 -to xDro[0]
	set_location_assignment PIN_AD16 -to xDro[1]
	set_location_assignment PIN_AC16 -to zMpg[0]
	set_location_assignment PIN_AF16 -to zMpg[1]
	set_location_assignment PIN_AE14 -to xMpg[0]
	set_location_assignment PIN_AE15 -to xMpg[1]
	set_location_assignment PIN_AF24 -to extOut[0]
	set_location_assignment PIN_AF25 -to extOut[1]
	set_location_assignment PIN_AD20 -to extOut[2]
	set_location_assignment PIN_AE23 -to pinOut[0]
	set_location_assignment PIN_AE22 -to pinOut[1]
	set_location_assignment PIN_AF22 -to pinOut[2]
	set_location_assignment PIN_AF21 -to pinOut[3]
	set_location_assignment PIN_AE19 -to pinOut[4]
	set_location_assignment PIN_AF19 -to pinOut[5]
	set_location_assignment PIN_AC19 -to pinOut[6]
	set_location_assignment PIN_AD19 -to pinOut[7]
	set_location_assignment PIN_AD21 -to pinOut[8]
	set_location_assignment PIN_AC21 -to pinOut[9]
	set_location_assignment PIN_AF23 -to pinOut[10]
	set_location_assignment PIN_AF20 -to pinOut[11]
	set_location_assignment PIN_AF18 -to pinIn[0]
	set_location_assignment PIN_AC18 -to pinIn[1]
	set_location_assignment PIN_AD18 -to pinIn[2]
	set_location_assignment PIN_AE17 -to pinIn[3]
	set_location_assignment PIN_AE18 -to pinIn[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to sysClk
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to led[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to led[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rstn_i
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg_rxd_i
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg_txd_o
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg_txd_o
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tdi_i
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tms_i
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_trst_i
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tdo_o
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to jtag_tdo_o
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to jtag_tck_i
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
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[4]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[5]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[6]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dbg[7]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to dbg[7]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[4]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[4]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[5]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[5]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[6]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[6]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to aux[7]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to aux[7]
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
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to anode[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to anode[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to anode[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to anode[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to anode[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to anode[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to anode[3]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to anode[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to zDro[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to zDro[1]
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
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[0]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[1]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[2]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[2]
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
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[8]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[8]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[9]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[9]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[10]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[10]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinOut[11]
	set_instance_assignment -name CURRENT_STRENGTH_NEW 8MA -to pinOut[11]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinIn[0]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinIn[1]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinIn[2]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinIn[3]
	set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pinIn[4]
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
