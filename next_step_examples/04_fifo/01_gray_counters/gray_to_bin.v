module gray_to_bin
# (
    parameter N = 4
)
(
    input      [N-1:0] gray,
    output reg [N-1:0] bin
);

    integer i;

    always @*
        for (i = 0; i < N; i = i + 1)
            bin [i] = ^ (gray >> i);

endmodule
