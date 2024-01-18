onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lathenewtest/uut/sysClk
add wave -noupdate /lathenewtest/uut/aIn
add wave -noupdate /lathenewtest/uut/bIn
add wave -noupdate /lathenewtest/uut/dsel
add wave -noupdate -radix hexadecimal /lathenewtest/uut/op
add wave -noupdate /lathenewtest/uut/ch
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/d
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/incr2
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/accel
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/aval
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCount
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCounter
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCtrZero
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/ypos
add wave -noupdate -radix decimal -childformat {{/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(31) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(30) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(29) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(28) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(27) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(26) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(25) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(24) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(23) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(22) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(21) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(20) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(19) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(18) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(17) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(16) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(15) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(14) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(13) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(12) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(11) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(10) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(9) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(8) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(7) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(6) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(5) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(4) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(3) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(2) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(1) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(0) -radix decimal}} -subitemconfig {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(31) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(30) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(29) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(28) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(27) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(26) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(25) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(24) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(23) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(22) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(21) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(20) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(19) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(18) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(17) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(16) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(15) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(14) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(13) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(12) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(11) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(10) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(9) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(8) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(7) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(6) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(5) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(4) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(3) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(2) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(1) {-height 15 -radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(0) {-height 15 -radix decimal}} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/xadder/sum(31)
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/accelSum
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/state
add wave -noupdate /lathenewtest/uut/z_Axis/ch
add wave -noupdate /lathenewtest/uut/quad_encoder/dir
add wave -noupdate /lathenewtest/uut/copy
add wave -noupdate /lathenewtest/uut/spiCopy
add wave -noupdate /lathenewtest/uut/load
add wave -noupdate /lathenewtest/uut/spiShift
add wave -noupdate /lathenewtest/uut/dshift
add wave -noupdate /lathenewtest/uut/clk_reg/data
add wave -noupdate /lathenewtest/uut/clk_reg/load
add wave -noupdate -radix hexadecimal /lathenewtest/uut/clk_reg/op
add wave -noupdate /lathenewtest/uut/clk_reg/opVal
add wave -noupdate /lathenewtest/uut/clk_reg/sreg
add wave -noupdate /lathenewtest/uut/z_Axis/AxCtlReg/data
add wave -noupdate /lathenewtest/uut/z_Axis/AxCtlReg/load
add wave -noupdate /lathenewtest/uut/z_Axis/AxCtlReg/op
add wave -noupdate /lathenewtest/uut/z_Axis/AxCtlReg/shift
add wave -noupdate /lathenewtest/uut/z_Axis/AxCtlReg/sreg
add wave -noupdate /lathenewtest/uut/spiActive
add wave -noupdate /lathenewtest/uut/zDoneInt
add wave -noupdate /lathenewtest/uut/status/data
add wave -noupdate /lathenewtest/uut/status/dout
add wave -noupdate /lathenewtest/uut/xDoneInt
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCtrZero
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCtr/atMax
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCtr/atMin
add wave -noupdate -color Cyan -radix unsigned /lathenewtest/uut/z_Axis/AxisDistCounter/aclSteps
add wave -noupdate -color Gold -radix unsigned /lathenewtest/uut/z_Axis/AxisDistCounter/decel
add wave -noupdate -radix unsigned /lathenewtest/uut/z_Axis/AxisDistCounter/distCtr
add wave -noupdate -radix unsigned /lathenewtest/uut/z_Axis/AxisDistCounter/distVal
add wave -noupdate /lathenewtest/uut/z_Axis/AxisDistCounter/distZero
add wave -noupdate -color {Orange Red} /lathenewtest/uut/z_Axis/AxisDistCounter/accelFlag
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCtr/atMax
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCtr/atMin
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCtr/inc
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCtr/limit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50002422 ps} 0} {{Cursor 2} {79024008 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 339
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {157500032 ps}
