module tb_sender
(
    input            clk,
    input            rst,
    output reg [3:0] data,
    output reg       en
);

    always @ (posedge clk or negedge rst)
        if (rst)
        begin
            data <= 0;
            en   <= 0;
        end
        else
        begin
            $display ("Sending %d", data + 1);
            data <= data + 1;
            en   <= 1;
        end

endmodule
