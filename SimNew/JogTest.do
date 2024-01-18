onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_jogtest/uut/timer
add wave -noupdate /a_jogtest/uut/uSec
add wave -noupdate -radix unsigned /a_jogtest/uut/deltaTimer
add wave -noupdate /a_jogtest/uut/update
add wave -noupdate /a_jogtest/uut/jogUpdLoc
add wave -noupdate -radix unsigned /a_jogtest/uut/jogTimer
add wave -noupdate -radix unsigned /a_jogtest/uut/deltaJog
add wave -noupdate -radix unsigned /a_jogtest/uut/jogDist
add wave -noupdate -radix unsigned /a_jogtest/uut/jogInc
add wave -noupdate /a_jogtest/uut/jogActive
add wave -noupdate -radix unsigned /a_jogtest/uut/incDist
add wave -noupdate -radix unsigned /a_jogtest/uut/backlashDist
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {41842311 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 188
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {105105 ns}
