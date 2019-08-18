module tb;

    reg         clk;
    reg         rst;
    wire        en;
    wire  [3:0] data;
    wire        failure;

    tb_sender sender
    (
        .clk      ( clk     ),
        .rst      ( rst     ),
        .data     ( data    ),
        .en       ( en      )
    );

    tb_receiver receiver
    (
        .clk      ( clk     ),
        .rst      ( rst     ),
        .en       ( en      ),
        .data     ( data    ),
        .failure  ( failure )
    );

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

    initial
    begin
        $dumpvars;

        @ (negedge rst);

        repeat (100)
            @ (posedge clk);

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
