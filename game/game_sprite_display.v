module game_sprite_display
#(
    parameter SCREEN_WIDTH  = 640,
              SCREEN_HEIGHT = 480,

              SPRITE_WIDTH  = 8,
              SPRITE_HEIGHT = 8,

              X_WIDTH       = 10,   // X coordinate width in bits
              Y_WIDTH       = 10,   // Y coordinate width in bits

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
    input                        clk,
    input                        reset,

    input      [X_WIDTH   - 1:0] pixel_x,
    input      [Y_WIDTH   - 1:0] pixel_y,

    input      [X_WIDTH   - 1:0] sprite_x,
    input      [Y_WIDTH   - 1:0] sprite_y,

    output reg                   sprite_out_of_screen,

    output reg                   rgb_en,
    output reg [RGB_WIDTH - 1:0] rgb
);

    //------------------------------------------------------------------------

    localparam ERGB_WIDTH = 1 + RGB_WIDTH;

    //------------------------------------------------------------------------

    wire [X_WIDTH:0] screen_w_1_minus_sprite
        = SCREEN_WIDTH - 1 - { 1'b0, sprite_x };

    wire [X_WIDTH:0] x_sprite_plus_w_1
        = { 1'b0, sprite_x } + SPRITE_WIDTH - 1;

    wire x_sprite_out_of_screen
        =    screen_w_1_minus_sprite [X_WIDTH] == 1'b0
          && x_sprite_plus_w_1       [X_WIDTH] == 1'b0;

    //------------------------------------------------------------------------

    wire [X_WIDTH:0] x_pixel_minus_sprite
        = { 1'b0, pixel_x } - { 1'b0, sprite_x };

    wire [X_WIDTH:0] x_sprite_plus_w_1_minus_pixel
        = x_sprite_plus_w_1 - { 1'b0, pixel_x };

    wire x_hit =    x_pixel_minus_sprite          [X_WIDTH] == 1'b0
                 && x_sprite_plus_w_1_minus_pixel [X_WIDTH] == 1'b0;

    //------------------------------------------------------------------------

    wire [Y_WIDTH:0] screen_h_1_minus_sprite
        = SCREEN_HEIGHT - 1 - { 1'b0, sprite_y };

    wire [Y_WIDTH:0] y_sprite_plus_h_1
        = { 1'b0, sprite_y } + SPRITE_HEIGHT - 1;

    wire y_sprite_out_of_screen
        =    screen_h_1_minus_sprite [Y_WIDTH] == 1'b0
          && y_sprite_plus_h_1       [Y_WIDTH] == 1'b0;

    //------------------------------------------------------------------------

    wire [Y_WIDTH:0] y_pixel_minus_sprite
        = { 1'b0, pixel_y } - { 1'b0, sprite_y };

    wire [Y_WIDTH:0] y_sprite_plus_h_1_minus_pixel
        = y_sprite_plus_h_1 - { 1'b0, pixel_y };

    wire y_hit =    y_pixel_minus_sprite          [Y_WIDTH] == 1'b0
                 && y_sprite_plus_h_1_minus_pixel [Y_WIDTH] == 1'b0;

    //------------------------------------------------------------------------

    // Here we assume that SPRITE_WIDTH == 8 and ERGB_WIDTH == 4
    // TODO: instantiate here a more generic mux that is handled by all
    // synthesis tools well

    wire [2:0] row_index    = y_pixel_minus_sprite [2:0];
    wire [2:0] column_index = x_pixel_minus_sprite [2:0];

    reg [SPRITE_WIDTH * ERGB_WIDTH - 1:0] row;

    always @*
        case (row_index)
        3'd0: row = ROW_0;
        3'd1: row = ROW_1;
        3'd2: row = ROW_2;
        3'd3: row = ROW_3;
        3'd4: row = ROW_4;
        3'd5: row = ROW_5;
        3'd6: row = ROW_6;
        3'd7: row = ROW_7;
        endcase

    reg [ERGB_WIDTH - 1:0] ergb;
    
    always @*
        case (column_index)
        3'd0: ergb = row [31:28];
        3'd1: ergb = row [27:24];
        3'd2: ergb = row [23:20];
        3'd3: ergb = row [19:16];
        3'd4: ergb = row [15:12];
        3'd5: ergb = row [11: 8];
        3'd6: ergb = row [ 7: 4];
        3'd7: ergb = row [ 3: 0];
        endcase

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
            rgb_en <= 1'b0;
        else if (x_hit && y_hit)
            { rgb_en, rgb } <= ergb;
        else
            rgb_en <= 1'b0;

    always @ (posedge clk or posedge reset)
        if (reset)
            sprite_out_of_screen <= 1'b0;
        else
            sprite_out_of_screen
                <= x_sprite_out_of_screen || y_sprite_out_of_screen;

endmodule