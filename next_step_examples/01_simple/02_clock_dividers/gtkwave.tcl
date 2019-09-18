# gtkwave::loadFile "dump.vcd"

lappend all_signals tb.clk
lappend all_signals tb.rst
lappend all_signals {tb.div[2].i_clock_divider.div_clk}
lappend all_signals {tb.div[2].i_clock_divider_2.div_clk}
lappend all_signals {tb.div[3].i_clock_divider.div_clk}
lappend all_signals {tb.div[3].i_clock_divider_2.div_clk}
lappend all_signals {tb.div[4].i_clock_divider.div_clk}
lappend all_signals {tb.div[4].i_clock_divider_2.div_clk}
lappend all_signals {tb.div[5].i_clock_divider.div_clk}
lappend all_signals {tb.div[5].i_clock_divider_2.div_clk}
lappend all_signals {tb.div[6].i_clock_divider.div_clk}
lappend all_signals {tb.div[6].i_clock_divider_2.div_clk}
lappend all_signals {tb.div[7].i_clock_divider.div_clk}
lappend all_signals {tb.div[7].i_clock_divider_2.div_clk}

lappend all_signals {tb.div[2].i_clock_divider.div_clk}
lappend all_signals {tb.div[3].i_clock_divider.div_clk}
lappend all_signals {tb.div[4].i_clock_divider.div_clk}
lappend all_signals {tb.div[5].i_clock_divider.div_clk}
lappend all_signals {tb.div[6].i_clock_divider.div_clk}
lappend all_signals {tb.div[7].i_clock_divider.div_clk}

lappend all_signals {tb.div[2].i_clock_divider_2.div_clk}
lappend all_signals {tb.div[3].i_clock_divider_2.div_clk}
lappend all_signals {tb.div[4].i_clock_divider_2.div_clk}
lappend all_signals {tb.div[5].i_clock_divider_2.div_clk}
lappend all_signals {tb.div[6].i_clock_divider_2.div_clk}
lappend all_signals {tb.div[7].i_clock_divider_2.div_clk}

set num_added [ gtkwave::addSignalsFromList $all_signals ]

gtkwave::/Time/Zoom/Zoom_Full
