onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathenewtest/sysClk
add wave -noupdate /a_lathenewtest/uut/spi_int/op
add wave -noupdate /a_lathenewtest/uut/spi_int/count
add wave -noupdate /a_lathenewtest/uut/spi_int/opReg
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/d
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/incr2
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/accel
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/accelCount
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisDistCounter/distCtr
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisLocCounter/loc
add wave -noupdate /a_lathenewtest/uut/z_Axis/stepOut
add wave -noupdate /a_lathenewtest/uut/z_Axis/extUpdLoc
add wave -noupdate /a_lathenewtest/uut/z_Axis/axisUpdLoc
add wave -noupdate /a_lathenewtest/dbg(0)
add wave -noupdate /a_lathenewtest/uut/dclk
add wave -noupdate /a_lathenewtest/uut/din
add wave -noupdate /a_lathenewtest/uut/dout
add wave -noupdate /a_lathenewtest/uut/dsel
add wave -noupdate -expand /a_lathenewtest/uut/z_Axis/axisCtlReg
add wave -noupdate /a_lathenewtest/pinOut(1)
add wave -noupdate /a_lathenewtest/pinOut(0)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {84503133 ps} 0} {{Cursor 2} {46617000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 307
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
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {216958095 ps}
