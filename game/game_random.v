module game_random_generator
(
    input             clk,
    input             reset,
    output reg [15:0] random
);

    // Uses LFSR, Linear Feedback Shift Register

    localparam WIDTH = 16,
               TAPS  = 16'b1000000001011;

    lfsr #(16, 16'b1000000001011, 0) i_lfsr
    (
        .clk    ( clk    ),
        .reset  ( reset  ),
        .enable ( 1'b1   ),
        .out    ( random )
    );

endmodule
