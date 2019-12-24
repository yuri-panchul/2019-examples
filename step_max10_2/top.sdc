create_clock -period "12.0 MHz" [get_ports clk]

derive_clock_uncertainty

set_false_path -from [get_ports {key[*]}]  -to [all_clocks]
set_false_path -from [get_ports {sw[*]}]   -to [all_clocks]
set_false_path -from [get_ports {gpio[*]}] -to [all_clocks]

set_false_path -from * -to [get_ports {ledr[*]}]
set_false_path -from * -to [get_ports {hex[*]}]

set_false_path -from * -to [get_ports {vga_b[*]}]
set_false_path -from * -to [get_ports {vga_g[*]}]
set_false_path -from * -to vga_hs
set_false_path -from * -to [get_ports {vga_r[*]}]
set_false_path -from * -to vga_vs

set_false_path -from * -to [get_ports {gpio[*]}]
