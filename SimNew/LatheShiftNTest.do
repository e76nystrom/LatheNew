onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /shiftoutntest/clk
add wave -noupdate /shiftoutntest/dshift
add wave -noupdate /shiftoutntest/load
add wave -noupdate /shiftoutntest/dout
add wave -noupdate -radix unsigned /shiftoutntest/uut/padding
add wave -noupdate -radix unsigned /shiftoutntest/data
add wave -noupdate -radix unsigned /shiftoutntest/uut/shiftReg
add wave -noupdate -radix unsigned /shiftoutntest/result
add wave -noupdate /shiftoutntest/uut/shiftSel
add wave -noupdate -radix hexadecimal /shiftoutntest/uut/op
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {225000 ps} 0} {{Cursor 2} {465000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 186
configure wave -valuecolwidth 84
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
WaveRestoreZoom {137229 ps} {662229 ps}
