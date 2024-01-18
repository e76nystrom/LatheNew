onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathenewtest/uut/clk
add wave -noupdate /a_lathenewtest/uut/sysClk
add wave -noupdate /a_lathenewtest/uut/spi_int/op
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/d
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/incr2
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/accelCount
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/accelCounter
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisDistCounter/distCtr
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisLocCounter/loc
add wave -noupdate /a_lathenewtest/dbg(0)
add wave -noupdate /a_lathenewtest/pinOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {162845 ns} 0} {{Cursor 2} {46617 ns} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {0 ns} {210 us}
