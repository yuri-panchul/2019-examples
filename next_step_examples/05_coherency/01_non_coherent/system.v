module system
(
    input            clk,
    input            rst,

    input            i_rd_0,
    input            i_wr_0,
    output           rd_0,
    output           wr_0,
    output           rdy_0,
    output     [7:0] wdata_0,
    output     [7:0] rdata_0,

    input            i_rd_1,
    input            i_wr_1,
    output           rd_1,
    output           wr_1,
    output           rdy_1,
    output     [7:0] wdata_1,
    output     [7:0] rdata_1,

    input            i_rd_2,
    input            i_wr_2,
    output           rd_2,
    output           wr_2,
    output           rdy_2,
    output     [7:0] wdata_2,
    output     [7:0] rdata_2,

    input            i_rd_3,
    input            i_wr_3,
    output           rd_3,
    output           wr_3,
    output           rdy_3,
    output     [7:0] wdata_3,
    output     [7:0] rdata_3,

    output reg [3:0] p_rdy
);

    core # (0) core_0
    (
        .clk   ( clk     ),
        .rst   ( rst     ),
        .i_rd  ( i_rd_0  ),
        .i_wr  ( i_wr_0  ),
        .rd    ( rd_0    ),
        .wr    ( wr_0    ),
        .rdy   ( rdy_0   ),
        .wdata ( wdata_0 ),
        .rdata ( rdata_0 )
    );

    core # (1) core_1
    (
        .clk   ( clk     ),
        .rst   ( rst     ),
        .i_rd  ( i_rd_1  ),
        .i_wr  ( i_wr_1  ),
        .rd    ( rd_1    ),
        .wr    ( wr_1    ),
        .rdy   ( rdy_1   ),
        .wdata ( wdata_1 ),
        .rdata ( rdata_1 )
    );

    core # (2) core_2
    (
        .clk   ( clk     ),
        .rst   ( rst     ),
        .i_rd  ( i_rd_2  ),
        .i_wr  ( i_wr_2  ),
        .rd    ( rd_2    ),
        .wr    ( wr_2    ),
        .rdy   ( rdy_2   ),
        .wdata ( wdata_2 ),
        .rdata ( rdata_2 )
    );

    core # (3) core_3
    (
        .clk   ( clk     ),
        .rst   ( rst     ),
        .i_rd  ( i_rd_3  ),
        .i_wr  ( i_wr_3  ),
        .rd    ( rd_3    ),
        .wr    ( wr_3    ),
        .rdy   ( rdy_3   ),
        .wdata ( wdata_3 ),
        .rdata ( rdata_3 )
    );

    wire [3:0] req;
    wire [3:0] gnt;

    arbiter arb (clk, rst, req, gnt);

    reg        rd_m;
    reg        wr_m;
    wire       rdy_m;
    reg  [7:0] wdata_m;
    wire [7:0] rdata_m;

    mem i_mem
    (
        .clk   ( clk     ),
        .rst   ( rst     ),
        .rd    ( rd_m    ),
        .wr    ( wr_m    ),
        .rdy   ( rdy_m   ),
        .wdata ( wdata_m ),
        .rdata ( rdata_m )
    );

    assign req =
    {
        rd_0 | wr_0,
        rd_1 | wr_1,
        rd_2 | wr_2,
        rd_3 | wr_3
    };

    assign rdy_0 = rdy_m & ~ (|   gnt [3:1]              );
    assign rdy_1 = rdy_m & ~ (| { gnt [3:2] , gnt [  0] });
    assign rdy_2 = rdy_m & ~ (| { gnt [3  ] , gnt [1:0] });
    assign rdy_3 = rdy_m & ~ (|               gnt [2:0]  );

    always @*
        case (1'b1)  // synopsys parallel_case

        gnt [0]:
        begin
            rd_m    = rd_0;
            wr_m    = wr_0;
            wdata_m = wdata_0;
        end

        gnt [1]:
        begin
            rd_m    = rd_1;
            wr_m    = wr_1;
            wdata_m = wdata_1;
        end

        gnt [2]:
        begin
            rd_m    = rd_2;
            wr_m    = wr_2;
            wdata_m = wdata_2;
        end

        gnt [3]:
        begin
            rd_m    = rd_3;
            wr_m    = wr_3;
            wdata_m = wdata_3;
        end

        default:
        begin
            rd_m    = 0;
            wr_m    = 0;
            wdata_m = 8'b0;
        end

        endcase

    always @ (posedge clk or posedge rst)
        if (rst)
            p_rdy <= 4'b0;
        else
            p_rdy <= { rdy_3, rdy_2, rdy_1, rdy_0 };

    assign rdata_0 = p_rdy [0] ? rdata_m : 8'b0;
    assign rdata_1 = p_rdy [1] ? rdata_m : 8'b0;
    assign rdata_2 = p_rdy [2] ? rdata_m : 8'b0;
    assign rdata_3 = p_rdy [3] ? rdata_m : 8'b0;

endmodule
