# gtkwave::loadFile "dump.vcd"

lappend all_signals tb.clk
lappend all_signals tb.rst

lappend all_signals tb.sys.core_0.data
lappend all_signals tb.sys.core_1.data
lappend all_signals tb.sys.core_2.data
lappend all_signals tb.sys.core_3.data
lappend all_signals tb.sys.i_mem.data

lappend all_signals tb.rd_0
lappend all_signals tb.rdata_0
lappend all_signals tb.wr_0
lappend all_signals tb.wdata_0
lappend all_signals tb.rdy_0

lappend all_signals tb.rd_1
lappend all_signals tb.rdata_1
lappend all_signals tb.wr_1
lappend all_signals tb.wdata_1
lappend all_signals tb.rdy_1

lappend all_signals tb.rd_2
lappend all_signals tb.rdata_2
lappend all_signals tb.wr_2
lappend all_signals tb.wdata_2
lappend all_signals tb.rdy_2

lappend all_signals tb.rd_3
lappend all_signals tb.rdata_3
lappend all_signals tb.wr_3
lappend all_signals tb.wdata_3
lappend all_signals tb.rdy_3

lappend all_signals tb.p_rdy

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
