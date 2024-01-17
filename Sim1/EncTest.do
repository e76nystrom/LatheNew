onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/ch
add wave -noupdate -divider PreScaler
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/preScalerCtr
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/scaleCh
add wave -noupdate -divider CmpTmr
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/encCycle
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/encoderClocks
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/clockCounter
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/oldClocks
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/clockTotal
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/cycleClocksOut/data
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/cycleClocks
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/encCount
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/state
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/wEna
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/cmp_tmr/encCycleDone
add wave -noupdate -divider IntTmr
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCycle
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/active
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intRun
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intState
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/cycleClkCtr
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/cycleClkRem
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intClk
add wave -noupdate -radix decimal -childformat {{/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(10) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(9) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(8) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(7) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(6) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(5) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(4) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(3) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(2) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(1) -radix decimal} {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(0) -radix decimal}} -subitemconfig {/a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(10) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(9) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(8) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(7) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(6) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(5) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(4) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(3) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(2) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(1) {-height 15 -radix decimal} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount(0) {-height 15 -radix decimal}} /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCount
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intCountExt
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/cycleDone
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intClkUpd
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intLen
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/encoderProc/int_tmr/intLenCtr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24426494 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 532
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
configure wave -timelineunits ns
update
WaveRestoreZoom {40712617 ps} {44081433 ps}
