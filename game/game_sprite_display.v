module game_sprite_display
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
    input                        clk,
    input                        reset,

    input      [X_WIDTH   - 1:0] pixel_x,
    input      [Y_WIDTH   - 1:0] pixel_y,

    input                        sprite_we,

    input      [X_WIDTH   - 1:0] sprite_x,
    input      [Y_WIDTH   - 1:0] sprite_y,
    
    input      [X_WIDTH   - 1:0] sprite_dx,
    input      [Y_WIDTH   - 1:0] sprite_dy,

    output reg                   rgb_en,
    output reg [RGB_WIDTH - 1:0] rgb
);

    //------------------------------------------------------------------------

    localparam ERGB_WIDTH = 1 + RGB_WIDTH;

    //------------------------------------------------------------------------

    reg sprite_en;
    reg use_as_tile;

    reg [`VDP_X_WIDTH - 1:0] sprite_x;
    reg [`VDP_Y_WIDTH - 1:0] sprite_y;

    reg [`VDP_SPRITE_WIDTH * `VDP_ERGB_WIDTH - 1:0]
        rows [0:`VDP_SPRITE_HEIGHT - 1];

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
            sprite_en <= 1'b0;
        else if (xy_we)
            sprite_en <= wr_data [`VDP_SPRITE_XY_ENABLE_BIT];
            
    always @ (posedge clk)
        if (xy_we)
        begin
            use_as_tile <= wr_data [`VDP_SPRITE_XY_TILE_BIT];
            sprite_x    <= wr_data [`VDP_SPRITE_XY_X_RANGE];
            sprite_y    <= wr_data [`VDP_SPRITE_XY_Y_RANGE];
        end

    always @ (posedge clk)
        if (row_we)
            rows [wr_row_index] <= wr_data;

    //------------------------------------------------------------------------

    wire [`VDP_X_WIDTH:0] x_pixel_minus_sprite
        = { 1'b0, pixel_x } - { 1'b0, sprite_x };

    wire [`VDP_X_WIDTH:0] x_sprite_plus_w_minus_pixel
        = { 1'b0, sprite_x } + `VDP_SPRITE_WIDTH - 1 - { 1'b0, pixel_x };
        
    wire [`VDP_Y_WIDTH:0] y_pixel_minus_sprite
        = { 1'b0, pixel_y } - { 1'b0, sprite_y };

    wire [`VDP_Y_WIDTH:0] y_sprite_plus_h_minus_pixel
        = { 1'b0, sprite_y } + `VDP_SPRITE_HEIGHT - 1 - { 1'b0, pixel_y };

    //------------------------------------------------------------------------

    wire x_hit =    use_as_tile
                 ||
                       x_pixel_minus_sprite        [`VDP_X_WIDTH] == 1'b0
                    && x_sprite_plus_w_minus_pixel [`VDP_X_WIDTH] == 1'b0;

    wire y_hit =    use_as_tile
                 ||
                       y_pixel_minus_sprite        [`VDP_Y_WIDTH] == 1'b0
                    && y_sprite_plus_h_minus_pixel [`VDP_Y_WIDTH] == 1'b0;

    //------------------------------------------------------------------------

    wire [`VDP_SPRITE_COLUMN_INDEX_WIDTH - 1:0] column_index
        = use_as_tile ?
              pixel_x              [`VDP_SPRITE_COLUMN_INDEX_WIDTH - 1:0]
            : x_pixel_minus_sprite [`VDP_SPRITE_COLUMN_INDEX_WIDTH - 1:0];

    wire [`VDP_SPRITE_ROW_INDEX_WIDTH - 1:0] row_index
        = use_as_tile ?
              pixel_y              [`VDP_SPRITE_ROW_INDEX_WIDTH    - 1:0]
            : y_pixel_minus_sprite [`VDP_SPRITE_ROW_INDEX_WIDTH    - 1:0];

    wire [`VDP_SPRITE_WIDTH * `VDP_ERGB_WIDTH - 1:0] row = rows [row_index];

    // Here we assume that `VDP_SPRITE_WIDTH == 8 and `VDP_ERGB_WIDTH == 4
    // TODO: instantiate here a more generic mux that is handled by all
    // synthesis tools well

    reg [`VDP_ERGB_WIDTH - 1:0] ergb;
    
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

endmodule
