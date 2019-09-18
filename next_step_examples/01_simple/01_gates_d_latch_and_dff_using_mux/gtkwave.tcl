# gtkwave::loadFile "dump.vcd"

lappend all_signals tb.a
lappend all_signals tb.b
lappend all_signals tb.c
lappend all_signals tb.l
lappend all_signals tb.f
lappend all_signals tb.o
lappend all_signals tb.e
lappend all_signals tb.oxe

lappend all_signals tb.a
lappend all_signals tb.b
lappend all_signals tb.f
lappend all_signals tb.i_dff_q

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
