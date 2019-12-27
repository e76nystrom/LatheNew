project_open -force "C:/Development/Altera/LatheCtl/Proj/LatheCtl.qpf" -revision LatheCtl
create_timing_netlist -model slow
create_clock -name sysClk -period 20.000 -waveform {0 10} [get_ports {sysClk}]
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty -add -overwrite
update_timing_netlist
write_sdc -expand "LatheCtl.sdc"
derive_clock_uncertainty
update_timing_netlist
write_sdc -expand "LatheCtl.sdc"
catch {delete_timing_netlist}
