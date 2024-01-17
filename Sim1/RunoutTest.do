onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/runOutCtlR
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/runOutCtlR.runOutInit
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/runOutCtlR.runOutEna
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/rEnable
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zAxisStep
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/counter
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/RunOut_Ctl/limit
add wave -noupdate -divider {Z Axus}
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisCtlR
add wave -noupdate -color Red /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisCtlR.ctlInit
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisCtlR.ctlStart
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisCtlR.ctlChDirect
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/runState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/syncState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/enaOut
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zExtEna
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/distZero
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/distCtr
add wave -noupdate -divider {X Axis}
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/axisCtlR
add wave -noupdate -color Red /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/axisCtlR.ctlInit
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/axisCtlR.ctlStart
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/axisCtlR.ctlChDirect
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/axisCtlR.ctlSlave
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/runState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/AxisSyncAccel/ena
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/AxisSyncAccel/syncState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/AxisSyncAccel/ena
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/runEna
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/x_Axis/runInit
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/dbg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 496
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
