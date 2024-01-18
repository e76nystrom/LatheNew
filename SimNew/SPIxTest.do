onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /a_spixtest/uut/count
add wave -noupdate -radix unsigned /a_spixtest/uut/dSelDly
add wave -noupdate -radix hexadecimal /a_spixtest/uut/opReg
add wave -noupdate /a_spixtest/uut1/opSel
add wave -noupdate /a_spixtest/uut1/ctlState
add wave -noupdate -radix hexadecimal /a_spixtest/uut1/dataReg
add wave -noupdate /a_spixtest/uut1/writeEna
add wave -noupdate -radix unsigned /a_spixtest/uut1/wrAddress
add wave -noupdate -radix unsigned /a_spixtest/uut1/dataCount
add wave -noupdate /a_spixtest/ena
add wave -noupdate /a_spixtest/uut1/statusReg
add wave -noupdate /a_spixtest/uut1/runState
add wave -noupdate -radix unsigned /a_spixtest/uut1/rdAddress
add wave -noupdate -color Salmon -radix hexadecimal -childformat {{/a_spixtest/uut1/outData(7) -radix hexadecimal} {/a_spixtest/uut1/outData(6) -radix hexadecimal} {/a_spixtest/uut1/outData(5) -radix hexadecimal} {/a_spixtest/uut1/outData(4) -radix hexadecimal} {/a_spixtest/uut1/outData(3) -radix hexadecimal} {/a_spixtest/uut1/outData(2) -radix hexadecimal} {/a_spixtest/uut1/outData(1) -radix hexadecimal} {/a_spixtest/uut1/outData(0) -radix hexadecimal}} -subitemconfig {/a_spixtest/uut1/outData(7) {-color Salmon -height 15 -radix hexadecimal} /a_spixtest/uut1/outData(6) {-color Salmon -height 15 -radix hexadecimal} /a_spixtest/uut1/outData(5) {-color Salmon -height 15 -radix hexadecimal} /a_spixtest/uut1/outData(4) {-color Salmon -height 15 -radix hexadecimal} /a_spixtest/uut1/outData(3) {-color Salmon -height 15 -radix hexadecimal} /a_spixtest/uut1/outData(2) {-color Salmon -height 15 -radix hexadecimal} /a_spixtest/uut1/outData(1) {-color Salmon -height 15 -radix hexadecimal} /a_spixtest/uut1/outData(0) {-color Salmon -height 15 -radix hexadecimal}} /a_spixtest/uut1/outData
add wave -noupdate -radix unsigned /a_spixtest/uut1/len
add wave -noupdate -radix unsigned /a_spixtest/uut1/cmd
add wave -noupdate -radix hexadecimal /a_spixtest/uut1/opOut
add wave -noupdate -radix unsigned /a_spixtest/uut1/seqReg
add wave -noupdate /a_spixtest/uut/msgData
add wave -noupdate /a_spixtest/uut/shift
add wave -noupdate /a_spixtest/x_op
add wave -noupdate /a_spixtest/x_shift
add wave -noupdate /a_spixtest/clk
add wave -noupdate /a_spixtest/dclk
add wave -noupdate /a_spixtest/uut/clkEna
add wave -noupdate /a_spixtest/din
add wave -noupdate /a_spixtest/dsel
add wave -noupdate /a_spixtest/uut/copy
add wave -noupdate /a_spixtest/x_copy
add wave -noupdate /a_spixtest/uut/load
add wave -noupdate /a_spixtest/x_load
add wave -noupdate /a_spixtest/uut/dSelDis
add wave -noupdate -radix unsigned /a_spixtest/uut/dSelEna
add wave -noupdate /a_spixtest/ena
add wave -noupdate /a_spixtest/init
add wave -noupdate /a_spixtest/uut/spiFsm_stateReg
add wave -noupdate /a_spixtest/uut1/shiftProc/data
add wave -noupdate /a_spixtest/uut1/shiftProc/op
add wave -noupdate /a_spixtest/uut1/shiftProc/sel
add wave -noupdate /a_spixtest/uut1/rdSeq/shiftSel
add wave -noupdate /a_spixtest/uut1/rdSeq/shiftReg
add wave -noupdate /a_spixtest/uut1/rdSeq/padding
add wave -noupdate /a_spixtest/uut1/rdSeq/op
add wave -noupdate /a_spixtest/uut1/rdSeq/dout
add wave -noupdate /a_spixtest/uut1/rdSeq/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9734028 ps} 0} {{Cursor 2} {4947 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 210
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
WaveRestoreZoom {0 ps} {77988 ps}
