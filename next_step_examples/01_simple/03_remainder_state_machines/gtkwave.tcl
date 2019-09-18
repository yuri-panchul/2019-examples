# gtkwave::loadFile "dump.vcd"

lappend all_signals tb.clk
lappend all_signals tb.rst
lappend all_signals tb.new_bit
lappend all_signals tb.rem_3_bits_added_from_left
lappend all_signals tb.rem_3_bits_added_from_right
lappend all_signals tb.bits_added_from_left
lappend all_signals tb.bits_added_from_right

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
