module tb;

    reg         s_clk;
    reg         r_clk;

    reg         rst;
    wire        en;
    wire  [3:0] data;
    wire  [3:0] expected;
    wire        failure;

    tb_sender sender
    (
        .clk      ( s_clk    ),
        .rst      ( rst      ),
        .data     ( data     ),
        .en       ( en       )
    );

    tb_receiver receiver
    (
        .clk      ( r_clk    ),
        .rst      ( rst      ),
        .en       ( en       ),
        .data     ( data     ),
        .expected ( expected ),
        .failure  ( failure  )
    );

    initial
    begin
        s_clk = 0;

        forever
            # 10 s_clk = ! s_clk;
    end

    initial
    begin
        r_clk = 0;

        forever
            # 9 r_clk = ! r_clk;
    end

    initial
    begin
        rst <= 1;
        repeat (2) @ (posedge s_clk);
        rst <= 0;
    end

    initial
    begin
        $dumpvars;

        @ (negedge rst);

        repeat (100)
            @ (posedge s_clk);

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
