#!/bin/bash

#export MODELSIM_ROOTDIR=${HOME}/intelFPGA_lite/18.1/modelsim_ase
#export PATH=${PATH}:${MODELSIM_ROOTDIR}/linux

#export QUARTUS_ROOTDIR=${HOME}/altera/13.0sp1/quartus
#export QUARTUS_ROOTDIR=${HOME}/intelFPGA_lite/18.1/quartus
#export PATH=${PATH}:${QUARTUS_ROOTDIR}/bin

#export QSYS_ROOTDIR="/home/verilog/intelFPGA_lite/18.1/quartus/sopc_builder/bin"

rm -rf sim
mkdir sim
cd sim

#export MODELSIM_ROOTDIR=${QSYS_ROOTDIR}/../../../modelsim_ase
#export PATH=${PATH}:${MODELSIM_ROOTDIR}/bin
#export MTI_VCO_MODE=64

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/lib32

#which vsim
vsim -do ../script_for_modelsim.tcl
cd .. && rm -rf sim
