module tb;

    reg clk;
    reg rst;
 
    genvar i;

    generate

        for (i = 2; i <= 7; i = i + 1)
        begin : div
            clock_divider   # (i) i_clock_divider   (clk, rst, );
            clock_divider_2 # (i) i_clock_divider_2 (clk, rst, );
        end

    endgenerate

    initial
    begin
        clk = 0;

        forever
            # 5 clk = ! clk;
    end

    initial
    begin
        $dumpvars;

        repeat (2) @ (posedge clk);
        rst <= 1;
        repeat (2) @ (posedge clk);
        rst <= 0;

        repeat (20) @ (posedge clk);

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
