onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /spitest/uut/clk
add wave -noupdate /spitest/uut/clkena
add wave -noupdate /spitest/uut/copy
add wave -noupdate -radix unsigned /spitest/uut/count
add wave -noupdate /spitest/uut/dclk
add wave -noupdate /spitest/uut/din
add wave -noupdate /spitest/uut/dsel
add wave -noupdate /spitest/uut/dselDis
add wave -noupdate /spitest/uut/dselEna
add wave -noupdate /spitest/uut/dseldly
add wave -noupdate /spitest/uut/header
add wave -noupdate /spitest/uut/load
add wave -noupdate -radix hexadecimal /spitest/uut/op
add wave -noupdate -radix hexadecimal /spitest/uut/opReg
add wave -noupdate /spitest/uut/shift
add wave -noupdate /spitest/uut/spiActive
add wave -noupdate /spitest/uut/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 182
configure wave -valuecolwidth 95
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
WaveRestoreZoom {0 ps} {21 us}
