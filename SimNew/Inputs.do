onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/pinIn
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/inputsR
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/inputs/data
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/inputs/oRec.copy
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/inputs/oRec.op
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/zAxisIn
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/inputs/shiftSel
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/inputs/shiftReg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {48393029 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 402
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
WaveRestoreZoom {47140935 ps} {50995808 ps}
