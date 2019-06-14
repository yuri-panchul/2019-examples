`include "config.vh"

module seven_segment
# (
    parameter w              = 32,
              bits_per_digit = 4,
              n_digits       = w / bits_per_digit
)
(
    input                   clk,
    input                   reset,
    input                   en,
    input  [w        - 1:0] num,
    input  [n_digits - 1:0] dots,
    output [6:0]            abcdefg,
    output                  dot,
    output [n_digits - 1:0] anodes
);

    //------------------------------------------------------------------------

    reg [n_digits - 1:0] anodes_d, anodes_q;

    always @*
        anodes_d <= { anodes_q [0], anodes_q [n_digits - 1 : 1] };

    always @ (posedge clk or posedge reset)
        if (reset)
            anodes_q <= { { n_digits - 1 { 1'b1 } }, 1'b0 };
        else if (en)
            anodes_q <= anodes_d;
    
    assign anodes = anodes_q;
    
    //------------------------------------------------------------------------

    wire [bits_per_digit - 1:0] dig;

    selector # (.w (bits_per_digit), .n (n_digits)) i_sel_dig
        (.d (num), .sel (~ anodes_d), .y (dig));

    wire [6:0] abcdefg_d;

    seven_segment_digit i_seven_segment_digit
        (.dig (dig), .abcdefg (abcdefg_d));

    register_no_rst # (7) i_abcdefg
    (
        .clk ( clk       ),
        .en  ( en        ),
        .d   ( abcdefg_d ),
        .q   ( abcdefg   )
    ); 

    //------------------------------------------------------------------------

    wire dot_d;

    selector # (.w (1), .n (n_digits)) i_sel_dot
        (.d (dots), .sel (~ anodes_d), .y (dot_d));

    register_no_rst i_dot
    (
        .clk (   clk   ),
        .en  (   en    ),
        .d   ( ~ dot_d ),
        .q   (   dot   )
    ); 

endmodule
