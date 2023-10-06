onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /a_lathetoptestriscv/rstn_i
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/imem_req
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/addr
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/mem_rom_rd
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/rdata
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/rden
add wave -noupdate /a_lathetoptestriscv/aux(6)
add wave -noupdate /a_lathetoptestriscv/aux(7)
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn
add wave -noupdate -expand -subitemconfig {/a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl.op {-color Red -height 15}} /a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/cfs_we_o
add wave -noupdate -expand -subitemconfig {/a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_bus_io_switch_inst/dev_20_req_o.re {-color red -height 15 -itemcolor red}} /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_bus_io_switch_inst/dev_20_req_o
add wave -noupdate -color Coral /a_lathetoptestriscv/LatheTopSim/interfaceProc/send
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/sCount
add wave -noupdate -color Yellow /a_lathetoptestriscv/LatheTopSim/interfaceProc/recv
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/shiftOut
add wave -noupdate -divider RunCtl
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/runCtl/data
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/runCtl/sreg
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/latheInt/runCtlRd/padding
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/runCtlRd/dout
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/runCtlRd/shiftReg
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/runCtlRd/shiftSel
add wave -noupdate -divider AxisCtl
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxCtlReg/data
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxCtlReg/sreg
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxCtlRegRd/dout
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl.copy
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxCtlRegRd/shiftReg
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl.shift
add wave -noupdate -radix decimal /a_lathetoptestriscv/LatheTopSim/interfaceProc/rCount
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/z_Axis/AxCtlRegRd/shiftSel
add wave -noupdate -color red -itemcolor Gold -radix hexadecimal /a_lathetoptestriscv/LatheTopSim/interfaceProc/shiftIn
add wave -noupdate /a_lathetoptestriscv/sysClk
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/CFSdataOut
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/dout
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/dout0
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/dout1
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheCtlProc/dout2
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheData.data
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheData.data
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/runRDout
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/delayDout
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/latheInt/latheDout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4144052 ps} 0} {{Cursor 2} {6270226 ps} 0} {{Cursor 3} {4585000 ps} 0} {{Cursor 4} {4583191 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 143
configure wave -valuecolwidth 106
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
WaveRestoreZoom {3564094 ps} {8728337 ps}
