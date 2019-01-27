#!/bin/sh

rm -rf sim
mkdir sim
cd sim

vcs -sverilog -R ../*.v
dve &
