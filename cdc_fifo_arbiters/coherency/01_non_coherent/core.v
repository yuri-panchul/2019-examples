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
    output reg [7:0] wdata,
    input      [7:0] rdata
);

    reg       n_rd;
    reg       n_wr;
    reg [7:0] n_wdata;

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

    wire [7:0] n_wdata
        = i_wr ? { id, wdata [3:0] + 4'b1 } : wdata;
        
    always @ (posedge clk)
        if (rdy)
            wdata <= n_wdata;
        
endmodule
