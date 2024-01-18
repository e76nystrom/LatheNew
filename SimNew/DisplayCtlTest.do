onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /displayctltest/clk
add wave -noupdate /displayctltest/dsel
add wave -noupdate /displayctltest/din
add wave -noupdate /displayctltest/shift
add wave -noupdate -radix unsigned /displayctltest/op
add wave -noupdate -radix unsigned /displayctltest/dspOp
add wave -noupdate -radix hexadecimal /displayctltest/dspreg
add wave -noupdate /displayctltest/dclk
add wave -noupdate /displayctltest/uut/state
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/displayctltest/uut/state} /displayctltest/uut/clk
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/displayctltest/uut/state} /displayctltest/uut/count
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/displayctltest/uut/state} /displayctltest/uut/dout
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/displayctltest/uut/state} /displayctltest/uut/dsel
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/displayctltest/uut/state} /displayctltest/uut/lastDsel
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/displayctltest/uut/state} -radix unsigned /displayctltest/uut/dspOp
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/displayctltest/uut/state} -radix hexadecimal /displayctltest/uut/dspreg
add wave -noupdate /displayctltest/uut/lastDsel
add wave -noupdate -color Orange /displayctltest/uut/dspShift
add wave -noupdate /displayctltest/uut/dspCopy
add wave -noupdate /displayctltest/uut/dout
add wave -noupdate /displayctltest/uut/opReg/op
add wave -noupdate -radix hexadecimal /displayctltest/testReg
add wave -noupdate -radix hexadecimal /displayctltest/shiftProc/shiftReg
add wave -noupdate /displayctltest/shiftProc/dout
add wave -noupdate /displayctltest/shiftProc/shiftSel
add wave -noupdate -radix unsigned /displayctltest/shiftProc/op
add wave -noupdate /displayctltest/shiftProc/padding
add wave -noupdate /displayctltest/shiftProc/dshift
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2215000 ps} 0} {{Cursor 2} {2535000 ps} 0} {{Cursor 3} {2375000 ps} 0}
quietly wave cursor active 3
configure wave -namecolwidth 220
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
WaveRestoreZoom {1981250 ps} {2768750 ps}
