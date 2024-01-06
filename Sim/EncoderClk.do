onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/counter
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/loadLimit
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/limitVal
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/runOutCtlR
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/rEnable
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/runOutEna
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zStep
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/xStep
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/encCycle
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/encCount
add wave -noupdate -color Magenta /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/encCycleDone
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCycle
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/ena
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/init
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/inp.op
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/synCtlR
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/clockCounter
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/encCountSave
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/encoderClocks
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/clockCounter
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/clockTotal
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/cycleClocks
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/cycleClkRem
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/active
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intRun
add wave -noupdate -color Red /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/cycleDone
add wave -noupdate /a_lathetoptestriscv/sysClk
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/wEna
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/oldClocks
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/subtract
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intClk
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/preScalerVal
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/usePreScaler
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/preScalerCtr
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encCh
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/ch
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/lastCh
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/scaleCh
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/encCh
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/axisCtlR.ctlInit
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/ch
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/AxisSyncAccel/distCtr
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/AxisSyncAccel/loc
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/stepOut
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/stepOut
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/clkCtlR.xFreqSel
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/xCh
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/clkCtlR.zFreqSel
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zCh
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/dbgFreq_gen/syncOut
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/dbgFreq_gen/syncCounter
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisCtlR.ctlWaitSync
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/runState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/enaOut
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/axisCtlR.ctlChDirect
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/AxisSyncAccel/syncState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/extEna
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/AxisSyncAccel/ena
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {89300106 ps} 0} {{Cursor 3} {42595000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 519
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
WaveRestoreZoom {143655299 ps} {202965511 ps}
