module game_sprite_top
#(
    parameter SCREEN_WIDTH  = 640,
              SCREEN_HEIGHT = 480,

              SPRITE_WIDTH  = 8,
              SPRITE_HEIGHT = 8,

              X_WIDTH       = 10,   // X coordinate width in bits
              Y_WIDTH       = 10,   // Y coordinate width in bits

              DX_WIDTH      = 2,    // X speed width in bits
              DY_WIDTH      = 2,    // Y speed width in bits

              RGB_WIDTH     = 3,

              ROW_0         = 32'h000cc000,
              ROW_1         = 32'h000cc000,
              ROW_2         = 32'h000cc000,
              ROW_3         = 32'hcccccccc,
              ROW_4         = 32'hcccccccc,
              ROW_5         = 32'h000cc000,
              ROW_6         = 32'h000cc000,
              ROW_7         = 32'h000cc000
)

//----------------------------------------------------------------------------

(
    input                    clk,
    input                    reset,

    input  [X_WIDTH   - 1:0] pixel_x,
    input  [Y_WIDTH   - 1:0] pixel_y,

    input                    sprite_write,

    input  [X_WIDTH   - 1:0] sprite_write_x,
    input  [Y_WIDTH   - 1:0] sprite_write_y,

    input  [DX_WIDTH  - 1:0] sprite_write_dx,
    input  [DY_WIDTH  - 1:0] sprite_write_dy,

    output [X_WIDTH   - 1:0] sprite_x,
    output [Y_WIDTH   - 1:0] sprite_y,

    output                   sprite_within_screen,

    output [X_WIDTH   - 1:0] sprite_out_left,
    output [X_WIDTH   - 1:0] sprite_out_right,
    output [Y_WIDTH   - 1:0] sprite_out_top,
    output [Y_WIDTH   - 1:0] sprite_out_bottom,

    output                   rgb_en,
    output [RGB_WIDTH - 1:0] rgb
);

    game_sprite_control
    #(
        .X_WIDTH               ( X_WIDTH               ),
        .Y_WIDTH               ( Y_WIDTH               ),

        .DX_WIDTH              ( DX_WIDTH              ),
        .DY_WIDTH              ( DY_WIDTH              )
    )
    sprite_control
    (
        .clk                   ( clk                   ),
        .reset                 ( reset                 ),

        .sprite_write          ( sprite_write          ),

        .sprite_write_x        ( sprite_write_x        ),
        .sprite_write_y        ( sprite_write_y        ),

        .sprite_write_dx       ( sprite_write_dx       ),
        .sprite_write_dy       ( sprite_write_dy       ),

        .sprite_x              ( sprite_x              ),
        .sprite_y              ( sprite_y              )
    );

    game_sprite_display
    #(
        .SCREEN_WIDTH          ( SCREEN_WIDTH          ),
        .SCREEN_HEIGHT         ( SCREEN_HEIGHT         ),

        .SPRITE_WIDTH          ( SPRITE_WIDTH          ),
        .SPRITE_HEIGHT         ( SPRITE_HEIGHT         ),

        .X_WIDTH               ( X_WIDTH               ),
        .Y_WIDTH               ( Y_WIDTH               ),

        .RGB_WIDTH             ( RGB_WIDTH             ),

        .ROW_0                 ( ROW_0                 ),
        .ROW_1                 ( ROW_1                 ),
        .ROW_2                 ( ROW_2                 ),
        .ROW_3                 ( ROW_3                 ),
        .ROW_4                 ( ROW_4                 ),
        .ROW_5                 ( ROW_5                 ),
        .ROW_6                 ( ROW_6                 ),
        .ROW_7                 ( ROW_7                 )
    )
    sprite_display
    (
        .clk                   ( clk                   ),
        .reset                 ( reset                 ),

        .pixel_x               ( pixel_x               ),
        .pixel_y               ( pixel_y               ),

        .sprite_x              ( sprite_x              ),
        .sprite_y              ( sprite_y              ),

        .sprite_within_screen  ( sprite_within_screen  ),

        .sprite_out_left       ( sprite_out_left       ),
        .sprite_out_right      ( sprite_out_right      ),
        .sprite_out_top        ( sprite_out_top        ),
        .sprite_out_bottom     ( sprite_out_bottom     ),

        .rgb_en                ( rgb_en                ),
        .rgb                   ( rgb                   )
    );

endmodule
