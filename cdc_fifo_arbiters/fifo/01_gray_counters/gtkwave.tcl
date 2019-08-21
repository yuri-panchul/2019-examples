# gtkwave::loadFile "dump.vcd"

lappend all_signals tb.clk
lappend all_signals tb.rst
lappend all_signals tb.inc
lappend all_signals tb.not_full_or_empty
lappend all_signals tb.bin_1
lappend all_signals tb.bin_2
lappend all_signals tb.ptr_1
lappend all_signals tb.ptr_2

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
