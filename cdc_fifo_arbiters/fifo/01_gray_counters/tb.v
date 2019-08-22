module tb;

    localparam N = 4;

    reg clk;
    reg rst;
    reg inc;
    reg not_full_or_empty;

    wire [N-2:0] adr_1;
    wire [N-1:0] ptr_1;

    wire [N-2:0] bin_2;
    wire [N-1:0] ptr_2;

    gray_counter_1 cnt_1
        (clk, rst, inc, not_full_or_empty, adr_1, ptr_1);

    gray_counter_2 cnt_2
        (clk, rst, inc, not_full_or_empty, bin_2, ptr_2);

    initial
    begin
        clk = 0;

        forever
            # 10 clk = ! clk;
    end

    initial
    begin
        rst <= 1;
        repeat (2) @ (posedge clk);
        rst <= 0;
    end

    integer i, n;
    reg failure;

    initial
    begin
        $dumpvars;

        inc               <= 0;
        not_full_or_empty <= 1;

        failure <= 0;

        @ (negedge rst);
        @ (posedge clk);

        repeat (10) @ (posedge clk);

        inc <= 1;

        repeat (2 ** (N + 2)) @ (posedge clk);
        repeat (10) @ (posedge clk);

        repeat (2 ** (N + 2))
        begin
            @ (posedge clk);
            inc <= $urandom;

            if (ptr_1 != ptr_2)
                $display ("*** ptr_1 %b ptr_2 %b", ptr_1, ptr_2);
        end

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
