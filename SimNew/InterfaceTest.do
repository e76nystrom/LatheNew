onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_interfacetest/cfsDataIn
add wave -noupdate /a_interfacetest/cfsDataOut
add wave -noupdate /a_interfacetest/latheCtl
add wave -noupdate /a_interfacetest/latheData
add wave -noupdate /a_interfacetest/re
add wave -noupdate /a_interfacetest/reg
add wave -noupdate /a_interfacetest/reset
add wave -noupdate /a_interfacetest/sysClk
add wave -noupdate /a_interfacetest/interface/dataIn
add wave -noupdate -expand /a_interfacetest/interface/latheCtl
add wave -noupdate /a_interfacetest/interface/recv
add wave -noupdate /a_interfacetest/interface/send
add wave -noupdate /a_interfacetest/regY/shiftReg
add wave -noupdate -expand /a_interfacetest/intR
add wave -noupdate /a_interfacetest/interface/sCount
add wave -noupdate -expand /a_interfacetest/intW
add wave -noupdate /a_interfacetest/we
add wave -noupdate /a_interfacetest/interface/sCount
add wave -noupdate /a_interfacetest/interface/dataOut
add wave -noupdate /a_interfacetest/interface/dataOut(31)
add wave -noupdate /a_interfacetest/interface/latheCtl.shift
add wave -noupdate /a_interfacetest/regX/sreg
add wave -noupdate /a_interfacetest/testReg
add wave -noupdate /a_interfacetest/interface/latheCtl.load
add wave -noupdate /a_interfacetest/interface/latheCtl.copy
add wave -noupdate /a_interfacetest/interface/rCount
add wave -noupdate /a_interfacetest/regY/shiftReg
add wave -noupdate /a_interfacetest/regY/shiftSel
add wave -noupdate /a_interfacetest/interface/latheCtl.op
add wave -noupdate /a_interfacetest/interface/recvState
add wave -noupdate /a_interfacetest/interface/sendState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2073949 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {1098109 ps} {1446300 ps}
