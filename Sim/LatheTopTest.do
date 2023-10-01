onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathetoptest/uut/latheInt/clk
add wave -noupdate /a_lathetoptest/uut/latheInt/dsel
add wave -noupdate /a_lathetoptest/uut/latheInt/spiOp
add wave -noupdate -radix decimal /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/d
add wave -noupdate -radix decimal /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/incr2
add wave -noupdate -radix decimal /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/accel
add wave -noupdate -radix decimal /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/ypos
add wave -noupdate -radix decimal -childformat {{/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(31) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(30) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(29) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(28) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(27) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(26) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(25) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(24) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(23) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(22) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(21) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(20) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(19) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(18) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(17) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(16) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(15) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(14) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(13) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(12) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(11) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(10) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(9) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(8) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(7) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(6) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(5) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(4) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(3) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(2) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(1) -radix decimal} {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(0) -radix decimal}} -subitemconfig {/a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(31) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(30) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(29) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(28) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(27) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(26) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(25) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(24) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(23) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(22) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(21) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(20) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(19) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(18) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(17) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(16) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(15) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(14) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(13) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(12) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(11) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(10) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(9) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(8) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(7) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(6) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(5) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(4) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(3) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(2) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(1) {-height 15 -radix decimal} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum(0) {-height 15 -radix decimal}} /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/sum
add wave -noupdate /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/synStepOut
add wave -noupdate /a_lathetoptest/uut/latheInt/latheCtlProc/zStep
add wave -noupdate /a_lathetoptest/uut/latheInt/latheCtlProc/spiW
add wave -noupdate -expand /a_lathetoptest/uut/latheInt/latheCtlProc/spiR
add wave -noupdate /a_lathetoptest/uut/latheInt/spiActive
add wave -noupdate /a_lathetoptest/uut/latheInt/zDoneInt
add wave -noupdate /a_lathetoptest/uut/latheInt/statusR
add wave -noupdate -radix binary /a_lathetoptest/uut/latheInt/statusReg
add wave -noupdate /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/axisCtlReg
add wave -noupdate /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/axisCtlR.ctlStart
add wave -noupdate /a_lathetoptest/uut/latheInt/latheCtlProc/z_Axis/axisCtlR.ctlInit
add wave -noupdate /a_lathetoptest/uut/latheInt/statusR.zAxisEna
add wave -noupdate /a_lathetoptest/uut/latheInt/statusR.zAxisDone
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9706362 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 413
configure wave -valuecolwidth 100
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
