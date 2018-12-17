vlib work
vlog -vlog01compat +incdir+.. ../*.v
vsim work.tb
add wave sim:/tb/*
run -all
