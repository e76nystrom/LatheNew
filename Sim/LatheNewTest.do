onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lathenewtest/uut/sysClk
add wave -noupdate /lathenewtest/uut/aIn
add wave -noupdate /lathenewtest/uut/bIn
add wave -noupdate /lathenewtest/uut/dsel
add wave -noupdate -radix unsigned /lathenewtest/uut/op
add wave -noupdate /lathenewtest/uut/ch
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/d
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/incr1
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/incr2
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/accel
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/aval
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCount
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCounter
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/xpos
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/ypos
add wave -noupdate -radix decimal -childformat {{/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(31) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(30) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(29) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(28) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(27) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(26) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(25) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(24) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(23) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(22) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(21) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(20) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(19) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(18) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(17) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(16) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(15) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(14) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(13) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(12) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(11) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(10) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(9) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(8) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(7) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(6) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(5) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(4) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(3) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(2) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(1) -radix decimal} {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(0) -radix decimal}} -subitemconfig {/lathenewtest/uut/z_Axis/AxisSyncAccel/sum(31) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(30) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(29) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(28) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(27) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(26) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(25) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(24) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(23) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(22) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(21) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(20) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(19) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(18) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(17) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(16) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(15) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(14) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(13) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(12) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(11) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(10) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(9) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(8) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(7) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(6) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(5) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(4) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(3) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(2) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(1) {-radix decimal} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum(0) {-radix decimal}} /lathenewtest/uut/z_Axis/AxisSyncAccel/sum
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/xadder/sum(31)
add wave -noupdate -radix decimal /lathenewtest/uut/z_Axis/AxisSyncAccel/accelSum
add wave -noupdate /lathenewtest/uut/z_Axis/AxisSyncAccel/state
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/lathenewtest/uut/z_Axis/AxisSyncAccel/state} /lathenewtest/uut/z_Axis/AxisSyncAccel/accelCounterZero
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/lathenewtest/uut/z_Axis/AxisSyncAccel/state} /lathenewtest/uut/z_Axis/AxisSyncAccel/ch
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/lathenewtest/uut/z_Axis/AxisSyncAccel/state} /lathenewtest/uut/z_Axis/AxisSyncAccel/clk
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/lathenewtest/uut/z_Axis/AxisSyncAccel/state} /lathenewtest/uut/z_Axis/AxisSyncAccel/decel
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/lathenewtest/uut/z_Axis/AxisSyncAccel/state} /lathenewtest/uut/z_Axis/AxisSyncAccel/decelActive
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/lathenewtest/uut/z_Axis/AxisSyncAccel/state} /lathenewtest/uut/z_Axis/AxisSyncAccel/dir
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/lathenewtest/uut/z_Axis/AxisSyncAccel/state} /lathenewtest/uut/z_Axis/AxisSyncAccel/ena
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/lathenewtest/uut/z_Axis/AxisSyncAccel/state} /lathenewtest/uut/z_Axis/AxisSyncAccel/init
add wave -noupdate -expand -label {Contributors: state} -group {Contributors: sim:/lathenewtest/uut/z_Axis/AxisSyncAccel/state} /lathenewtest/uut/z_Axis/AxisSyncAccel/lastDir
add wave -noupdate /lathenewtest/uut/quad_encoder/dir
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {66614634 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 339
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
WaveRestoreZoom {0 ps} {168234146 ps}
