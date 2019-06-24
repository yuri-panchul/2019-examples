module game_hvsync
# (
    parameter N_PIPE_STAGES  = 0,
              X_WIDTH        = 10,
              Y_WIDTH        = 10,

              // Horizontal constants

              H_DISPLAY      = 640,  // horizontal display width
              H_FRONT        =  16,  // horizontal right border (front porch)
              H_SYNC         =  96,  // horizontal sync width
              H_BACK         =  48,  // horizontal left border (back porch)

              // Vertical constants

              V_DISPLAY      = 480,  // vertical display height
              V_BOTTOM       =  10,  // vertical bottom border
              V_SYNC         =   2,  // vertical sync # lines
              V_TOP          =  33   // vertical top border
)
(
    input                         clk,
    input                         reset,
    output reg                    hsync,
    output reg                    vsync,
    output reg                    display_on,
    output reg [X_WIDTH - 1:0] x,
    output reg [Y_WIDTH - 1:0] y
);

    //------------------------------------------------------------------------

    // Derived constants

    localparam H_SYNC_START  = H_DISPLAY    + H_FRONT + N_PIPE_STAGES,
               H_SYNC_END    = H_SYNC_START + H_SYNC - 1,
               H_MAX         = H_SYNC_END   + H_BACK,

               V_SYNC_START  = V_DISPLAY    + V_BOTTOM,
               V_SYNC_END    = V_SYNC_START + V_SYNC - 1,
               V_MAX         = V_SYNC_END   + V_TOP;

    //------------------------------------------------------------------------

    // Calculating next values of the counters

    reg [X_WIDTH - 1:0] d_x;
    reg [Y_WIDTH - 1:0] d_y;

    always @*
    begin
        if (x == H_MAX)
        begin
            d_x = 1'd0;

            if (y == V_MAX)
                d_y = 1'd0;
            else
                d_y = y + 1'd1;
        end
        else
        begin
          d_x = x + 1'd1;
          d_y = y;
        end
    end

    //------------------------------------------------------------------------

    // Enable to divide clock from 50 MHz to 25 MHz

    reg clk_en;

    always @ (posedge clk or posedge reset)
        if (reset)
            clk_en <= 1'b0;
        else
            clk_en <= ~ clk_en;

    //------------------------------------------------------------------------

    // Making all outputs registered

    always @ (posedge clk or posedge reset)
    begin
        if (reset)
        begin
            hsync       <= 1'b0;
            vsync       <= 1'b0;
            display_on  <= 1'b0;
            x           <= 1'b0;
            y           <= 1'b0;
        end
        else if (clk_en)
        begin
            hsync       <= ~ (    d_x >= H_SYNC_START
                               && d_x <= H_SYNC_END   );

            vsync       <= ~ (    d_y >= V_SYNC_START
                               && d_y <= V_SYNC_END   );

            display_on  <=   (    d_x <  H_DISPLAY    
                               && d_y <  V_DISPLAY    );

            x           <= d_x;
            y           <= d_y;
        end
    end

endmodule
