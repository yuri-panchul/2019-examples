vlib work
vlog -vlog01compat +define+USE_STOP_INSTEAD_OF_FINISH +incdir+.. ../*.v
vlog -sv +incdir+/home/panchul/intelFPGA_lite/18.1/modelsim_ase/verilog_src/uvm-1.2/src /home/panchul/intelFPGA_lite/18.1/modelsim_ase/verilog_src/uvm-1.2/src/uvm.sv
vsim work.tb
add wave sim:/tb/*
run -all
