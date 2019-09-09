module bin_to_gray
# (
    parameter N = 4
)
(
    input  [N-1:0] bin,
    output [N-1:0] gray
);

    assign gray = (bin >> 1) ^ bin;

endmodule
