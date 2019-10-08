#!/bin/sh

mkdir -p run
cd run

dc_shell -f ../script_dc_all_fsms.tcl -output_log_file dc_all_fsms.log

cp dc_all_fsms.summary      ../zzz_dc_all_fsms.summary
cp dc_all_fsms.longest_path ../zzz_dc_all_fsms.longest_path
