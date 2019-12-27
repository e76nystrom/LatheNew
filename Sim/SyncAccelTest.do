onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /syncacceltest/din
add wave -noupdate /syncacceltest/dshift
add wave -noupdate -radix unsigned /syncacceltest/op
add wave -noupdate /syncacceltest/init
add wave -noupdate /syncacceltest/uut/clk
add wave -noupdate /syncacceltest/ena
add wave -noupdate /syncacceltest/ch
add wave -noupdate -radix decimal /syncacceltest/uut/d
add wave -noupdate -radix unsigned /syncacceltest/uut/incr1
add wave -noupdate -radix decimal /syncacceltest/uut/incr2
add wave -noupdate -radix decimal /syncacceltest/uut/sum
add wave -noupdate -radix unsigned /syncacceltest/uut/xpos
add wave -noupdate -radix unsigned /syncacceltest/uut/ypos
add wave -noupdate -radix unsigned /syncacceltest/uut/accelCount
add wave -noupdate -radix unsigned /syncacceltest/uut/accelCounter
add wave -noupdate -radix unsigned /syncacceltest/uut/accelSum
add wave -noupdate -radix unsigned /syncacceltest/uut/aval
add wave -noupdate /syncacceltest/uut/state
add wave -noupdate /syncacceltest/distZero
add wave -noupdate -radix unsigned /syncacceltest/uut/accelAccum/a
add wave -noupdate -radix unsigned /syncacceltest/uut/accelAccum/sum
add wave -noupdate -radix unsigned /syncacceltest/AxisDistCounter/distCtr
add wave -noupdate -radix unsigned /syncacceltest/AxisDistCounter/aclSteps
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3205000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 260
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
WaveRestoreZoom {0 ps} {50724314 ps}
