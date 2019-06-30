#!/bin/sh

TOP=../../game/game_top.v
BOARD=../top.v
TB=../../testbench.v

SRC=../..

mkdir -p run
cd run

vcs -debug_pp            \
    -notice              \
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
    > log                \
    2> err_log           \
    $TOP                 \
    $BOARD               \
    $TB

./simv > sim_log 2> sim_err_log

mv -f vcdplus.vpd vcs_rtl.vpd
cat log err_log sim_log sim_err_log | tee vcs_rtl.log
mv -f sim_log ../zzz_vcs_rtl.log
rm  log err_log sim_err_log

exit
