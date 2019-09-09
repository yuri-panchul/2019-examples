module monitor
(
    input       clk,
    input       rst,

    input       i_rd_0,
    input       i_wr_0,
    input       rd_0,
    input       wr_0,
    input       rdy_0,
    input [7:0] wdata_0,
    input [7:0] rdata_0,

    input       i_rd_1,
    input       i_wr_1,
    input       rd_1,
    input       wr_1,
    input       rdy_1,
    input [7:0] wdata_1,
    input [7:0] rdata_1,

    input       i_rd_2,
    input       i_wr_2,
    input       rd_2,
    input       wr_2,
    input       rdy_2,
    input [7:0] wdata_2,
    input [7:0] rdata_2,

    input       i_rd_3,
    input       i_wr_3,
    input       rd_3,
    input       wr_3,
    input       rdy_3,
    input [7:0] wdata_3,
    input [7:0] rdata_3,

    input [3:0] p_rdy
);

    task monitor_a_core
    (
        input       i_rd,
        input       i_wr,
        input       rd,
        input       wr,
        input       rdy,
        input [7:0] wdata,
        input [7:0] rdata,
        input       p_rdy
    );

        ;
    
    endtask

endmodule
