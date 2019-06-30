#!pt_shell -f

set DESIGN_TOP     game_top
set BOARD_TOP      top
set TESTBENCH      testbench

set ASIC_LIBRARY   /projects/mips/cad/links/libraries/tsmc/16nm/synopsys/FFplusLL/LVT/HD_9tr_CPODE/C16/ts16ncpllogl16hdl090f_base_3.01A/DesignWare_logic_libs/tsmc16nllp/16hd/hdl/lvt/3.01a/liberty/ccs
set SLOW_SLOW      ts16ncpllogl16hdl090f_ssgnp0p72v0c.db
set FAST_FAST      ts16ncpllogl16hdl090f_ffgnp0p88v0c.db

# set ASIC_LIBRARY   /mips/proj/sclib3/tsmc/tcbn28hpmbwp12t35cdm4nm/TSMCHOME_120a/digital/Front_End/timing_power_noise/CCS/tcbn28hpmbwp12t35cdm4nm_120a
# set SLOW_SLOW      tcbn28hpmbwp12t35cdm4nmss0p81v0c_ccs.db
# set FAST_FAST      tcbn28hpmbwp12t35cdm4nmff0p99vm40c_ccs.db

set SEARCH_PATH    ".. $ASIC_LIBRARY"

set_app_var search_path $SEARCH_PATH

# Slow slow corner
set_app_var target_library $SLOW_SLOW

# Fast fast corner
# set_app_var target_library $FAST_FAST

set_app_var link_library "* $target_library"

read_file -format verilog ./${DESIGN_TOP}.vg
current_design "${DESIGN_TOP}"
link

set power_enable_analysis  TRUE
set power_analysis_mode    time_based

update_timing

read_vcd -strip_path $TESTBENCH/i_$DESIGN_TOP ./vcs_gate.vcd

read_parasitics ./${DESIGN_TOP}.spef

create_clock -period 0.5 clk

# ? 0.05
set_clock_transition 0.5 clk

set power_clock_network_include_clock_gating_network true
set_power_analysis_options -waveform_format fsdb -waveform_output wave

check_power
update_power

# report_design
# report_switching_activity -coverage
# report_power_groups
# report_power
# report_power -verbose
# report_power -hierarchy
# report_power -net_power -leaf

report_power > pt.summary

exit
