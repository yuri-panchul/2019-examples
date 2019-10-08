#!dc_shell -f

# set DESIGN_TOP     game_top
# set DESIGN_TOP     game_sprite_display_wrapper

set DESIGN_TOP     game_master_fsm_wrapper

set SRC            ../..

set ASIC_LIBRARY   /projects/mips/cad/links/libraries/tsmc/16nm/synopsys/FFplusLL/LVT/HD_9tr_CPODE/C16/ts16ncpllogl16hdl090f_base_3.01A/DesignWare_logic_libs/tsmc16nllp/16hd/hdl/lvt/3.01a/liberty/ccs
set SLOW_SLOW      ts16ncpllogl16hdl090f_ssgnp0p72v0c.db
set FAST_FAST      ts16ncpllogl16hdl090f_ffgnp0p88v0c.db

# set ASIC_LIBRARY   /mips/proj/sclib3/tsmc/tcbn28hpmbwp12t35cdm4nm/TSMCHOME_120a/digital/Front_End/timing_power_noise/CCS/tcbn28hpmbwp12t35cdm4nm_120a
# set SLOW_SLOW      tcbn28hpmbwp12t35cdm4nmss0p81v0c_ccs.db
# set FAST_FAST      tcbn28hpmbwp12t35cdm4nmff0p99vm40c_ccs.db

set VERILOG_FILES  ""
set VERILOG_FILES  "$VERILOG_FILES [glob -tails -directory $SRC/game   *.v]"
set VERILOG_FILES  "$VERILOG_FILES [glob -tails -directory $SRC/common *.v]"

set SEARCH_PATH    ..
set SEARCH_PATH    "$SEARCH_PATH $SRC/game"
set SEARCH_PATH    "$SEARCH_PATH $SRC/common"
set SEARCH_PATH    "$SEARCH_PATH $ASIC_LIBRARY"

set_app_var search_path $SEARCH_PATH

# Slow slow corner
set_app_var target_library $SLOW_SLOW

# Fast fast corner
# set_app_var target_library $FAST_FAST

set_app_var link_library "* $target_library"

#-----------------------------------------------------------------------------

proc synthesize_variant { variant } {

    global DESIGN_TOP VERILOG_FILES

    analyze -define GAME_MASTER_FSM_MODULE=game_master_fsm_$variant  \
        -format sverilog $VERILOG_FILES

    elaborate $DESIGN_TOP

    link

    create_clock -period 0.5 clk  

    compile_ultra -gate_clock

    write -format ddc     -hierarchy -output ${DESIGN_TOP}_${variant}.ddc
    write -format verilog -hierarchy -output ${DESIGN_TOP}_${variant}.vg
    write_parasitics                 -output ${DESIGN_TOP}_${variant}.spef

    report_timing -max_path 5
    report_area
    report_power
    report_reference
    report_resources
    report_qor

    report_qor > dc.summary_${variant}
    report_timing -max_path 1 > dc.longest_path_${variant}
}

#-----------------------------------------------------------------------------

synthesize_variant 1_two_always
synthesize_variant 2_three_always
synthesize_variant 3_three_always_more_states
synthesize_variant 4_good_style_of_one_hot_two_always
synthesize_variant 5_good_style_of_one_hot_three_always
synthesize_variant 6_good_style_of_one_hot_three_always_more_states
synthesize_variant 7_signals_from_state
synthesize_variant 7_signals_from_state_var_1
synthesize_variant 7_signals_from_state_var_2
synthesize_variant 7_signals_from_state_var_3
synthesize_variant 7_signals_from_state_var_4
synthesize_variant 8_bad_style_of_one_hot
synthesize_variant 9_bad_priority_logic

exit

