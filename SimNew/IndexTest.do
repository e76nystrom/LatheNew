onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/clk
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/dbgFreq_gen/pulseOut
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/phase_counter/phaseVal
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/phase_counter/phaseCtr
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/phase_counter/syncOut
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/clockCounter
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/clockReg
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encLe
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encScaleVal
add wave -noupdate -radix decimal -childformat {{/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encScaleCount(3) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encScaleCount(2) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encScaleCount(1) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encScaleCount(0) -radix decimal}} -subitemconfig {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encScaleCount(3) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encScaleCount(2) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encScaleCount(1) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encScaleCount(0) {-height 15 -radix decimal}} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encScaleCount
add wave -noupdate -radix unsigned -childformat {{/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(5) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(4) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(3) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(2) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(1) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(0) -radix decimal}} -subitemconfig {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(5) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(4) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(3) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(2) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(1) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter(0) {-height 15 -radix decimal}} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCounter
add wave -noupdate -radix unsigned /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/encCountVal
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/phaseEncIn
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/phaseSyncIn
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/indexLE
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/active
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/index_clocks/turnCount
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/indexAxisEna
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {28925000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 683
configure wave -valuecolwidth 106
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
