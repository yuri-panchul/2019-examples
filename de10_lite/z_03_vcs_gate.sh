#!/bin/sh

GATE_SIM_LIB_PATH=../../../../../user/sc_lib/16ffpll/syn_9t
GATE_SIM_LIB=$GATE_SIM_LIB_PATH/ts16ncpllogl16hdl090f.v

# GATE_SIM_LIB_PATH=/mips/proj/sclib3/tsmc/tcbn28hpmbwp12t35cdm4nm/TSMCHOME_120a/digital/Front_End/verilog/tcbn28hpmbwp12t35cdm4nm_120a
# GATE_SIM_LIB=$GATE_SIM_LIB_PATH/tcbn28hpmbwp12t35cdm4nm.v

TOP=game_top
BOARD=../top.v
TB=../testbench.v

SRC=../..

mkdir -p run
cd run

vcs -notice              \
    -sverilog            \
    -timescale=1ns/1ps   \
    +incdir+..           \
    +incdir+$SRC/common  \
    +incdir+$SRC/game    \
    +libext+.v           \
    +libext+.sv          \
    +vcs+vcdpluson       \
    -y ..                \
    -y $SRC/common       \
    -y $SRC/game         \
    +define+GATE_LEVEL   \
    $GATE_SIM_LIB        \
    > log                \
    2> err_log           \
    $TOP                 \
    $BOARD               \
    $TB

./simv > sim_log 2> sim_err_log

mv -f vcdplus.vpd vcs_gate.vpd
cat log err_log sim_log sim_err_log | tee vcs_gate.log
mv -f sim_log ../zzz_vcs_gate.log
rm  log err_log sim_err_log

diff -c ../zzz_vcs_rtl.log ../zzz_vcs_gate.log > ../zzz_vcs_rtl_gate.diff

exit
