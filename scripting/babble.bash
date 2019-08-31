#!/bin/bash

a=( "Palo Alto"     \
    "Fremont"       \
    "Mountain View" \
    "Milpitas"      \
    "Sunnyvale"     \
    "Santa Clara"   \
    "Los Altos"     \
    "Cupertino"     \
    "San Jose"      \
    "Saratoga"      \
    "Campbell"      \
    "Los Gatos"     )

print_array ()
{
    printf "$*\n"
    printf '    %s\n' "${a[@]}"
}

print_array Before sort

run=true

while $run
do
    run=false

    for i in $(seq 0 $((${#a[@]} - 2)) )
    do
        i_1=$(($i + 1))
        
        if [ "${a[$i_1]}" \< "${a[$i]}" ]
        then
            t=${a[$i]}
            a[$i]=${a[$i_1]}
            a[$i_1]=$t
            
            run=true
        fi
    done

done

print_array After sort
