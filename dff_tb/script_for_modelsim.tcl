vlib work
vlog -vlog01compat +define+USE_STOP_INSTEAD_OF_FINISH +incdir+.. ../*.v
vsim work.tb
add wave sim:/tb/*
run -all
