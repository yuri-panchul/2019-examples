#!dc_shell -f

#set DESIGN_TOP     game_top
#set DESIGN_TOP     game_sprite_display_wrapper
set DESIGN_TOP     game_master_fsm_wrapper

set SRC            ../..

set ASIC_LIBRARY   /projects/mips/cad/links/libraries/tsmc/16nm/synopsys/FFplusLL/LVT/HD_9tr_CPODE/C16/ts16ncpllogl16hdl090f_base_3.01A/DesignWare_logic_libs/tsmc16nllp/16hd/hdl/lvt/3.01a/liberty/ccs
set SLOW_SLOW      ts16ncpllogl16hdl090f_ssgnp0p72v0c.db
set FAST_FAST      ts16ncpllogl16hdl090f_ffgnp0p88v0c.db

# set ASIC_LIBRARY   /mips/proj/sclib3/tsmc/tcbn28hpmbwp12t35cdm4nm/TSMCHOME_120a/digital/Front_End/timing_power_noise/CCS/tcbn28hpmbwp12t35cdm4nm_120a
# set SLOW_SLOW      tcbn28hpmbwp12t35cdm4nmss0p81v0c_ccs.db
# set FAST_FAST      tcbn28hpmbwp12t35cdm4nmff0p99vm40c_ccs.db

set VERILOG_FILES  ""

set VERILOG_FILES  "$VERILOG_FILES game_master_fsm_alt_1.v"
set VERILOG_FILES  "$VERILOG_FILES game_master_fsm_alt_2.v"
set VERILOG_FILES  "$VERILOG_FILES game_master_fsm_alt_3.v"
set VERILOG_FILES  "$VERILOG_FILES game_master_fsm_alt_4.v"
set VERILOG_FILES  "$VERILOG_FILES game_master_fsm.v"
set VERILOG_FILES  "$VERILOG_FILES game_master_fsm_wrapper.v"
set VERILOG_FILES  "$VERILOG_FILES game_mixer.v"
set VERILOG_FILES  "$VERILOG_FILES game_overlap.v"
set VERILOG_FILES  "$VERILOG_FILES game_random.v"
set VERILOG_FILES  "$VERILOG_FILES game_sprite_control.v"
set VERILOG_FILES  "$VERILOG_FILES game_sprite_display.v"
set VERILOG_FILES  "$VERILOG_FILES game_sprite_display_alt_1.v"
set VERILOG_FILES  "$VERILOG_FILES game_sprite_display_wrapper.v"
set VERILOG_FILES  "$VERILOG_FILES game_sprite_top.v"
set VERILOG_FILES  "$VERILOG_FILES game_strobe.v"
set VERILOG_FILES  "$VERILOG_FILES game_timer.v"
set VERILOG_FILES  "$VERILOG_FILES game_top.v"

set VERILOG_FILES  "$VERILOG_FILES counter.v"
set VERILOG_FILES  "$VERILOG_FILES lfsr.v"
set VERILOG_FILES  "$VERILOG_FILES light_sensor.v"
set VERILOG_FILES  "$VERILOG_FILES mealy_fsm.v"
set VERILOG_FILES  "$VERILOG_FILES moore_fsm.v"
set VERILOG_FILES  "$VERILOG_FILES register_no_rst.v"
set VERILOG_FILES  "$VERILOG_FILES register.v"
set VERILOG_FILES  "$VERILOG_FILES rotary_encoder.v"
set VERILOG_FILES  "$VERILOG_FILES selector.v"
set VERILOG_FILES  "$VERILOG_FILES seven_segment_digit.v"
set VERILOG_FILES  "$VERILOG_FILES seven_segment.v"
set VERILOG_FILES  "$VERILOG_FILES shift_register.v"
set VERILOG_FILES  "$VERILOG_FILES strobe_gen.v"
set VERILOG_FILES  "$VERILOG_FILES sync_and_debounce_one.v"
set VERILOG_FILES  "$VERILOG_FILES sync_and_debounce.v"
set VERILOG_FILES  "$VERILOG_FILES ultrasonic_distance_sensor.v"
set VERILOG_FILES  "$VERILOG_FILES vga.v"

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

analyze -format sverilog $VERILOG_FILES

elaborate $DESIGN_TOP

link

#exit

create_clock -period 0.5 clk  

compile_ultra -gate_clock

write -format ddc     -hierarchy -output ${DESIGN_TOP}.ddc
write -format verilog -hierarchy -output ${DESIGN_TOP}.vg
write_parasitics                 -output ${DESIGN_TOP}.spef

report_timing -max_path 5
report_area
report_power
report_reference
report_resources
report_qor

report_qor > dc.summary
report_timing -max_path 1 > dc.longest_path

exit
