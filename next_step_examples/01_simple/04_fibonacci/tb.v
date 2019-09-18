module tb;

    reg        clk;
    reg        rst;
    wire [7:0] num;

    fibonacci fib (clk, rst, num);

    initial
    begin
        clk = 0;

        forever
            # 5 clk = ! clk;
    end

    initial
    begin
        $dumpvars;

        $monitor ("clk=%b rst=%b num=%d", clk, rst, num);

        repeat (2) @ (posedge clk);
        rst <= 1;
        repeat (2) @ (posedge clk);
        rst <= 0;

        repeat (100) @ (posedge clk);

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
