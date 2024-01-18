onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_axistest/clk
add wave -noupdate /a_axistest/din
add wave -noupdate /a_axistest/dshift
add wave -noupdate -radix hexadecimal /a_axistest/op
add wave -noupdate /a_axistest/copy
add wave -noupdate /a_axistest/load
add wave -noupdate -radix unsigned /a_axistest/uut/AxisDistCounter/distCtr
add wave -noupdate -radix decimal /a_axistest/uut/AxisLocCounter/loc
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/accelCounter
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/ypos
add wave -noupdate /a_axistest/uut/runState
add wave -noupdate /a_axistest/copy
add wave -noupdate /a_axistest/load
add wave -noupdate -radix binary /a_axistest/uut/axisCtlReg
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/d
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/incr2
add wave -noupdate /a_axistest/uut/AxisSyncAccel/state
add wave -noupdate /a_axistest/ch
add wave -noupdate /a_axistest/uut/step
add wave -noupdate -expand -label {Contributors: locShift} -group {Contributors: sim:/a_axistest/uut/AxisLocCounter/locShift} -radix hexadecimal /a_axistest/uut/AxisLocCounter/op
add wave -noupdate -expand -label {Contributors: locShift} -group {Contributors: sim:/a_axistest/uut/AxisLocCounter/locShift} -radix hexadecimal /a_axistest/uut/AxisLocCounter/op
add wave -noupdate /a_axistest/clk
add wave -noupdate /a_axistest/din
add wave -noupdate /a_axistest/dshift
add wave -noupdate -radix hexadecimal /a_axistest/op
add wave -noupdate /a_axistest/copy
add wave -noupdate /a_axistest/load
add wave -noupdate -radix unsigned /a_axistest/uut/AxisDistCounter/distCtr
add wave -noupdate -radix decimal /a_axistest/uut/AxisLocCounter/loc
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/accelCounter
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/ypos
add wave -noupdate /a_axistest/uut/runState
add wave -noupdate /a_axistest/copy
add wave -noupdate /a_axistest/load
add wave -noupdate -radix binary /a_axistest/uut/axisCtlReg
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/d
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/incr2
add wave -noupdate /a_axistest/uut/AxisSyncAccel/state
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/sum
add wave -noupdate /a_axistest/ch
add wave -noupdate /a_axistest/uut/step
add wave -noupdate -radix decimal /a_axistest/uut/AxisDistCounter/aclSteps
add wave -noupdate /a_axistest/uut/AxisDistCounter/decel
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/accelCount
add wave -noupdate -radix decimal /a_axistest/uut/AxisSyncAccel/accel
add wave -noupdate /a_axistest/dbgOut(2)
add wave -noupdate /a_axistest/uut/AxisSyncAccel/accelActive
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10972985 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 260
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
WaveRestoreZoom {0 ps} {84 us}
