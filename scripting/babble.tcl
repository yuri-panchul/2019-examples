#!/usr/bin/tclsh

array set a {
	0  "Palo Alto"
    1  "Fremont"
    2  "Mountain View"
    3  "Milpitas"
    4  "Sunnyvale"
    5  "Santa Clara"
    6  "Los Altos"
    7  "Cupertino"
    8  "San Jose"
    9  "Saratoga"
    10 "Campbell"
    11 "Los Gatos"
}

proc print_array {title} {
    global a

    puts "$title"

    for {set i 0} {$i < [array size a]} {incr i} {
        puts "    $a($i)"
    }
}

print_array "Before sort"

set run true

while {$run} {
    set run false

    for {set i 0} {$i < [array size a] - 1} {incr i} {
        set i_1 [expr $i + 1]

        if {$a($i_1) < $a($i)} {
            set t       $a($i)
            set a($i)   $a($i_1)
            set a($i_1) $t

            set run true
        }
    }
}

print_array "After sort"
