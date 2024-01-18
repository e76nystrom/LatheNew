onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label addr /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/imem_req.addr
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/rdata
add wave -noupdate -label data /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/imem_req.data
add wave -noupdate -divider {New Divider}
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/imem_req
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/addr
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/memory_system/neorv32_int_imem_inst_true/neorv32_int_imem_inst/rden
add wave -noupdate /a_lathetoptestriscv/aux(6)
add wave -noupdate /a_lathetoptestriscv/aux(7)
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/bus_req_i
add wave -noupdate -expand -subitemconfig {/a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/bus_rsp_o.ack {-color Tan -height 15}} /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/bus_rsp_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/cfs_reg_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/cfs_we_o
add wave -noupdate -divider RiscvCtl
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/riscVCtl
add wave -noupdate -divider Send
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/send
add wave -noupdate -color Magenta /a_lathetoptestriscv/LatheTopSim/interfaceProc/sendState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/sCount
add wave -noupdate -divider Recv
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/recv
add wave -noupdate -color Cyan /a_lathetoptestriscv/LatheTopSim/interfaceProc/recvState
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/rCount
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/dataIn
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl
add wave -noupdate -divider {New Divider}
add wave -noupdate -color {Orange Red} -label op /a_lathetoptestriscv/LatheTopSim/interfaceProc/latheCtl.op
add wave -noupdate -color Gold /a_lathetoptestriscv/LatheTopSim/cfs_we_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/bus_req_i.stb
add wave -noupdate -color Tan -label ack /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/bus_rsp_o.ack
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/cfs_reg_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_cfs_inst_true/neorv32_cfs_inst/cfs_out_o
add wave -noupdate -divider {New Divider}
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/cfs_we_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_bus_io_switch_inst/dev_20_req_o
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/io_system/neorv32_bus_io_switch_inst/dev_20_rsp_i
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/riscvCtl
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/riscVCtlReg
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/sysClk
add wave -noupdate /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/dmem_req
add wave -noupdate -subitemconfig {/a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/core_complex/neorv32_cpu_inst/neorv32_cpu_control_inst/trap_ctrl.cause -expand} /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/core_complex/neorv32_cpu_inst/neorv32_cpu_control_inst/trap_ctrl
add wave -noupdate -expand /a_lathetoptestriscv/LatheTopSim/neorv32_top_inst/core_complex/neorv32_cpu_inst/neorv32_cpu_control_inst/decode_aux
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6819778 ps} 0}
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
WaveRestoreZoom {0 ps} {105 us}
