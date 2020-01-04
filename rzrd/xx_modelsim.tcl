vlib work
vlog ../*.v
vlog ../../common/*.v
vlog ../../game/*.v
vsim -novopt work.testbench
add wave -radix bin sim:/testbench/*
run -all
wave zoom full
