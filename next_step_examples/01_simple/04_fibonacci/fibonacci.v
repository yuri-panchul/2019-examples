module fibonacci
(
    input            clk,
    input            rst,
    output reg [7:0] num
);

    reg [7:0] num2;

    always @ (posedge clk or rst)
        if (rst)
            { num, num2 } <= { 8'b1, 8'b1 };
        else
            { num, num2 } <= { num2, num + num2 };

endmodule
