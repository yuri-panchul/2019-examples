`include "config.vh"

module testbench;

    reg       clk;
    reg       reset;
    reg [3:0] key_sw;

    top
    # (
        .debounce_depth                    ( 1 ),
        .shift_strobe_width                ( 1 ),
        .seven_segment_strobe_width        ( 1 ),
        .strobe_to_update_xy_counter_width ( 1 )
    )
    i_top
    (
        .clk     ( clk    ),
        .reset   ( reset  ),
        .key_sw  ( key_sw )
    );

    initial
    begin
        clk = 1'b0;

        forever
            # 10 clk = ! clk;
    end

    initial
    begin
        reset <= 1'bx;
        repeat (2) @ (posedge clk);
        reset <= 1'b1;
        repeat (2) @ (posedge clk);
        reset <= 0;
    end

    initial
    begin
        #0
        $dumpvars;

        key_sw <= 4'b0;

        @ (negedge reset);

        repeat (1000)
        begin
            @ (posedge clk);

            key_sw <= $random;
        end

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
