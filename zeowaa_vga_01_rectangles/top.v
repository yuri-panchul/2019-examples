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

    wire rst = ~ key [3];

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

    vga i_vga
    (
        .clk   ( clk    ),
        .rst   ( rst    ),
        .key   ( key_db ),
        .vsync ( vsync  ),
        .hsync ( hsync  ),
        .rgb   ( rgb    )
    );

endmodule
