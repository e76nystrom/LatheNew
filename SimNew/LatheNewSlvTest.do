onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lathenewslvtest/uut/sysClk
add wave -noupdate /lathenewslvtest/uut/aIn
add wave -noupdate /lathenewslvtest/uut/bIn
add wave -noupdate /lathenewslvtest/uut/dsel
add wave -noupdate -radix hexadecimal /lathenewslvtest/uut/op
add wave -noupdate /lathenewslvtest/uut/ch
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/d
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/incr2
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accel
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/aval
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelCount
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelCounter
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/ypos
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisSyncAccel/xadder/sum(31)
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelSum
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisSyncAccel/state
add wave -noupdate /lathenewslvtest/uut/quad_encoder/dir
add wave -noupdate /lathenewslvtest/uut/spiCopy
add wave -noupdate /lathenewslvtest/uut/load
add wave -noupdate /lathenewslvtest/uut/spiShift
add wave -noupdate /lathenewslvtest/uut/dshift
add wave -noupdate /lathenewslvtest/uut/clk_reg/data
add wave -noupdate /lathenewslvtest/uut/clk_reg/load
add wave -noupdate -radix hexadecimal /lathenewslvtest/uut/clk_reg/op
add wave -noupdate /lathenewslvtest/uut/clk_reg/opVal
add wave -noupdate /lathenewslvtest/uut/clk_reg/sreg
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxCtlReg/data
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxCtlReg/load
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxCtlReg/op
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxCtlReg/shift
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxCtlReg/sreg
add wave -noupdate /lathenewslvtest/uut/spiActive
add wave -noupdate /lathenewslvtest/uut/zDoneInt
add wave -noupdate /lathenewslvtest/uut/status/data
add wave -noupdate /lathenewslvtest/uut/status/dout
add wave -noupdate /lathenewslvtest/uut/xDoneInt
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelCtrZero
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelCtr/atMax
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelCtr/atMin
add wave -noupdate -radix unsigned /lathenewslvtest/uut/z_Axis/AxisDistCounter/aclSteps
add wave -noupdate -radix unsigned /lathenewslvtest/uut/z_Axis/AxisDistCounter/decel
add wave -noupdate -radix unsigned /lathenewslvtest/uut/z_Axis/AxisDistCounter/distCtr
add wave -noupdate -radix unsigned /lathenewslvtest/uut/z_Axis/AxisDistCounter/distVal
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisDistCounter/distZero
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisDistCounter/accelFlag
add wave -noupdate -radix hexadecimal /lathenewslvtest/uut/z_Axis/AxCtlReg/data
add wave -noupdate /lathenewslvtest/uut/z_Axis/runState
add wave -noupdate /lathenewslvtest/uut/sysClk
add wave -noupdate /lathenewslvtest/uut/aIn
add wave -noupdate /lathenewslvtest/uut/bIn
add wave -noupdate /lathenewslvtest/uut/dsel
add wave -noupdate -radix hexadecimal /lathenewslvtest/uut/op
add wave -noupdate /lathenewslvtest/uut/ch
add wave -noupdate -divider {Z Axis}
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/d
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/incr2
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accel
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/aval
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelCount
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelCounter
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/ypos
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisSyncAccel/xadder/sum(31)
add wave -noupdate -radix decimal /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelSum
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisSyncAccel/state
add wave -noupdate -divider {X Axis}
add wave -noupdate /lathenewslvtest/uut/x_Axis/ctlSlave
add wave -noupdate /lathenewslvtest/uut/x_Axis/ctlInit
add wave -noupdate /lathenewslvtest/uut/x_Axis/ctlStart
add wave -noupdate /lathenewslvtest/uut/x_Axis/extInit
add wave -noupdate /lathenewslvtest/uut/x_Axis/extEna
add wave -noupdate /lathenewslvtest/uut/x_Axis/axisInit
add wave -noupdate /lathenewslvtest/uut/x_Axis/axisEna
add wave -noupdate /lathenewslvtest/uut/x_Axis/syncAccelEna
add wave -noupdate /lathenewslvtest/uut/x_Axis/AxisSyncAccel/state
add wave -noupdate /lathenewslvtest/uut/x_Axis/ch
add wave -noupdate -radix decimal /lathenewslvtest/uut/x_Axis/AxisSyncAccel/d
add wave -noupdate -radix decimal /lathenewslvtest/uut/x_Axis/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /lathenewslvtest/uut/x_Axis/AxisSyncAccel/incr2
add wave -noupdate -radix decimal /lathenewslvtest/uut/x_Axis/AxisSyncAccel/accel
add wave -noupdate -radix decimal /lathenewslvtest/uut/x_Axis/AxisSyncAccel/aval
add wave -noupdate -radix decimal /lathenewslvtest/uut/x_Axis/AxisSyncAccel/accelCount
add wave -noupdate -radix decimal /lathenewslvtest/uut/x_Axis/AxisSyncAccel/accelCounter
add wave -noupdate -radix decimal /lathenewslvtest/uut/x_Axis/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /lathenewslvtest/uut/x_Axis/AxisSyncAccel/ypos
add wave -noupdate /lathenewslvtest/uut/x_Axis/AxisSyncAccel/xadder/sum(31)
add wave -noupdate -radix decimal /lathenewslvtest/uut/x_Axis/AxisSyncAccel/accelAdd
add wave -noupdate -divider <NULL>
add wave -noupdate -radix decimal /lathenewslvtest/uut/quad_encoder/dir
add wave -noupdate /lathenewslvtest/uut/spiCopy
add wave -noupdate /lathenewslvtest/uut/load
add wave -noupdate /lathenewslvtest/uut/spiShift
add wave -noupdate /lathenewslvtest/uut/dshift
add wave -noupdate /lathenewslvtest/uut/clk_reg/data
add wave -noupdate /lathenewslvtest/uut/clk_reg/load
add wave -noupdate -radix hexadecimal /lathenewslvtest/uut/clk_reg/op
add wave -noupdate /lathenewslvtest/uut/clk_reg/opVal
add wave -noupdate /lathenewslvtest/uut/clk_reg/sreg
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxCtlReg/data
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxCtlReg/load
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxCtlReg/op
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxCtlReg/shift
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxCtlReg/sreg
add wave -noupdate /lathenewslvtest/uut/spiActive
add wave -noupdate /lathenewslvtest/uut/zDoneInt
add wave -noupdate /lathenewslvtest/uut/status/data
add wave -noupdate /lathenewslvtest/uut/status/dout
add wave -noupdate /lathenewslvtest/uut/xDoneInt
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelCtrZero
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelCtr/atMax
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisSyncAccel/accelCtr/atMin
add wave -noupdate -radix unsigned /lathenewslvtest/uut/z_Axis/AxisDistCounter/aclSteps
add wave -noupdate -radix unsigned /lathenewslvtest/uut/z_Axis/AxisDistCounter/decel
add wave -noupdate -radix unsigned /lathenewslvtest/uut/z_Axis/AxisDistCounter/distCtr
add wave -noupdate -radix unsigned /lathenewslvtest/uut/z_Axis/AxisDistCounter/distVal
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisDistCounter/distZero
add wave -noupdate /lathenewslvtest/uut/z_Axis/AxisDistCounter/accelFlag
add wave -noupdate /lathenewslvtest/uut/x_Axis/AxCtlReg/data
add wave -noupdate /lathenewslvtest/uut/clk_reg/data
add wave -noupdate /lathenewslvtest/uut/xCh_Data/sel
add wave -noupdate /lathenewslvtest/uut/xCh_Data/d5
add wave -noupdate /lathenewslvtest/uut/zCh
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {76165854 ps} 0} {{Cursor 2} {122195000 ps} 0}
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
WaveRestoreZoom {17043903 ps} {209629269 ps}
