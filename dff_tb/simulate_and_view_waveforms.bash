#!/bin/bash

set +e

if ! { rm -rf sim && mkdir sim && cd sim ; }; then
	echo $0: Cannot prepare simulation directory
	exit 1
fi

if ! iverilog -g2005 -I .. ../*.v &> compile.log ; then
	echo $0: Verilog compiler returned error code
	grep -i -A 5 error compile.log
	exit 1
fi

if ! vvp a.out &> simulate.log; then
	echo $0: Verilog simulator returned error code
	grep -i -A 5 error simulate.log
	tail -n 5 simulate.log
	exit 1
fi

echo $0: Simulation successfull, starting waveform viewer
tail -n 5 simulate.log

if    [ "$OSTYPE" = "linux-gnu" ]  \
   || [ "$OSTYPE" = "cygwin"    ]  \
   || [ "$OSTYPE" = "msys"      ]; then

    if ! gtkwave --dump dump.vcd --script ../script_for_gtkwave.tcl  \
             &> waveform.log ; then
	echo $0: Waveform viewer returned error code
	grep -i -A 5 error waveform.log
	exit 1
    fi

elif [ ${OSTYPE/[0-9]*/} = "darwin" ]; then
# elif [[ "$OSTYPE" = "darwin"* ]]; then  # Alternative way

	# For some reason the following way of opening the application
	# does not read the script file:
    #
    # open -a gtkwave dump.vcd --args --script $PWD/../script_for_gtkwave.tcl
    #
    # This way works:

    if ! /Applications/gtkwave.app/Contents/MacOS/gtkwave-bin  \
             --dump dump.vcd --script ../script_for_gtkwave.tcl  \
             &> waveform.log ; then
	echo $0: Waveform viewer returned error code
	grep -i -A 5 error waveform.log
	exit 1
    fi

else
    echo "Don't know how to run GTKWave on your OS"
    exit 1
fi

cd .. && rm -rf sim
