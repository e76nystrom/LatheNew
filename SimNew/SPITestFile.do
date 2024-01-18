onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /spitestfile/uut/clk
add wave -noupdate /spitestfile/uut/clkena
add wave -noupdate /spitestfile/uut/copy
add wave -noupdate -radix unsigned /spitestfile/uut/count
add wave -noupdate /spitestfile/uut/dclk
add wave -noupdate /spitestfile/uut/din
add wave -noupdate /spitestfile/uut/dsel
add wave -noupdate /spitestfile/uut/dselDis
add wave -noupdate -radix unsigned /spitestfile/uut/dselEna
add wave -noupdate -radix unsigned /spitestfile/uut/dseldly
add wave -noupdate /spitestfile/uut/header
add wave -noupdate /spitestfile/uut/load
add wave -noupdate -radix hexadecimal /spitestfile/uut/op
add wave -noupdate -radix hexadecimal /spitestfile/uut/opReg
add wave -noupdate /spitestfile/uut/shift
add wave -noupdate /spitestfile/uut/spiActive
add wave -noupdate /spitestfile/uut/state
add wave -noupdate /spitestfile/uut1/opSel
add wave -noupdate /spitestfile/uut1/ctlState
add wave -noupdate -radix hexadecimal /spitestfile/uut1/dataReg
add wave -noupdate /spitestfile/uut1/writeEna
add wave -noupdate -radix unsigned /spitestfile/uut1/wrAddress
add wave -noupdate -radix unsigned /spitestfile/uut1/dataCount
add wave -noupdate /spitestfile/uut1/empty
add wave -noupdate -radix unsigned /spitestfile/uut1/data
add wave -noupdate /spitestfile/ena
add wave -noupdate /spitestfile/uut1/runState
add wave -noupdate -radix unsigned /spitestfile/uut1/rdAddress
add wave -noupdate -color Salmon -radix hexadecimal /spitestfile/uut1/outData
add wave -noupdate -radix hexadecimal /spitestfile/uut1/rdOp
add wave -noupdate -radix unsigned /spitestfile/uut1/len
add wave -noupdate -radix unsigned /spitestfile/uut1/cmd
add wave -noupdate -radix hexadecimal /spitestfile/uut1/opOut
add wave -noupdate /spitestfile/uut1/dinOut
add wave -noupdate /spitestfile/uut1/dshiftOut
add wave -noupdate /spitestfile/uut1/loadOut
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
