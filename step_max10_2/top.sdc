create_clock -period "12.0 MHz" [get_ports clk]

derive_clock_uncertainty

set_false_path -from [get_ports {key[*]}]  -to [all_clocks]
set_false_path -from [get_ports {sw[*]}]   -to [all_clocks]
set_false_path -from [get_ports {gpio[*]}] -to [all_clocks]

set_false_path -from * -to [get_ports {led[*]}]
set_false_path -from * -to [get_ports {hex[*]}]
set_false_path -from * -to [get_ports {rgb[*]}]
set_false_path -from * -to [get_ports {gpio[*]}]
