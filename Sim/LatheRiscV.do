onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/imem_req
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/addr
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/mem_rom_rd
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/rdata
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/rden
add wave -noupdate /a_lathetoptestriscv/aux(6)
add wave -noupdate /a_lathetoptestriscv/aux(7)
add wave -noupdate -color red -itemcolor red -radix decimal /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/cfs_we_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_bus_io_switch_inst/dev_20_req_o
add wave -noupdate -color Coral /a_lathetoptestriscv/LatheTopSim/interfaceProc/send
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/sCount
add wave -noupdate -color Yellow /a_lathetoptestriscv/LatheTopSim/interfaceProc/recv
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/shiftOut
add wave -noupdate -divider RunCtl
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/runCtl/data
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/runCtl/sreg
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/runCtlRd/padding
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/runCtlRd/dout
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/runCtlRd/shiftReg
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/runCtlRd/shiftSel
add wave -noupdate -divider AxisCtl
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxCtlReg/data
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxCtlReg/sreg
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxCtlRegRd/dout
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl.copy
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxCtlRegRd/shiftReg
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl.shift
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/interfaceProc/rCount
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxCtlRegRd/shiftSel
add wave -noupdate -color red -itemcolor Gold -radix hexadecimal /a_lathetoptestriscv/LatheTopSim/interfaceProc/shiftIn
add wave -noupdate /a_lathetoptestriscv/sysClk
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/CFSdataOut
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/dout
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/distShiftOp/data
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/DistShiftOut/shiftReg
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisCtlR.ctlInit
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisCtlR.ctlSetLoc
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisCtlR.ctlStart
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisStatusR.axDoneDist
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisEna
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/syncState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/dbgFreqGen
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zCh
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zStep
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/distCtr
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/d
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/incr2
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/accel
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/accelCount
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/accelCounter
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/accelSteps
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/accelSum
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/ypos
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/spiCS(0)
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/spiDClk
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/spiDin
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisStatusR.axDistZero
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/droQuad
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/droVal
add wave -noupdate -radix hexadecimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/droQuadState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/droState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {75405000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 683
configure wave -valuecolwidth 106
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {210 us}
