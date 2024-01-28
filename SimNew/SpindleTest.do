onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/imem_req
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/addr
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/rdata
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/rden
add wave -noupdate /a_lathetoptestriscv/aux(6)
add wave -noupdate /a_lathetoptestriscv/aux(7)
add wave -noupdate -color {Orange Red} -label op -radix decimal /a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl.op
add wave -noupdate -color red -itemcolor red -radix decimal -childformat {{/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(31) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(30) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(29) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(28) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(27) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(26) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(25) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(24) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(23) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(22) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(21) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(20) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(19) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(18) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(17) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(16) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(15) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(14) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(13) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(12) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(11) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(10) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(9) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(8) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(7) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(6) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(5) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(4) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(3) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(2) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(1) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(0) -radix decimal}} -subitemconfig {/a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(31) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(30) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(29) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(28) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(27) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(26) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(25) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(24) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(23) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(22) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(21) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(20) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(19) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(18) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(17) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(16) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(15) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(14) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(13) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(12) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(11) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(10) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(9) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(8) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(7) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(6) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(5) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(4) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(3) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(2) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(1) {-color red -height 15 -itemcolor red -radix decimal} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn(0) {-color red -height 15 -itemcolor red -radix decimal}} /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/cfs_we_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_bus_io_switch_inst/dev_20_req_o
add wave -noupdate -color Coral /a_lathetoptestriscv/LatheTopSim/interfaceProc/send
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/interfaceProc/sCount
add wave -noupdate -color Yellow /a_lathetoptestriscv/LatheTopSim/interfaceProc/recv
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/interfaceProc/shiftOut
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/spCtlR
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/accel
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/d
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/incr1
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/incr2
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/state
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/accelState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/syncState
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/accelMax
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/accelSum
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/sum
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/synStep
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/xpos
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/ypos
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/phase_counter/syncOut
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/phase_counter/phaseCtr
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/phase_counter/phaseSyn
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/phase_counter/phaseVal
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/phase_counter/state
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/synCtlR
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/cfgCtlR
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/spActive
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/phaseChIn
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/decelDone
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/decel
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/decelDone
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleScale/scaleVal
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleSyncAccel/synStep
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/SpindleScale/scaleCtr
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/stepOut
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/spindleProc/preStep
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {30878049 ps} 0}
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
WaveRestoreZoom {0 ps} {42 us}
