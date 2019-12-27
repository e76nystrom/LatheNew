onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /phasectrtest/phase_counter/clk
add wave -noupdate /phasectrtest/phase_counter/din
add wave -noupdate /phasectrtest/phase_counter/dshift
add wave -noupdate -radix unsigned /phasectrtest/phase_counter/op
add wave -noupdate /phasectrtest/phase_counter/init
add wave -noupdate /phasectrtest/phase_counter/ch
add wave -noupdate /phasectrtest/phase_counter/sync
add wave -noupdate /phasectrtest/phase_counter/dir
add wave -noupdate /phasectrtest/phase_counter/syncOut
add wave -noupdate /phasectrtest/phase_counter/state
add wave -noupdate -radix unsigned /phasectrtest/phase_counter/phaseVal
add wave -noupdate -radix unsigned /phasectrtest/phase_counter/phaseCtr
add wave -noupdate -radix unsigned /phasectrtest/phase_counter/phaseSyn
add wave -noupdate /phasectrtest/phase_counter/phaseShift
add wave -noupdate /phasectrtest/phase_counter/phaseSel
add wave -noupdate /phasectrtest/phase_counter/phaseSynSel
add wave -noupdate /phasectrtest/phase_counter/phaseSynShift
add wave -noupdate /phasectrtest/phase_counter/genSync
add wave -noupdate /phasectrtest/phase_counter/lastSyn
add wave -noupdate /phasectrtest/phase_counter/copy
add wave -noupdate -radix unsigned /phasectrtest/phase_counter/phaseSynOut/shift
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4665000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 278
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
WaveRestoreZoom {0 ps} {12600 ns}
