vlib work
vlog +incdir+.. +incdir+../../common +incdir+../../game ../*.v ../../common/*.v ../../game/*.v
vsim -novopt work.testbench
add wave -radix bin sim:/testbench/*
run -all
wave zoom full
