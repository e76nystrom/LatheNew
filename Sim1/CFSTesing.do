onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/imem_req
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/addr
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/rdata
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/rden
add wave -noupdate /a_lathetoptestriscv/aux(6)
add wave -noupdate /a_lathetoptestriscv/aux(7)
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/bus_req_i
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/bus_rsp_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/cfs_reg_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/cfs_we_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/rCount
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/recvState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/sCount
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/send
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/sendState
add wave -noupdate -color Gold /a_lathetoptestriscv/LatheTopSim/cfs_we_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/cfs_we_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/cfs_reg_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_bus_io_switch_inst/dev_20_req_o
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_bus_io_switch_inst/dev_20_rsp_i
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/riscvCtl
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/riscVCtlReg
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/sysClk
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/cfs_out_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6025000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 698
configure wave -valuecolwidth 104
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
WaveRestoreZoom {5791228 ps} {6162407 ps}
