module game_top
# (
    parameter X_WIDTH       = 10,   // Width in bits of horizontal position
              Y_WIDTH       = 10,   // Width in bits of vertical position

              // Horizontal constants

              SCREEN_WIDTH  = 640,  // Screen width
              H_FRONT       =  16,  // Horizontal right border (front porch)
              H_SYNC        =  96,  // Horizontal sync width
              H_BACK        =  48,  // Horizontal left border (back porch)

              // Vertical constants

              SCREEN_HIGHT  = 480,  // Screen height
              V_BOTTOM      =  10,  // Vertical bottom border
              V_SYNC        =   2,  // Vertical sync # lines
              V_TOP         =  33   // Vertical top border
)
(
    input        clk,
    input        reset,

    input        key,
    input  [1:0] sw,

    output       vsync,
    output       hsync,
    output [2:0] rgb
);

    localparam N_PIPE_STAGES = 1;

    wire                 display_on;
    wire [X_WIDTH - 1:0] x;
    wire [Y_WIDTH - 1:0] y;

    game_hvsync
    # (
        .N_PIPE_STAGES ( 1             ),

        .X_WIDTH       ( X_WIDTH       ),
        .Y_WIDTH       ( Y_WIDTH       ),

        .SCREEN_WIDTH  ( SCREEN_WIDTH  ),
        .H_FRONT       ( H_FRONT       ),
        .H_SYNC        ( H_SYNC        ),
        .H_BACK        ( H_BACK        ),

        .SCREEN_HIGHT  ( SCREEN_HIGHT  ),
        .V_BOTTOM      ( V_BOTTOM      ),
        .V_SYNC        ( V_SYNC        ),
        .V_TOP         ( V_TOP         )
    )
    hvsync
    (
        .clk        ( clk        ),
        .reset      ( reset      ),
        .hsync      ( hsync      ),
        .vsync      ( vsync      ),
        .display_on ( display_on ),
        .x          ( x          ),
        .y          ( y          )
    );

    wire [15:0] random;

    game_random random_generator (clk, reset, random);

endmodule
