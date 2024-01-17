onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/pinInTest
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/pinIn
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/axisIn
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/accelState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/syncState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/distZero
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/doneHome
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/doneLimit
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/doneProbe
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxisSyncAccel/axisCtl
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/axisStatusR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {47727273 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 683
configure wave -valuecolwidth 106
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
