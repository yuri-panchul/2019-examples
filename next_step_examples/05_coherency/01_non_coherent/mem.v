module mem
(
    input            clk,
    input            rst,
    input            rd,
    input            wr,
    output           rdy,
    input      [7:0] wdata,
    output reg [7:0] rdata
);

    assign rdy = 1;

    reg [7:0] data;

    always @ (posedge clk or negedge rst)
        if (rst)
        begin
            data  <= 8'b0;
            rdata <= 8'b0;
        end
        else
        begin
            if (wr)
                data <= wdata;

            if (rd)
            begin
                if (wr)
                    rdata <= wdata;  // bypass
                else
                    rdata <= data;
            end
            else
            begin
                rdata <= 8'b0;
            end
        end
        
endmodule
