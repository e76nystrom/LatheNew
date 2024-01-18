onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lathenewfiletest/uut/aIn
add wave -noupdate /lathenewfiletest/uut/bIn
add wave -noupdate /lathenewfiletest/uut/dsel
add wave -noupdate -radix hexadecimal /lathenewfiletest/uut/op
add wave -noupdate /lathenewfiletest/uut/ch
add wave -noupdate -radix decimal /lathenewfiletest/uut/x_Axis/AxisSyncAccel/d
add wave -noupdate -radix decimal /lathenewfiletest/uut/x_Axis/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /lathenewfiletest/uut/x_Axis/AxisSyncAccel/incr2
add wave -noupdate -radix decimal /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accel
add wave -noupdate -radix decimal /lathenewfiletest/uut/x_Axis/AxisSyncAccel/aval
add wave -noupdate -radix decimal /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelCount
add wave -noupdate -radix decimal /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelCounter
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelCtrZero
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelCountUpd
add wave -noupdate /lathenewfiletest/uut/x_Axis/step
add wave -noupdate -radix decimal /lathenewfiletest/uut/x_Axis/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /lathenewfiletest/uut/x_Axis/AxisSyncAccel/ypos
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisSyncAccel/xadder/sum(31)
add wave -noupdate -radix decimal /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelSum
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisSyncAccel/state
add wave -noupdate /lathenewfiletest/uut/x_Axis/ch
add wave -noupdate /lathenewfiletest/uut/quad_encoder/dir
add wave -noupdate /lathenewfiletest/uut/spiCopy
add wave -noupdate /lathenewfiletest/uut/load
add wave -noupdate /lathenewfiletest/uut/spiShift
add wave -noupdate /lathenewfiletest/uut/dshift
add wave -noupdate /lathenewfiletest/uut/clk_reg/data
add wave -noupdate /lathenewfiletest/uut/clk_reg/load
add wave -noupdate -radix hexadecimal /lathenewfiletest/uut/clk_reg/op
add wave -noupdate /lathenewfiletest/uut/clk_reg/opVal
add wave -noupdate /lathenewfiletest/uut/clk_reg/sreg
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxCtlReg/data
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxCtlReg/load
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxCtlReg/op
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxCtlReg/shift
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxCtlReg/sreg
add wave -noupdate /lathenewfiletest/uut/spiActive
add wave -noupdate /lathenewfiletest/uut/xDoneInt
add wave -noupdate /lathenewfiletest/uut/status/data
add wave -noupdate /lathenewfiletest/uut/status/dout
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelCtrZero
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelCtr/atMax
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelCtr/atMin
add wave -noupdate -color Cyan -radix unsigned /lathenewfiletest/uut/x_Axis/AxisDistCounter/aclSteps
add wave -noupdate -color Gold -radix unsigned /lathenewfiletest/uut/x_Axis/AxisDistCounter/decel
add wave -noupdate -radix unsigned /lathenewfiletest/uut/x_Axis/AxisDistCounter/distCtr
add wave -noupdate -radix unsigned /lathenewfiletest/uut/x_Axis/AxisDistCounter/distVal
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisDistCounter/distZero
add wave -noupdate -color {Orange Red} /lathenewfiletest/uut/x_Axis/AxisDistCounter/accelFlag
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelCtr/atMax
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelCtr/atMin
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelCtr/inc
add wave -noupdate /lathenewfiletest/uut/x_Axis/AxisSyncAccel/accelCtr/limit
add wave -noupdate /lathenewfiletest/uut/statusReg
add wave -noupdate /lathenewfiletest/uut/x_Axis/ctlStart
add wave -noupdate /lathenewfiletest/uut/x_Axis/ctlInit
add wave -noupdate /lathenewfiletest/uut/x_Axis/runState
add wave -noupdate -radix unsigned /lathenewfiletest/uut/index_clocks/chCounter
add wave -noupdate -radix unsigned /lathenewfiletest/uut/index_clocks/clockCounter
add wave -noupdate /lathenewfiletest/uut/index_clocks/index
add wave -noupdate /lathenewfiletest/uut/syncIn
add wave -noupdate -radix unsigned /lathenewfiletest/uut/index_clocks/clockReg
add wave -noupdate /lathenewfiletest/uut/index_clocks/active
add wave -noupdate /lathenewfiletest/uut/ctrlProc/init
add wave -noupdate /lathenewfiletest/uut/ctrlProc/ctlState
add wave -noupdate /lathenewfiletest/uut/sysClk
add wave -noupdate -radix unsigned /lathenewfiletest/uut/ctrlProc/wrAddress
add wave -noupdate -radix hexadecimal /lathenewfiletest/uut/ctrlProc/dataReg
add wave -noupdate /lathenewfiletest/uut/ctrlProc/writeEna
add wave -noupdate /lathenewfiletest/uut/ctrlProc/runState
add wave -noupdate -radix unsigned /lathenewfiletest/uut/ctrlProc/dataCount
add wave -noupdate -radix unsigned /lathenewfiletest/uut/ctrlProc/rdAddress
add wave -noupdate -radix hexadecimal /lathenewfiletest/uut/ctrlProc/outData
add wave -noupdate -radix hexadecimal /lathenewfiletest/uut/ctrlProc/memProc/q
add wave -noupdate -radix unsigned /lathenewfiletest/uut/ctrlProc/seqReg
add wave -noupdate -radix hexadecimal /lathenewfiletest/uut/ctrlProc/opOut
add wave -noupdate /lathenewfiletest/uut/ctrlProc/emptyFlag
add wave -noupdate /lathenewfiletest/uut/ctrlProc/init
add wave -noupdate /lathenewfiletest/uut/ctrlProc/dshiftOut
add wave -noupdate /lathenewfiletest/uut/ctrlProc/loadOut
add wave -noupdate -radix hexadecimal /lathenewfiletest/uut/ctrlProc/op
add wave -noupdate /lathenewfiletest/uut/ctrlProc/rdCount/shiftSel
add wave -noupdate -radix unsigned /lathenewfiletest/uut/ctrlProc/rdCount/shiftReg
add wave -noupdate /lathenewfiletest/uut/ctrlProc/rdSeq/shiftSel
add wave -noupdate -radix unsigned /lathenewfiletest/uut/ctrlProc/rdSeq/shiftReg
add wave -noupdate /lathenewfiletest/uut/status/shiftSel
add wave -noupdate -radix unsigned /lathenewfiletest/tmpx
add wave -noupdate /lathenewfiletest/uut/statusReg
add wave -noupdate -radix hexadecimal /lathenewfiletest/uut/spiOp
add wave -noupdate /lathenewfiletest/uut/spiCopy
add wave -noupdate /lathenewfiletest/uut/dataReader/ctlState
add wave -noupdate /lathenewfiletest/uut/dataReader/runState
add wave -noupdate -radix unsigned /lathenewfiletest/uut/dataReader/wrAddress
add wave -noupdate /lathenewfiletest/uut/dataReader/writeEna
add wave -noupdate /lathenewfiletest/uut/spiShift
add wave -noupdate /lathenewfiletest/uut/spiCopy
add wave -noupdate /lathenewfiletest/uut/spiActive
add wave -noupdate /lathenewfiletest/uut/dataReader/active
add wave -noupdate -radix unsigned /lathenewfiletest/uut/dataReader/rdAddress
add wave -noupdate /lathenewfiletest/uut/dataReader/count
add wave -noupdate -radix hexadecimal /lathenewfiletest/uut/dataReader/opOut
add wave -noupdate /lathenewfiletest/uut/dataReader/copyOut
add wave -noupdate /lathenewfiletest/uut/dshiftR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {115682927 ps} 0} {{Cursor 2} {122195000 ps} 0}
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
WaveRestoreZoom {117273124 ps} {127116876 ps}
