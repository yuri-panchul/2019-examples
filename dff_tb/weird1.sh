#!/bin/bash

set -x

I am trying to understand the logic of Bash algorithm.

When I tried this, it printed "a":

    a=a;[ $a == "a" ] && echo $a

So far so good. Then I tried the following and it printed "a" again:

    a=a;[[ $a == "a" ]] && echo $a

Now I introduced an error by using arithmetic comparison:

    a=abc;[ $a -eq "abc" ] && echo $a

I got an error message that makes sense:

    -bash: [: abc: integer expression expected

Then I tried to do this with double bracket and got no error, but "abc":

    a=abc;[[ $a -eq "abc" ]] && echo $a

I can sort of explain it (bash is trying to be accomodating), but then I got something that puzzles me. If I do that, I get an error message about recursion:

    a=a;[[ $a -eq "a" ]] && echo $a

    -bash: [[: a: expression recursion level exceeded (error token is "a")

If I use single brackets, there is no recursion but a reasonable error "integer expression expected":

    a=a;[ $a -eq "a" ] && echo $a
    -bash: [: abc: integer expression expected

This is weird. What Bash is trying to do in that "recursion" case with double brackets? I am talking about:

    a=a;[[ $a -eq "a" ]] && echo $a
    -bash: [[: a: expression recursion level exceeded (error token is "a")




a=a

=  [[ $a   -ne 0   ]] && echo $LINENO
  [[ $a   !=  0   ]] && echo $LINENO
=  [[ "$a" -ne "0" ]] && echo $LINENO
  [[ "$a" !=  "0" ]] && echo $LINENO
-  [  $a   -ne 0    ] && echo $LINENO
  [  $a   !=  0    ] && echo $LINENO
-  [  "$a" -ne "0"  ] && echo $LINENO
  [  "$a" !=  "0"  ] && echo $LINENO
=! [[ $a   -eq 0   ]] && echo $LINENO
! [[ $a   ==  0   ]] && echo $LINENO
=! [[ "$a" -eq "0" ]] && echo $LINENO
! [[ "$a" ==  "0" ]] && echo $LINENO
-! [  $a   -eq 0    ] && echo $LINENO
! [  $a   ==  0    ] && echo $LINENO
-! [  "$a" -eq "0"  ] && echo $LINENO
! [  "$a" ==  "0"  ] && echo $LINENO
=  [[ $a   -ne "0" ]] && echo $LINENO
  [[ $a   !=  "0" ]] && echo $LINENO
=  [[ "$a" -ne 0   ]] && echo $LINENO
  [[ "$a" !=  0   ]] && echo $LINENO
-  [  $a   -ne "0"  ] && echo $LINENO
  [  $a   !=  "0"  ] && echo $LINENO
-  [  "$a" -ne 0    ] && echo $LINENO
  [  "$a" !=  0    ] && echo $LINENO
=! [[ $a   -eq "0" ]] && echo $LINENO
! [[ $a   ==  "0" ]] && echo $LINENO
=! [[ "$a" -eq 0   ]] && echo $LINENO
! [[ "$a" ==  0   ]] && echo $LINENO
-! [  $a   -eq "0"  ] && echo $LINENO
! [  $a   ==  "0"  ] && echo $LINENO
! [  "$a" -eq 0    ] && echo $LINENO
! [  "$a" ==  0    ] && echo $LINENO
=  [[ "$a" -ne '0' ]] && echo $LINENO
  [[ "$a" !=  '0' ]] && echo $LINENO
-  [  "$a" -ne '0'  ] && echo $LINENO
  [  "$a" !=  '0'  ] && echo $LINENO
=! [[ "$a" -eq '0' ]] && echo $LINENO
! [[ "$a" ==  '0' ]] && echo $LINENO
-! [  "$a" -eq '0'  ] && echo $LINENO
! [  "$a" ==  '0'  ] && echo $LINENO
=  [[ $a   -ne '0' ]] && echo $LINENO
  [[ $a   !=  '0' ]] && echo $LINENO
-  [  $a   -ne '0'  ] && echo $LINENO
  [  $a   !=  '0'  ] && echo $LINENO
=! [[ $a   -eq '0' ]] && echo $LINENO
! [[ $a   ==  '0' ]] && echo $LINENO
-! [  $a   -eq '0'  ] && echo $LINENO
! [  $a   ==  '0'  ] && echo $LINENO

exit

a=00

  [[ $a   -ne 0   ]] && echo $LINENO
  [[ $a   !=  0   ]] && echo $LINENO
  [[ "$a" -ne "0" ]] && echo $LINENO
  [[ "$a" !=  "0" ]] && echo $LINENO
  [  $a   -ne 0    ] && echo $LINENO
  [  $a   !=  0    ] && echo $LINENO
  [  "$a" -ne "0"  ] && echo $LINENO
  [  "$a" !=  "0"  ] && echo $LINENO
! [[ $a   -eq 0   ]] && echo $LINENO
! [[ $a   ==  0   ]] && echo $LINENO
! [[ "$a" -eq "0" ]] && echo $LINENO
! [[ "$a" ==  "0" ]] && echo $LINENO
! [  $a   -eq 0    ] && echo $LINENO
! [  $a   ==  0    ] && echo $LINENO
! [  "$a" -eq "0"  ] && echo $LINENO
! [  "$a" ==  "0"  ] && echo $LINENO
  [[ $a   -ne "0" ]] && echo $LINENO
  [[ $a   !=  "0" ]] && echo $LINENO
  [[ "$a" -ne 0   ]] && echo $LINENO
  [[ "$a" !=  0   ]] && echo $LINENO
  [  $a   -ne "0"  ] && echo $LINENO
  [  $a   !=  "0"  ] && echo $LINENO
  [  "$a" -ne 0    ] && echo $LINENO
  [  "$a" !=  0    ] && echo $LINENO
! [[ $a   -eq "0" ]] && echo $LINENO
! [[ $a   ==  "0" ]] && echo $LINENO
! [[ "$a" -eq 0   ]] && echo $LINENO
! [[ "$a" ==  0   ]] && echo $LINENO
! [  $a   -eq "0"  ] && echo $LINENO
! [  $a   ==  "0"  ] && echo $LINENO
! [  "$a" -eq 0    ] && echo $LINENO
! [  "$a" ==  0    ] && echo $LINENO
  [[ "$a" -ne '0' ]] && echo $LINENO
  [[ "$a" !=  '0' ]] && echo $LINENO
  [  "$a" -ne '0'  ] && echo $LINENO
  [  "$a" !=  '0'  ] && echo $LINENO
! [[ "$a" -eq '0' ]] && echo $LINENO
! [[ "$a" ==  '0' ]] && echo $LINENO
! [  "$a" -eq '0'  ] && echo $LINENO
! [  "$a" ==  '0'  ] && echo $LINENO
  [[ $a   -ne '0' ]] && echo $LINENO
  [[ $a   !=  '0' ]] && echo $LINENO
  [  $a   -ne '0'  ] && echo $LINENO
  [  $a   !=  '0'  ] && echo $LINENO
! [[ $a   -eq '0' ]] && echo $LINENO
! [[ $a   ==  '0' ]] && echo $LINENO
! [  $a   -eq '0'  ] && echo $LINENO
! [  $a   ==  '0'  ] && echo $LINENO


exit

a=abc

  [  $a   -ne 0    ] && echo $LINENO
  [  "$a" -ne "0"  ] && echo $LINENO
! [  $a   -eq 0    ] && echo $LINENO
! [  "$a" -eq "0"  ] && echo $LINENO
  [  $a   -ne "0"  ] && echo $LINENO
  [  "$a" -ne 0    ] && echo $LINENO
! [  $a   -eq "0"  ] && echo $LINENO
! [  "$a" -eq 0    ] && echo $LINENO
  [  "$a" -ne '0'  ] && echo $LINENO
! [  "$a" -eq '0'  ] && echo $LINENO
  [  $a   -ne '0'  ] && echo $LINENO
! [  $a   -eq '0'  ] && echo $LINENO

exit


a=0

  [[ $a   -ne 0   ]] && echo $LINENO
  [[ $a   !=  0   ]] && echo $LINENO
  [[ "$a" -ne "0" ]] && echo $LINENO
  [[ "$a" !=  "0" ]] && echo $LINENO
  [  $a   -ne 0    ] && echo $LINENO
  [  $a   !=  0    ] && echo $LINENO
  [  "$a" -ne "0"  ] && echo $LINENO
  [  "$a" !=  "0"  ] && echo $LINENO
! [[ $a   -eq 0   ]] && echo $LINENO
! [[ $a   ==  0   ]] && echo $LINENO
! [[ "$a" -eq "0" ]] && echo $LINENO
! [[ "$a" ==  "0" ]] && echo $LINENO
! [  $a   -eq 0    ] && echo $LINENO
! [  $a   ==  0    ] && echo $LINENO
! [  "$a" -eq "0"  ] && echo $LINENO
! [  "$a" ==  "0"  ] && echo $LINENO
  [[ $a   -ne "0" ]] && echo $LINENO
  [[ $a   !=  "0" ]] && echo $LINENO
  [[ "$a" -ne 0   ]] && echo $LINENO
  [[ "$a" !=  0   ]] && echo $LINENO
  [  $a   -ne "0"  ] && echo $LINENO
  [  $a   !=  "0"  ] && echo $LINENO
  [  "$a" -ne 0    ] && echo $LINENO
  [  "$a" !=  0    ] && echo $LINENO
! [[ $a   -eq "0" ]] && echo $LINENO
! [[ $a   ==  "0" ]] && echo $LINENO
! [[ "$a" -eq 0   ]] && echo $LINENO
! [[ "$a" ==  0   ]] && echo $LINENO
! [  $a   -eq "0"  ] && echo $LINENO
! [  $a   ==  "0"  ] && echo $LINENO
! [  "$a" -eq 0    ] && echo $LINENO
! [  "$a" ==  0    ] && echo $LINENO
  [[ "$a" -ne '0' ]] && echo $LINENO
  [[ "$a" !=  '0' ]] && echo $LINENO
  [  "$a" -ne '0'  ] && echo $LINENO
  [  "$a" !=  '0'  ] && echo $LINENO
! [[ "$a" -eq '0' ]] && echo $LINENO
! [[ "$a" ==  '0' ]] && echo $LINENO
! [  "$a" -eq '0'  ] && echo $LINENO
! [  "$a" ==  '0'  ] && echo $LINENO
  [[ $a   -ne '0' ]] && echo $LINENO
  [[ $a   !=  '0' ]] && echo $LINENO
  [  $a   -ne '0'  ] && echo $LINENO
  [  $a   !=  '0'  ] && echo $LINENO
! [[ $a   -eq '0' ]] && echo $LINENO
! [[ $a   ==  '0' ]] && echo $LINENO
! [  $a   -eq '0'  ] && echo $LINENO
! [  $a   ==  '0'  ] && echo $LINENO

a=1

  [[ $a   -ne 0   ]] && echo $LINENO
  [[ $a   !=  0   ]] && echo $LINENO
  [[ "$a" -ne "0" ]] && echo $LINENO
  [[ "$a" !=  "0" ]] && echo $LINENO
  [  $a   -ne 0    ] && echo $LINENO
  [  $a   !=  0    ] && echo $LINENO
  [  "$a" -ne "0"  ] && echo $LINENO
  [  "$a" !=  "0"  ] && echo $LINENO
! [[ $a   -eq 0   ]] && echo $LINENO
! [[ $a   ==  0   ]] && echo $LINENO
! [[ "$a" -eq "0" ]] && echo $LINENO
! [[ "$a" ==  "0" ]] && echo $LINENO
! [  $a   -eq 0    ] && echo $LINENO
! [  $a   ==  0    ] && echo $LINENO
! [  "$a" -eq "0"  ] && echo $LINENO
! [  "$a" ==  "0"  ] && echo $LINENO
  [[ $a   -ne "0" ]] && echo $LINENO
  [[ $a   !=  "0" ]] && echo $LINENO
  [[ "$a" -ne 0   ]] && echo $LINENO
  [[ "$a" !=  0   ]] && echo $LINENO
  [  $a   -ne "0"  ] && echo $LINENO
  [  $a   !=  "0"  ] && echo $LINENO
  [  "$a" -ne 0    ] && echo $LINENO
  [  "$a" !=  0    ] && echo $LINENO
! [[ $a   -eq "0" ]] && echo $LINENO
! [[ $a   ==  "0" ]] && echo $LINENO
! [[ "$a" -eq 0   ]] && echo $LINENO
! [[ "$a" ==  0   ]] && echo $LINENO
! [  $a   -eq "0"  ] && echo $LINENO
! [  $a   ==  "0"  ] && echo $LINENO
! [  "$a" -eq 0    ] && echo $LINENO
! [  "$a" ==  0    ] && echo $LINENO
  [[ "$a" -ne '0' ]] && echo $LINENO
  [[ "$a" !=  '0' ]] && echo $LINENO
  [  "$a" -ne '0'  ] && echo $LINENO
  [  "$a" !=  '0'  ] && echo $LINENO
! [[ "$a" -eq '0' ]] && echo $LINENO
! [[ "$a" ==  '0' ]] && echo $LINENO
! [  "$a" -eq '0'  ] && echo $LINENO
! [  "$a" ==  '0'  ] && echo $LINENO
  [[ $a   -ne '0' ]] && echo $LINENO
  [[ $a   !=  '0' ]] && echo $LINENO
  [  $a   -ne '0'  ] && echo $LINENO
  [  $a   !=  '0'  ] && echo $LINENO
! [[ $a   -eq '0' ]] && echo $LINENO
! [[ $a   ==  '0' ]] && echo $LINENO
! [  $a   -eq '0'  ] && echo $LINENO
! [  $a   ==  '0'  ] && echo $LINENO

a=

  [[ $a   -ne 0   ]] && echo $LINENO
  [[ $a   !=  0   ]] && echo $LINENO
  [[ "$a" -ne "0" ]] && echo $LINENO
  [[ "$a" !=  "0" ]] && echo $LINENO
  [  $a   -ne 0    ] && echo $LINENO
  [  $a   !=  0    ] && echo $LINENO
  [  "$a" -ne "0"  ] && echo $LINENO
  [  "$a" !=  "0"  ] && echo $LINENO
! [[ $a   -eq 0   ]] && echo $LINENO
! [[ $a   ==  0   ]] && echo $LINENO
! [[ "$a" -eq "0" ]] && echo $LINENO
! [[ "$a" ==  "0" ]] && echo $LINENO
! [  $a   -eq 0    ] && echo $LINENO
! [  $a   ==  0    ] && echo $LINENO
! [  "$a" -eq "0"  ] && echo $LINENO
! [  "$a" ==  "0"  ] && echo $LINENO
  [[ $a   -ne "0" ]] && echo $LINENO
  [[ $a   !=  "0" ]] && echo $LINENO
  [[ "$a" -ne 0   ]] && echo $LINENO
  [[ "$a" !=  0   ]] && echo $LINENO
  [  $a   -ne "0"  ] && echo $LINENO
  [  $a   !=  "0"  ] && echo $LINENO
  [  "$a" -ne 0    ] && echo $LINENO
  [  "$a" !=  0    ] && echo $LINENO
! [[ $a   -eq "0" ]] && echo $LINENO
! [[ $a   ==  "0" ]] && echo $LINENO
! [[ "$a" -eq 0   ]] && echo $LINENO
! [[ "$a" ==  0   ]] && echo $LINENO
! [  $a   -eq "0"  ] && echo $LINENO
! [  $a   ==  "0"  ] && echo $LINENO
! [  "$a" -eq 0    ] && echo $LINENO
! [  "$a" ==  0    ] && echo $LINENO
  [[ "$a" -ne '0' ]] && echo $LINENO
  [[ "$a" !=  '0' ]] && echo $LINENO
  [  "$a" -ne '0'  ] && echo $LINENO
  [  "$a" !=  '0'  ] && echo $LINENO
! [[ "$a" -eq '0' ]] && echo $LINENO
! [[ "$a" ==  '0' ]] && echo $LINENO
! [  "$a" -eq '0'  ] && echo $LINENO
! [  "$a" ==  '0'  ] && echo $LINENO
  [[ $a   -ne '0' ]] && echo $LINENO
  [[ $a   !=  '0' ]] && echo $LINENO
  [  $a   -ne '0'  ] && echo $LINENO
  [  $a   !=  '0'  ] && echo $LINENO
! [[ $a   -eq '0' ]] && echo $LINENO
! [[ $a   ==  '0' ]] && echo $LINENO
! [  $a   -eq '0'  ] && echo $LINENO
! [  $a   ==  '0'  ] && echo $LINENO

a=a

  [[ $a   -ne 0   ]] && echo $LINENO
  [[ $a   !=  0   ]] && echo $LINENO
  [[ "$a" -ne "0" ]] && echo $LINENO
  [[ "$a" !=  "0" ]] && echo $LINENO
  [  $a   -ne 0    ] && echo $LINENO
  [  $a   !=  0    ] && echo $LINENO
  [  "$a" -ne "0"  ] && echo $LINENO
  [  "$a" !=  "0"  ] && echo $LINENO
! [[ $a   -eq 0   ]] && echo $LINENO
! [[ $a   ==  0   ]] && echo $LINENO
! [[ "$a" -eq "0" ]] && echo $LINENO
! [[ "$a" ==  "0" ]] && echo $LINENO
! [  $a   -eq 0    ] && echo $LINENO
! [  $a   ==  0    ] && echo $LINENO
! [  "$a" -eq "0"  ] && echo $LINENO
! [  "$a" ==  "0"  ] && echo $LINENO
  [[ $a   -ne "0" ]] && echo $LINENO
  [[ $a   !=  "0" ]] && echo $LINENO
  [[ "$a" -ne 0   ]] && echo $LINENO
  [[ "$a" !=  0   ]] && echo $LINENO
  [  $a   -ne "0"  ] && echo $LINENO
  [  $a   !=  "0"  ] && echo $LINENO
  [  "$a" -ne 0    ] && echo $LINENO
  [  "$a" !=  0    ] && echo $LINENO
! [[ $a   -eq "0" ]] && echo $LINENO
! [[ $a   ==  "0" ]] && echo $LINENO
! [[ "$a" -eq 0   ]] && echo $LINENO
! [[ "$a" ==  0   ]] && echo $LINENO
! [  $a   -eq "0"  ] && echo $LINENO
! [  $a   ==  "0"  ] && echo $LINENO
! [  "$a" -eq 0    ] && echo $LINENO
! [  "$a" ==  0    ] && echo $LINENO
  [[ "$a" -ne '0' ]] && echo $LINENO
  [[ "$a" !=  '0' ]] && echo $LINENO
  [  "$a" -ne '0'  ] && echo $LINENO
  [  "$a" !=  '0'  ] && echo $LINENO
! [[ "$a" -eq '0' ]] && echo $LINENO
! [[ "$a" ==  '0' ]] && echo $LINENO
! [  "$a" -eq '0'  ] && echo $LINENO
! [  "$a" ==  '0'  ] && echo $LINENO
  [[ $a   -ne '0' ]] && echo $LINENO
  [[ $a   !=  '0' ]] && echo $LINENO
  [  $a   -ne '0'  ] && echo $LINENO
  [  $a   !=  '0'  ] && echo $LINENO
! [[ $a   -eq '0' ]] && echo $LINENO
! [[ $a   ==  '0' ]] && echo $LINENO
! [  $a   -eq '0'  ] && echo $LINENO
! [  $a   ==  '0'  ] && echo $LINENO


exit

set +e

rm -rf sim && mkdir sim && cd sim1

if [[ $? -ne 0     ]]; then
if [[ $? !=  0     ]]; then
if [[ "$?" -ne "0" ]]; then
if [[ "$?" !=  "0" ]]; then
if [ $? -ne 0     ]; then
if [ $? !=  0     ]; then
if [ "$?" -ne "0" ]; then
if [ "$?" !=  "0" ]; then
if ! [[ $? -eq 0     ]]; then
if ! [[ $? ==  0     ]]; then
if ! [[ "$?" -eq "0" ]]; then
if ! [[ "$?" ==  "0" ]]; then
if ! [ $? -eq 0     ]; then
if ! [ $? ==  0     ]; then
if ! [ "$?" -eq "0" ]; then
if ! [ "$?" ==  "0" ]; then
	echo $0: Cannot prepare simulation directory
	exit 1
fi

echo $PWD

if ! iverilog -g2005 -I .. ../*.{v,sv} &> compile.lst; then
	echo $0: Verilog compiler returned error code
	grep -i -A 5 error compile.lst
	exit 1
fi

if ! vvp a.out &> simulate.lst; then
	echo $0: Verilog simulator returned error code
	grep -i -A 5 error simulate.lst
	tail -n 5 simulate.lst
	exit 1
fi

echo $0: Simulation successfull, starting waveform viewer
tail -n 5 simulate.lst

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    gtkwave.app --args dump.vcd &
elif [[ "$OSTYPE" == "darwin"* ]]; then
    open /Applications/gtkwave.app --args dump.vcd &
else
    echo "Don't know how to run GTKWave on your OS"
    exit 1
fi
