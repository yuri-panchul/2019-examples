module tb;

    localparam WIDTH = 8;

    reg                clk;
    reg                rst;
    reg  [WIDTH - 1:0] req;
    wire [WIDTH - 1:0] gnt;

    arbiter arb (clk, rst, req, gnt);

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

    task pause;
    begin
        req <= 0; repeat (WIDTH) @ (posedge clk);
    end
    endtask

    initial
    begin
        $dumpvars;

        req <= 0;

        @ (negedge rst);
        @ (posedge clk);

        // Sequences

        for (i = 0; i < WIDTH * 3; i = i + 1)
        begin
            req <= (1 << (i % WIDTH));
            repeat ($urandom_range (1, 3)) @ (posedge clk);
        end

        pause;

        for (i = 0; i < WIDTH * 3; i = i + 1)
        begin
            req <= (1 << (WIDTH - 1 - (i % WIDTH)));
            repeat ($urandom_range (1, 3)) @ (posedge clk);
        end

        pause;

        for (i = 0; i < WIDTH * 3; i = i + 1)
        begin
            req <=   (1 << $urandom_range (0, WIDTH - 1))
                   | (1 << $urandom_range (0, WIDTH - 1));

            repeat ($urandom_range (1, 3)) @ (posedge clk);
        end

        pause;

        for (i = 0; i < WIDTH * 3; i = i + 1)
        begin
            req <= ~ 0;
            repeat ($urandom_range (1, 3)) @ (posedge clk);
        end

        pause;

        for (i = 0; i < WIDTH * 3; i = i + 1)
        begin
            req <= $urandom;
            repeat ($urandom_range (1, 3)) @ (posedge clk);
        end

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
