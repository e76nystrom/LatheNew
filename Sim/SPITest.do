onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_spitest/uut/clkena
add wave -noupdate /a_spitest/uut/copy
add wave -noupdate -radix unsigned /a_spitest/uut/count
add wave -noupdate /a_spitest/uut/dselDis
add wave -noupdate -radix unsigned /a_spitest/uut/dselEna
add wave -noupdate -radix unsigned /a_spitest/uut/dseldly
add wave -noupdate /a_spitest/uut/header
add wave -noupdate /a_spitest/uut/load
add wave -noupdate -radix hexadecimal /a_spitest/uut/op
add wave -noupdate -radix hexadecimal /a_spitest/uut/opReg
add wave -noupdate /a_spitest/uut/shift
add wave -noupdate /a_spitest/uut/state
add wave -noupdate /a_spitest/uut1/opSel
add wave -noupdate /a_spitest/uut1/ctlState
add wave -noupdate -radix hexadecimal /a_spitest/uut1/dataReg
add wave -noupdate /a_spitest/uut1/writeEna
add wave -noupdate -radix unsigned /a_spitest/uut1/wrAddress
add wave -noupdate -radix unsigned /a_spitest/uut1/dataCount
add wave -noupdate /a_spitest/ena
add wave -noupdate /a_spitest/uut1/statusReg
add wave -noupdate /a_spitest/uut1/runState
add wave -noupdate -radix unsigned /a_spitest/uut1/rdAddress
add wave -noupdate -color Salmon -radix hexadecimal /a_spitest/uut1/outData
add wave -noupdate -radix unsigned /a_spitest/uut1/len
add wave -noupdate -radix unsigned /a_spitest/uut1/cmd
add wave -noupdate -radix hexadecimal /a_spitest/uut1/opOut
add wave -noupdate -radix unsigned /a_spitest/uut1/seqReg
add wave -noupdate /a_spitest/dsel
add wave -noupdate /a_spitest/din
add wave -noupdate /a_spitest/dclk
add wave -noupdate /a_spitest/clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {42 us}
