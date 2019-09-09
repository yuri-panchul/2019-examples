module core
# (
    parameter [3:0] id = 0
)
(
    input            clk,
    input            rst,
    input            i_rd,
    input            i_wr,
    output reg       rd,
    output reg       wr,
    input            rdy,
    output     [7:0] wdata,
    input      [7:0] rdata
);

    reg [7:0] data;
    assign wdata = data;

    always @ (posedge clk or posedge rst)
        if (rst)
        begin
            rd <= 0;
            wr <= 0;
        end
        else if (rdy)
        begin
            rd <= i_rd;
            wr <= i_wr;
        end

    reg [7:0] n_data;

    always @*
        if (rd)
            n_data = rdata;
        else if (i_wr)
            n_data = { id, data [3:0] + 4'b1 };
        else
            n_data = data;

    always @ (posedge clk or posedge rst)
        if (rst)
            data <= { id, 4'd1 };
        else if (rdy)
            data <= n_data;

endmodule
