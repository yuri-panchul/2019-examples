#!/bin/sh

mkdir -p run
cd run

dc_shell -f ../script_dc.tcl -output_log_file dc.log

cp dc.summary      ../zzz_dc.summary
cp dc.longest_path ../zzz_dc.longest_path
