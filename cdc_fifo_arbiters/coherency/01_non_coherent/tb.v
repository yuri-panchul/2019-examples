module tb;

    reg clk;
    reg rst;

    reg        i_rd_0;
    reg        i_wr_0;
    wire       rd_0;
    wire       wr_0;
    wire       rdy_0;
    wire [7:0] wdata_0;
    wire [7:0] rdata_0;

    reg        i_rd_1;
    reg        i_wr_1;
    wire       rd_1;
    wire       wr_1;
    wire       rdy_1;
    wire [7:0] wdata_1;
    wire [7:0] rdata_1;

    reg        i_rd_2;
    reg        i_wr_2;
    wire       rd_2;
    wire       wr_2;
    wire       rdy_2;
    wire [7:0] wdata_2;
    wire [7:0] rdata_2;

    reg        i_rd_3;
    reg        i_wr_3;
    wire       rd_3;
    wire       wr_3;
    wire       rdy_3;
    wire [7:0] wdata_3;
    wire [7:0] rdata_3;

    wire [3:0] p_rdy;

    system sys (.*);

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

        { i_rd_0, i_wr_0,
          i_rd_1, i_wr_1,
          i_rd_2, i_wr_2,
          i_rd_3, i_wr_3 } <= 8'b0;

        @ (negedge rst);
        @ (posedge clk);

        repeat (20)
        begin
            @ (posedge clk);

            { i_rd_0, i_wr_0,
              i_rd_1, i_wr_1,
              i_rd_2, i_wr_2,
              i_rd_3, i_wr_3 } <= 8'b10101001;
        end
/*
        repeat (20)
        begin
            @ (posedge clk);

            { i_rd_0, i_wr_0,
              i_rd_1, i_wr_1,
              i_rd_2, i_wr_2,
              i_rd_3, i_wr_3 } <= $urandom;
        end
*/
        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
