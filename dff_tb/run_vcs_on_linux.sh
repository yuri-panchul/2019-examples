#!/bin/sh

mkdir -p run
cd run

vcs -debug_pp           \
    -notice             \
    -sverilog           \
    -timescale=1ns/1ps  \
    +vcs+vcdpluson      \
    ../*.v

./simv
