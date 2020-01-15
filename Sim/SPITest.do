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
add wave -noupdate -radix unsigned /spitest/uut/dselEna
add wave -noupdate -radix unsigned /spitest/uut/dseldly
add wave -noupdate /spitest/uut/header
add wave -noupdate /spitest/uut/load
add wave -noupdate -radix hexadecimal /spitest/uut/op
add wave -noupdate -radix hexadecimal /spitest/uut/opReg
add wave -noupdate /spitest/uut/shift
add wave -noupdate /spitest/uut/spiActive
add wave -noupdate /spitest/uut/state
add wave -noupdate /spitest/uut1/opSel
add wave -noupdate /spitest/uut1/ctlState
add wave -noupdate -radix hexadecimal /spitest/uut1/dataReg
add wave -noupdate /spitest/uut1/writeEna
add wave -noupdate -radix unsigned /spitest/uut1/wrAddress
add wave -noupdate -radix unsigned /spitest/uut1/dataCount
add wave -noupdate /spitest/uut1/empty
add wave -noupdate -radix unsigned /spitest/uut1/data
add wave -noupdate /spitest/ena
add wave -noupdate /spitest/uut1/runState
add wave -noupdate -radix unsigned /spitest/uut1/rdAddress
add wave -noupdate -color Salmon -radix hexadecimal /spitest/uut1/outData
add wave -noupdate -radix hexadecimal /spitest/uut1/rdOp
add wave -noupdate -radix unsigned /spitest/uut1/len
add wave -noupdate -radix unsigned /spitest/uut1/cmd
add wave -noupdate -radix hexadecimal /spitest/uut1/opOut
add wave -noupdate /spitest/uut1/dinOut
add wave -noupdate /spitest/uut1/dshiftOut
add wave -noupdate /spitest/uut1/loadOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16060000 ps} 0} {{Cursor 2} {15060000 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {15502187 ps} {16617813 ps}
