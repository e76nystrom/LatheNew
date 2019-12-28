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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {444676 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 54
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
WaveRestoreZoom {309045 ps} {580307 ps}
