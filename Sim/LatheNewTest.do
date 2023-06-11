onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathenewtest/uut/sysClk
add wave -noupdate /a_lathenewtest/uut/aIn
add wave -noupdate /a_lathenewtest/uut/bIn
add wave -noupdate /a_lathenewtest/uut/dsel
add wave -noupdate -radix hexadecimal /a_lathenewtest/uut/op
add wave -noupdate -color Gold /a_lathenewtest/uut/ch
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/d
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/incr2
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/accel
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/ypos
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/sum
add wave -noupdate /a_lathenewtest/uut/z_Axis/synStepOut
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisLocCounter/loc
add wave -noupdate /a_lathenewtest/uut/zStep
add wave -noupdate /a_lathenewtest/uut/quad_encoder/dir
add wave -noupdate /a_lathenewtest/uut/spiCopy
add wave -noupdate /a_lathenewtest/uut/load
add wave -noupdate /a_lathenewtest/uut/spiShift
add wave -noupdate /a_lathenewtest/uut/dshift
add wave -noupdate -radix hexadecimal /a_lathenewtest/uut/clk_reg/data
add wave -noupdate -radix hexadecimal /a_lathenewtest/uut/clk_reg/op
add wave -noupdate /a_lathenewtest/uut/clk_reg/opVal
add wave -noupdate /a_lathenewtest/uut/clk_reg/sreg
add wave -noupdate -radix hexadecimal /a_lathenewtest/uut/z_Axis/AxCtlReg/data
add wave -noupdate -radix hexadecimal /a_lathenewtest/uut/z_Axis/AxCtlReg/op
add wave -noupdate -radix hexadecimal /a_lathenewtest/uut/z_Axis/AxCtlReg/sreg
add wave -noupdate /a_lathenewtest/uut/spiActive
add wave -noupdate /a_lathenewtest/uut/zDoneInt
add wave -noupdate /a_lathenewtest/uut/status/data
add wave -noupdate /a_lathenewtest/uut/status/dout
add wave -noupdate /a_lathenewtest/uut/xDoneInt
add wave -noupdate /a_lathenewtest/uut/z_Axis/AxisDro/decelDisable
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisDro/decelLimit
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisDro/droEnd
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisDro/droDist
add wave -noupdate -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/distVal
add wave -noupdate /a_lathenewtest/uut/z_Axis/AxisSyncAccel/loadDist
add wave -noupdate /a_lathenewtest/uut/z_Axis/AxisSyncAccel/distUpdate
add wave -noupdate -expand -group Accel -color Blue /a_lathenewtest/uut/z_Axis/AxisSyncAccel/init
add wave -noupdate -expand -group Accel /a_lathenewtest/uut/z_Axis/AxisSyncAccel/ena
add wave -noupdate -expand -group Accel -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/accelCount
add wave -noupdate -expand -group Accel -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/accelCounter
add wave -noupdate -expand -group Accel -color Red /a_lathenewtest/uut/z_Axis/AxisSyncAccel/state
add wave -noupdate -expand -group Accel /a_lathenewtest/uut/z_Axis/AxisSyncAccel/accelState
add wave -noupdate -expand -group Accel -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/accelSum
add wave -noupdate -expand -group Accel -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/accelSteps
add wave -noupdate -expand -group Accel -color Gold -radix decimal /a_lathenewtest/uut/z_Axis/AxisSyncAccel/distCtr
add wave -noupdate -expand -group Accel /a_lathenewtest/uut/z_Axis/AxisSyncAccel/synStep
add wave -noupdate -expand -group Accel /a_lathenewtest/uut/z_Axis/AxisSyncAccel/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {162845000 ps} 0} {{Cursor 2} {84535172 ps} 0} {{Cursor 3} {31025000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 339
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {213557490 ps}
