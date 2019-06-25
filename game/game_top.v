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
    input        clk,
    input        reset,

    input        key,
    input  [1:0] sw,

    output       hsync,
    output       vsync,
    output [2:0] rgb
);

    localparam N_PIPE_STAGES = 1;

    //------------------------------------------------------------------------

    wire                 display_on;
    wire [X_WIDTH - 1:0] pixel_x;
    wire [Y_WIDTH - 1:0] pixel_y;

    game_hvsync
    # (
        .N_PIPE_STAGES ( 3             ),

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
        .x          ( pixel_x    ),
        .y          ( pixel_y    )
    );

    //------------------------------------------------------------------------

    wire [15:0] random;

    game_random random_generator (clk, reset, random);

    //------------------------------------------------------------------------

    wire strobe_to_restart;

    game_strobe # (.width (29)) strobe_generator
        (clk, reset, strobe_to_restart);

    //------------------------------------------------------------------------

    wire                   sprite_target_write = strobe_to_restart;

    reg  [X_WIDTH   - 1:0] sprite_target_write_x;
    wire [Y_WIDTH   - 1:0] sprite_target_write_y;

    reg  [            1:0] sprite_target_write_dx;
    wire                   sprite_target_write_dy;

    wire [X_WIDTH   - 1:0] sprite_target_x;
    wire [Y_WIDTH   - 1:0] sprite_target_y;

    wire                   sprite_target_out_of_screen;

    wire                   sprite_target_rgb_en;
    wire [            2:0] sprite_target_rgb;

    //------------------------------------------------------------------------

    always @*
    begin
        if (random [7])
        begin
            sprite_target_write_x  = 10'd0;
            sprite_target_write_dx = 2'b01;
        end
        else
        begin
            sprite_target_write_x  = SCREEN_WIDTH - 8;
            sprite_target_write_dx = { 1'b1, random [6] };
        end
    end
    
    assign sprite_target_write_y  = SCREEN_HEIGHT / 10 + random [5:0];
    assign sprite_target_write_dy = 1'd0;

    //------------------------------------------------------------------------

    game_sprite_top
    #(
        .SCREEN_WIDTH  ( SCREEN_WIDTH  ),
        .SCREEN_HEIGHT ( SCREEN_HEIGHT ),

        .SPRITE_WIDTH  ( 8             ),
        .SPRITE_HEIGHT ( 8             ),

        .X_WIDTH       ( X_WIDTH       ),
        .Y_WIDTH       ( Y_WIDTH       ),

        .DX_WIDTH      ( 2             ),
        .DY_WIDTH      ( 1             ),

        .RGB_WIDTH     ( 3             ),

        .ROW_0 ( 32'h000bb000 ),
        .ROW_1 ( 32'h00099000 ),
        .ROW_2 ( 32'h00099000 ),
        .ROW_3 ( 32'hb99ff99b ),
        .ROW_4 ( 32'hb99ff99b ),
        .ROW_5 ( 32'h00099000 ),
        .ROW_6 ( 32'h00099000 ),
        .ROW_7 ( 32'h000bb000 )
    )
    sprite_target
    (
        .clk                   ( clk                          ),
        .reset                 ( reset                        ),

        .pixel_x               ( pixel_x                      ),
        .pixel_y               ( pixel_y                      ),

        .sprite_write          ( sprite_target_write          ),

        .sprite_write_x        ( sprite_target_write_x        ),
        .sprite_write_y        ( sprite_target_write_y        ),

        .sprite_write_dx       ( sprite_target_write_dx       ),
        .sprite_write_dy       ( sprite_target_write_dy       ),

        .sprite_x              ( sprite_target_x              ),
        .sprite_y              ( sprite_target_y              ),

        .sprite_out_of_screen  ( sprite_target_out_of_screen  ),

        .rgb_en                ( sprite_target_rgb_en         ),
        .rgb                   ( sprite_target_rgb            )
    );

    //------------------------------------------------------------------------

    wire                   sprite_torpedo_write = strobe_to_restart;

    wire [X_WIDTH   - 1:0] sprite_torpedo_write_x;
    wire [Y_WIDTH   - 1:0] sprite_torpedo_write_y;

    reg  [            1:0] sprite_torpedo_write_dx;
    reg  [            2:0] sprite_torpedo_write_dy;

    wire [X_WIDTH   - 1:0] sprite_torpedo_x;
    wire [Y_WIDTH   - 1:0] sprite_torpedo_y;

    wire                   sprite_torpedo_out_of_screen;

    wire                   sprite_torpedo_rgb_en;
    wire [            2:0] sprite_torpedo_rgb;

    //------------------------------------------------------------------------

    assign sprite_torpedo_write_x  = SCREEN_WIDTH / 2 + random [15:10];
    assign sprite_torpedo_write_y  = SCREEN_HEIGHT - 16;

    always @*
    begin
        case (sw)
        2'b00: sprite_torpedo_write_dx = 2'b00;
        2'b01: sprite_torpedo_write_dx = 2'b01;
        2'b10: sprite_torpedo_write_dx = 2'b11;
        2'b11: sprite_torpedo_write_dx = 2'b00;
        endcase

        case (sw)
        2'b00: sprite_torpedo_write_dy = 3'b111;
        2'b01: sprite_torpedo_write_dy = 3'b110;
        2'b10: sprite_torpedo_write_dy = 3'b110;
        2'b11: sprite_torpedo_write_dy = 3'b110;
        endcase
    end

    //------------------------------------------------------------------------

    game_sprite_top
    #(
        .SCREEN_WIDTH  ( SCREEN_WIDTH  ),
        .SCREEN_HEIGHT ( SCREEN_HEIGHT ),

        .SPRITE_WIDTH  ( 8             ),
        .SPRITE_HEIGHT ( 8             ),

        .X_WIDTH       ( X_WIDTH       ),
        .Y_WIDTH       ( Y_WIDTH       ),

        .DX_WIDTH      ( 2             ),
        .DY_WIDTH      ( 3             ),

        .RGB_WIDTH     ( 3             ),

        .ROW_0 ( 32'h000cc000 ),
        .ROW_1 ( 32'h00cccc00 ),
        .ROW_2 ( 32'h0cceecc0 ),
        .ROW_3 ( 32'hcccccccc ),
        .ROW_4 ( 32'hcc0cc0cc ),
        .ROW_5 ( 32'hcc0cc0cc ),
        .ROW_6 ( 32'hcc0cc0cc ),
        .ROW_7 ( 32'hcc0cc0cc )
    )
    sprite_torpedo
    (
        .clk                   ( clk                           ),
        .reset                 ( reset                         ),

        .pixel_x               ( pixel_x                       ),
        .pixel_y               ( pixel_y                       ),

        .sprite_write          ( sprite_torpedo_write          ),

        .sprite_write_x        ( sprite_torpedo_write_x        ),
        .sprite_write_y        ( sprite_torpedo_write_y        ),

        .sprite_write_dx       ( sprite_torpedo_write_dx       ),
        .sprite_write_dy       ( sprite_torpedo_write_dy       ),

        .sprite_x              ( sprite_torpedo_x              ),
        .sprite_y              ( sprite_torpedo_y              ),

        .sprite_out_of_screen  ( sprite_torpedo_out_of_screen  ),

        .rgb_en                ( sprite_torpedo_rgb_en         ),
        .rgb                   ( sprite_torpedo_rgb            )
    );

    //------------------------------------------------------------------------
/*
    game_collision
    #(
        .X_WIDTH         ( X_WIDTH       ),
        .Y_WIDTH         ( Y_WIDTH       ),

        .SPRITE_1_WIDTH  ( 8             ),
        .SPRITE_1_HEIGHT ( 8             ),

        .SPRITE_1_WIDTH  ( 8             ),
        .SPRITE_1_HEIGHT ( 8             ),
    (
        .clk                   ( clk                           ),
        .reset                 ( reset                         ),

        .pixel_x               ( pixel_x                       ),
        .pixel_y               ( pixel_y                       ),

        .sprite_write          ( sprite_torpedo_write          ),

        .sprite_write_x        ( sprite_torpedo_write_x        ),
        .sprite_write_y        ( sprite_torpedo_write_y        ),

        .sprite_write_dx       ( sprite_torpedo_write_dx       ),
        .sprite_write_dy       ( sprite_torpedo_write_dy       ),

        .sprite_x              ( sprite_torpedo_x              ),
        .sprite_y              ( sprite_torpedo_y              ),

        .sprite_out_of_screen  ( sprite_torpedo_out_of_screen  ),

        .rgb_en                ( sprite_torpedo_rgb_en         ),
        .rgb                   ( sprite_torpedo_rgb            )
    );
*/
    //------------------------------------------------------------------------

    wire end_of_game_timer_start = 1'b0;
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

    wire game_won = 1'b0;

    game_mixer mixer
    (
        .clk                        ( clk                        ),
        .reset                      ( reset                      ),

        .display_on                 ( display_on                 ),

        .sprite_target_rgb_en       ( sprite_target_rgb_en       ),
        .sprite_target_rgb          ( sprite_target_rgb          ),

        .sprite_torpedo_rgb_en      ( sprite_torpedo_rgb_en      ),
        .sprite_torpedo_rgb         ( sprite_torpedo_rgb         ),

        .game_won                   ( game_won                   ),
        .end_of_game_timer_running  ( end_of_game_timer_running  ),
        .random                     ( random [0]                 ),

        .rgb                        ( rgb                        )
    );

    //------------------------------------------------------------------------

endmodule
