module pmod_enc_rotary_encoder
(
    input             clk,
    input             rst_n,
    input             a,
    input             b,
    output reg [15:0] value
);

    reg prev_a;

    always @ (posedge clk or negedge rst_n)
        if (! rst_n)
            prev_a <= 1'b1;
        else
            prev_a <= a;

    always @ (posedge clk or negedge rst_n)
        if (! rst_n)
        begin
            value <= 16'd0;
        end
        else if (a && ! prev_a)
        begin
            if (b)
                value <= value + 16'd1;
            else
                value <= value - 16'd1;
        end

endmodule
