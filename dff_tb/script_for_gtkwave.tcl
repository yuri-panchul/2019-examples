# gtkwave::loadFile "dump.vcd"

set all_signals [list]
lappend all_signals tb.CLK
lappend all_signals tb.D
lappend all_signals tb.Q
lappend all_signals tb.Q1
lappend all_signals tb.Q2
lappend all_signals tb.Q3
set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
