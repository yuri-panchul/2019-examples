module tb;

    parameter w = 8;

    reg clk;
    reg rst;
    reg new_bit;

    wire [1:0] rem_3_bits_added_from_left;
    wire [1:0] rem_3_bits_added_from_right;
 
    fsm_3_bits_coming_from_left i_fsm_3_left
    (
        clk,
        rst,
        new_bit,
        rem_3_bits_added_from_left
    );

    fsm_3_bits_coming_from_right i_fsm_3_right
    (
        clk,
        rst,
        new_bit,
        rem_3_bits_added_from_right
    );

    initial
    begin
        clk = 0;

        forever
            # 5 clk = ! clk;
    end

    reg [w - 1:0] bits_added_from_left;
    reg [w - 1:0] bits_added_from_right;

    always @ (posedge rst) bits_added_from_left <= 0;
    always @ (posedge rst) bits_added_from_right <= 0;

    reg [1:0] expected_rem_3_bits_added_from_left;
    reg [1:0] expected_rem_3_bits_added_from_right;

    integer i;

    initial
    begin
        $dumpvars;

        repeat (4)
        begin
            new_bit <= 0;
            repeat (10) @ (posedge clk);
            rst <= 1;
            repeat (10) @ (posedge clk);
            rst <= 0;
            repeat (10) @ (posedge clk);

            for (i = 0; i < w; i = i + 1)
            begin
                new_bit <= $urandom;

                @ (posedge clk);
                # 1

                bits_added_from_left
                    = bits_added_from_left | (new_bit << i);

                bits_added_from_right
                    = (bits_added_from_right << 1) | new_bit;

                expected_rem_3_bits_added_from_left
                    = bits_added_from_left % 3;

                expected_rem_3_bits_added_from_right
                    = bits_added_from_right % 3;

                if (0 &&     rem_3_bits_added_from_left
                     !== expected_rem_3_bits_added_from_left )
                begin
                    $display ("%d added from left  word=%b %d rem_3=%0d expected=%0d",
                        $time,
                        bits_added_from_left,
                        bits_added_from_left,
                        rem_3_bits_added_from_left,
                        expected_rem_3_bits_added_from_left );
                end

                if (     rem_3_bits_added_from_right
                     !== expected_rem_3_bits_added_from_right )
                begin
                    $display ("%d added from right new_bit %b word=%b %d rem_3=%0d expected=%0d",
                        $time,
                        new_bit,
                        bits_added_from_right,
                        bits_added_from_right,
                        rem_3_bits_added_from_right,
                        expected_rem_3_bits_added_from_right );
                end
            end
        end

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
