module lfsr
# (
    parameter WIDTH  = 8,
              TAPS   = 8'b11101,
              INVERT = 0
)
(
    input                    clk,
    input                    reset,
    input                    enable,
    output reg [WIDTH - 1:0] out
);
    wire feedback = out [WIDTH - 1] ^ INVERT;

    always @(posedge clk)
        if (reset)
            out <= { out [WIDTH - 2:0], 1'b1 };
        else if (enable)
            out <= { out [WIDTH - 2:0], 1'b0 } ^ (feedback ? TAPS : 0);

endmodule
