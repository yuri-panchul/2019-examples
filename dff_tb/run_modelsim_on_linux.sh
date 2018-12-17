rm -rf sim
mkdir sim
cd sim

vsim -do ../modelsim_script.tcl
cd .. && rm -rf sim
