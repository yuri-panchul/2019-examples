module top
# (
    parameter debounce_depth             = 8,
              shift_strobe_width         = 23,
              seven_segment_strobe_width = 10
)
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
    output [ 2:0] rgb,

    inout  [18:0] gpio
);

    wire reset = ~ key [3];

    //------------------------------------------------------------------------

    wire [3:0] key_db;
    wire [7:0] sw_db;

    sync_and_debounce # (.w (4), .depth (debounce_depth))
        i_sync_and_debounce_key
            (clk, reset, ~ key, key_db);
    
    sync_and_debounce # (.w (8), .depth (debounce_depth))
        i_sync_and_debounce_sw
            (clk, reset, ~ sw, sw_db);

    //------------------------------------------------------------------------

    wire shift_strobe;

    strobe_gen # (.w (shift_strobe_width)) i_shift_strobe
        (clk, reset, shift_strobe);

    wire [11:0] out_reg;

    shift_register # (.w (12)) i_shift_reg
    (
        .clk     ( clk          ),
        .reset   ( reset        ),
        .en      ( shift_strobe ),
        .in      ( key_db [1]   ),
        .out_reg ( out_reg      )
    );

    assign led = ~ out_reg;

    //------------------------------------------------------------------------

    wire [15:0] shift_strobe_count;

    counter # (16) i_shift_strobe_counter
    (
        .clk   ( clk                ),
        .reset ( reset              ),
        .en    ( shift_strobe       ),
        .cnt   ( shift_strobe_count )
    );

    //------------------------------------------------------------------------

    wire out_moore_fsm;

    moore_fsm i_moore_fsm
    (
        .clk   ( clk           ),
        .reset ( reset         ),
        .en    ( shift_strobe  ),
        .a     ( out_reg [0]   ),
        .y     ( out_moore_fsm )
    );
    
    wire [7:0] moore_fsm_out_count;

    counter # (8) i_moore_fsm_out_counter
    (
        .clk   ( clk                          ),
        .reset ( reset                        ),
        .en    ( shift_strobe & out_moore_fsm ),
        .cnt   ( moore_fsm_out_count          )
    );

    //------------------------------------------------------------------------

    wire out_mealy_fsm;

    mealy_fsm i_mealy_fsm
    (
        .clk   ( clk           ),
        .reset ( reset         ),
        .en    ( shift_strobe  ),
        .a     ( out_reg [0]   ),
        .y     ( out_mealy_fsm )
    );
    
    wire [7:0] mealy_fsm_out_count;

    counter # (8) i_mealy_fsm_out_counter
    (
        .clk   ( clk                          ),
        .reset ( reset                        ),
        .en    ( shift_strobe & out_mealy_fsm ),
        .cnt   ( mealy_fsm_out_count          )
    );

    //------------------------------------------------------------------------

    assign buzzer = 1'b1; // ~ key_db [0];

    //------------------------------------------------------------------------

    game_top i_game_top
    (
        .clk   (   clk       ),
        .reset (   reset     ),

        .key   ( ~ key [1]   ),
        .sw    ( ~ sw  [1:0] ),

        .vsync (   vsync     ),
        .hsync (   hsync     ),
        .rgb   (   rgb       )
    );
/*
    wire       display_on;
    wire [9:0] hpos;
    wire [9:0] vpos;

    vga i_vga
    (
        .clk        ( clk        ),
        .reset      ( reset      ),
        .hsync      ( hsync      ),
        .vsync      ( vsync      ),
        .display_on ( display_on ),
        .hpos       ( hpos       ),
        .vpos       ( vpos       )
    );

    wire [2:0] rgb_squares
        = hpos ==  0 || hpos == 639 || vpos ==  0 || vpos == 479 ? 3'b100 :
          hpos ==  5 || hpos == 634 || vpos ==  5 || vpos == 474 ? 3'b010 :
          hpos == 10 || hpos == 629 || vpos == 10 || vpos == 469 ? 3'b001 :
          hpos <  20 || hpos >  619 || vpos <  20 || vpos >= 459 ? 3'b000 :
          { hpos [4], vpos [4], hpos [3] ^ vpos [3] };

    wire        lfsr_enable = ! hpos [9:8] & ! vpos [9:8];
    wire [15:0] lfsr_out;

    lfsr #(16, 16'b1000000001011, 0) i_lfsr
    (
        .clk    ( clk         ),
        .reset  ( reset       ),
        .enable ( lfsr_enable ),
        .out    ( lfsr_out    )
    );

    wire star_on = & lfsr_out [15:9];

    assign rgb = lfsr_enable ?
                     (star_on ? lfsr_out [2:0] : 3'b0)
                   : rgb_squares;
*/
    //------------------------------------------------------------------------

    wire enc_a   = gpio [14];
    wire enc_b   = gpio [15];
    wire enc_btn = gpio [16];
    wire enc_swt = gpio [17];

    assign gpio [18] = 1;

    wire enc_a_db;
    wire enc_b_db;
    wire enc_btn_db;
    wire enc_swt_db;

    sync_and_debounce # (.w (4), .depth (debounce_depth))
        i_sync_and_debounce_enc
        (
            clk,
            reset,
            { enc_a    , enc_b    , enc_btn    , enc_swt    },
            { enc_a_db , enc_b_db , enc_btn_db , enc_swt_db }
        );

    wire [15:0] enc_value;

    rotary_encoder i_rotary_encoder
    (
        .clk        ( clk       ),
        .reset      ( reset     ),
        .a          ( enc_a_db  ),
        .b          ( enc_b_db  ),
        .value      ( enc_value )
    );

    //------------------------------------------------------------------------

    reg [31:0] number_to_display;

    always @*
        case (sw_db [0])

        1'b1:    number_to_display =
                 {
                     { 8 { enc_btn_db } },
                     { 8 { enc_swt_db } },
                     enc_value
                 };

        default: number_to_display =
                 {
                     shift_strobe_count,
                     moore_fsm_out_count,
                     mealy_fsm_out_count
                 };

        endcase

    //------------------------------------------------------------------------

    wire seven_segment_strobe;

    strobe_gen # (.w (seven_segment_strobe_width))
        i_seven_segment_strobe
            (clk, reset, seven_segment_strobe);

    seven_segment #(.w (32)) i_seven_segment
    (
        .clk     ( clk                  ),
        .reset   ( reset                ),
        .en      ( seven_segment_strobe ),
        .num     ( number_to_display    ),
        .dots    ( sw_db                ),
        .abcdefg ( abcdefgh [7:1]       ),
        .dot     ( abcdefgh [0]         ),
        .anodes  ( digit                )
    );

endmodule
