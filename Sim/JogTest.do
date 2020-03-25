onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /jogtest/uut/clk
add wave -noupdate /jogtest/uut/timer
add wave -noupdate /jogtest/uut/uSec
add wave -noupdate -radix unsigned /jogtest/uut/deltaTimer
add wave -noupdate /jogtest/uut/quad
add wave -noupdate /jogtest/uut/update
add wave -noupdate /jogtest/uut/jogUpdLoc
add wave -noupdate /jogtest/uut/jogStep
add wave -noupdate /jogtest/uut/jogDir
add wave -noupdate /jogtest/uut/currentDir
add wave -noupdate -radix unsigned /jogtest/uut/jogTimer
add wave -noupdate -radix unsigned /jogtest/uut/deltaJog
add wave -noupdate -radix unsigned /jogtest/uut/jogDist
add wave -noupdate -radix unsigned /jogtest/uut/jogInc
add wave -noupdate /jogtest/uut/jogActive
add wave -noupdate -radix unsigned /jogtest/uut/incDist
add wave -noupdate -radix unsigned /jogtest/uut/backlashDist
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {41842311 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 188
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
WaveRestoreZoom {27180 ns} {53430 ns}
