module top
(
    input         clk,
    input  [ 3:0] key,
    input  [ 7:0] sw,
    output [11:0] led,

    output [ 7:0] abcdefgh,
    output [ 7:0] digit,

    output        buzzer,

    output        vsync,
    output        hsync,
    output [ 2:0] rgb
);

    wire reset = ~ key [3];

    //------------------------------------------------------------------------

    wire [3:0] key_db;
    wire [7:0] sw_db;

    sync_and_debounce # (.w (4)) i_sync_and_debounce_key
        (clk, ~ key, key_db);
    
    sync_and_debounce # (.w (8)) i_sync_and_debounce_sw
        (clk, ~ sw, sw_db);

    //------------------------------------------------------------------------

    assign led = ~ { key_db, sw_db };

    assign abcdefgh = ~ 8'b0;
    assign digit    = ~ 8'b0;

    assign buzzer   = 1'b1;

    //------------------------------------------------------------------------

    wire hsync1, hsync2, vsync1, vsync2;
    wire [2:0] rgb1, rgb2;

    vga i_vga
    (
        .clk   ( clk    ),
        .reset ( reset  ),
        .key   ( key_db ),
        .vsync ( vsync1 ),
        .hsync ( hsync1 ),
        .rgb   ( rgb1   )
    );

    wire       display_on;
    wire [9:0] hpos;
    wire [9:0] vpos;

    hvsync_generator i_hsync_generator
    (
        .clk        ( clk        ),
        .reset      ( reset      ),
        .hsync      ( hsync2     ),
        .vsync      ( vsync2     ),
        .display_on ( display_on ),
        .hpos       ( hpos       ),
        .vpos       ( vpos       )
    );
    
    assign rgb2 = hpos ==  0 || hpos == 639 || vpos ==  0 || vpos == 479 ? 3'b100 :
                  hpos ==  5 || hpos == 634 || vpos ==  5 || vpos == 474 ? 3'b010 :
                  hpos == 10 || hpos == 629 || vpos == 10 || vpos == 469 ? 3'b001 :
                  3'b000;
                  
    // { hpos [4], vpos [4], hpos [3] ^ vpos [3] };

    assign hsync = key_db [0] ? hsync1 : hsync2;
    assign vsync = key_db [0] ? vsync1 : vsync2;
    assign rgb   = key_db [0] ? rgb1   : rgb2;

endmodule
