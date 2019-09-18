module fsm_3_bits_coming_from_right
(
    input            clk,
    input            rst,
    input            new_bit,
    output reg [1:0] rem
);

    reg [1:0] n_rem;

    always @ (posedge clk or posedge rst)
        if (rst)
            rem <= 0;
        else
            rem <= n_rem;

    always @*
        case (rem)
        2'd0:    n_rem = new_bit ? 2'd1 : 2'd0;
        2'd1:    n_rem = new_bit ? 2'd0 : 2'd2;
        2'd2:    n_rem = new_bit ? 2'd2 : 2'd1;
        default: n_rem = 2'bx;
        endcase

endmodule
