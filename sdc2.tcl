create_timing_netlist -model slow
read_sdc
update_timing_netlist
create_clock -name sysClk -period 20.000 -waveform {0 10} [get_ports {sysClk}]
update_timing_netlist
derive_pll_clocks -create_base_clocks
update_timing_netlist
derive_clock_uncertainty
update_timing_netlist
set_input_delay -clock { sys_Clk|sys_Clk|altpll_component|auto_generated|pll1|clk[0] } 2 [all_inputs]
set_output_delay -clock { sys_Clk|sys_Clk|altpll_component|auto_generated|pll1|clk[0] } 2 [all_outputs]
update_timing_netlist
report_ucp -panel_name "Unconstrained Paths"
write_sdc -expand "LatheCtl.sdc"
