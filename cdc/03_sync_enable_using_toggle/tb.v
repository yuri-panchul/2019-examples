module tb;

    reg         f_clk;
    wire        f_en;

    reg         t_clk;
    wire        t_en;

    reg         rst;
    wire  [3:0] data;
    wire  [3:0] expected;
    wire        failure;

    tb_sender sender (f_clk, rst, data, f_en);
    tb_receiver receiver (t_clk, rst, s_en, data, expected, failure);

    wire f_toggle, t_toggle;

    pulse_to_toggle i_pulse_to_toggle   (f_clk, rst, f_en,  f_toggle);
    sync2           i_sync2             (t_clk, rst, f_toggle, t_toggle);
    toggle_to_pulse i_toggle_to_pulse   (t_clk, rst, t_toggle, s_en);

    initial
    begin
        f_clk = 0;

        forever
            # 10 f_clk = ! f_clk;
    end

    initial
    begin
        t_clk = 0;

        forever
            # 9 t_clk = ! t_clk;
    end

    initial
    begin
        rst <= 1;
        repeat (2) @ (posedge f_clk);
        rst <= 0;
    end

    initial
    begin
        $dumpvars;

        @ (negedge rst);

        repeat (30)
            @ (posedge f_clk);

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
