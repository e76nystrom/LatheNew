onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axistest/clk
add wave -noupdate /axistest/din
add wave -noupdate /axistest/dshift
add wave -noupdate -radix hexadecimal /axistest/op
add wave -noupdate /axistest/copy
add wave -noupdate /axistest/load
add wave -noupdate -radix unsigned /axistest/uut/AxisDistCounter/distCtr
add wave -noupdate -radix decimal /axistest/uut/AxisLocCounter/loc
add wave -noupdate -radix decimal /axistest/uut/AxisSyncAccel/accelCounter
add wave -noupdate -radix decimal /axistest/uut/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /axistest/uut/AxisSyncAccel/ypos
add wave -noupdate /axistest/uut/runState
add wave -noupdate /axistest/copy
add wave -noupdate /axistest/load
add wave -noupdate -radix binary /axistest/uut/axisCtlReg
add wave -noupdate -radix decimal /axistest/uut/AxisSyncAccel/d
add wave -noupdate -radix decimal /axistest/uut/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /axistest/uut/AxisSyncAccel/incr2
add wave -noupdate /axistest/uut/AxisSyncAccel/state
add wave -noupdate -radix decimal /axistest/uut/AxisSyncAccel/sum
add wave -noupdate /axistest/ch
add wave -noupdate /axistest/uut/step
add wave -noupdate -radix decimal /axistest/uut/loc
add wave -noupdate -expand -label {Contributors: locShift} -group {Contributors: sim:/axistest/uut/AxisLocCounter/locShift} /axistest/uut/AxisLocCounter/dshift
add wave -noupdate -expand -label {Contributors: locShift} -group {Contributors: sim:/axistest/uut/AxisLocCounter/locShift} -radix hexadecimal /axistest/uut/AxisLocCounter/op
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10972985 ps} 0}
quietly wave cursor active 1
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
