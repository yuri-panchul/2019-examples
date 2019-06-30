#!/bin/sh

mkdir -p run
cd run

vpd2vcd  -q vcs_gate.vpd vcs_gate.vcd
pt_shell -f ../script_pt.tcl -output_log_file pt.log

cp pt.summary ../zzz_pt.summary
