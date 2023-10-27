onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/cfgCtlR.cfgDroStep
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zDro
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zDroPhase
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zDir
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zStep
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zCurrentDir
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisCtlR
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisStatusR
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/distZero
add wave -noupdate /a_lathetoptestriscv/aux(6)
add wave -noupdate -label op /a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl.op
add wave -noupdate /a_lathetoptestriscv/aux(5)
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/statusR
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/statusR
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/CFSdataOut
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/cfs_reg_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/droVal
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/droQuadState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/droUpdate
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/droVal
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/droUpdate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27185000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 500
configure wave -valuecolwidth 61
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
WaveRestoreZoom {50225 ns} {144725001 ps}
