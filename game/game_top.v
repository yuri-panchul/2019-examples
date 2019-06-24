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

              SCREEN_HEIGHT = 480,  // Screen height
              V_BOTTOM      =  10,  // Vertical bottom border
              V_SYNC        =   2,  // Vertical sync # lines
              V_TOP         =  33   // Vertical top border
)
(
    input            clk,
    input            reset,

    input            key,
    input      [1:0] sw,

    output           vsync,
    output           hsync,
    output reg [2:0] rgb
);

    localparam N_PIPE_STAGES = 1;

    //------------------------------------------------------------------------

    wire                 display_on;
    wire [X_WIDTH - 1:0] x;
    wire [Y_WIDTH - 1:0] y;

    game_hvsync
    # (
        .N_PIPE_STAGES ( 1             ),

        .X_WIDTH       ( X_WIDTH       ),
        .Y_WIDTH       ( Y_WIDTH       ),

        .H_DISPLAY     ( SCREEN_WIDTH  ),
        .H_FRONT       ( H_FRONT       ),
        .H_SYNC        ( H_SYNC        ),
        .H_BACK        ( H_BACK        ),

        .V_DISPLAY     ( SCREEN_HEIGHT ),
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

    //------------------------------------------------------------------------

    wire [15:0] random;

    game_random random_generator (clk, reset, random);

    //------------------------------------------------------------------------

    wire end_of_game_timer_start;
    wire end_of_game_timer_running;

    game_timer # (.width (24)) timer
    (
        .clk     ( clk                       ),
        .reset   ( reset                     ),
        .value   ( 24'hf00000                ),
        .start   ( end_of_game_timer_start   ),
        .running ( end_of_game_timer_running )
    );

    //------------------------------------------------------------------------

    //------------------------------------------------------------------------

    game_mixer mixer
    (
        .clk                        ( clk                        ),
        .reset                      ( reset                      ),

        .sprite_target_en           ( sprite_target_en           ),
        .sprite_target_rgb          ( sprite_target_rgb          ),

        .sprite_torpedo_en          ( sprite_torpedo_en          ),
        .sprite_torpedo_rgb         ( sprite_torpedo_rgb         ),

        .game_won                   ( game_won                   ),
        .end_of_game_timer_running  ( end_of_game_timer_running  ),
        .random                     ( random                     ),

        .rgb                        ( rgb                        )
    );
);

endmodule
