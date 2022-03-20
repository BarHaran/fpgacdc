create_clock -period 8.000 -name in_clk -waveform {0.000 4.000} [get_ports in_clk]
create_clock -period 4.000 -name out_clk -waveform {0.000 2.000} [get_ports out_clk]
set_false_path -from [get_cells in_toggle_ff_reg] -to [get_cells {dual_ff_sync_inst/first_sample_reg[0]}]
set_max_delay -from [get_cells in_toggle_ff_reg] -to [get_cells {dual_ff_sync_inst/first_sample_reg[0]}] 12.000
