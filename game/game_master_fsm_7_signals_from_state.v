`include "game_config.vh"

module game_master_fsm
(
    input  clk,
    input  reset,

    input  key,

    output sprite_target_write_xy,
    output sprite_torpedo_write_xy,

    output sprite_target_write_dxy,
    output sprite_torpedo_write_dxy,

    output sprite_target_enable_update,
    output sprite_torpedo_enable_update,

    input  sprite_target_within_screen,
    input  sprite_torpedo_within_screen,

    input  collision,

    output end_of_game_timer_start,
    output game_won,

    input  end_of_game_timer_running
);

    localparam [5:0] STATE_START    = 6'b100000,
                     STATE_AIM      = 6'b001000,
                     STATE_SHOOT    = 6'b011100,
                     STATE_WON      = 6'b000011,
                     STATE_WON_END  = 6'b000001,
                     STATE_LOST     = 6'b000010,
                     STATE_LOST_END = 6'b000000;
    

    reg [5:0] state;
    reg [5:0] n_state;

    assign sprite_target_write_xy        = state [5];
    assign sprite_torpedo_write_xy       = state [5];
    assign sprite_target_write_dxy       = state [5];
    assign sprite_torpedo_write_dxy      = state [4];
    assign sprite_target_enable_update   = state [3];
    assign sprite_torpedo_enable_update  = state [2];
    assign end_of_game_timer_start       = state [1];
    assign game_won                      = state [0];

    //------------------------------------------------------------------------

    always @*
    begin
        d_state = state;

        d_sprite_target_write_xy        = 1'b0;
        d_sprite_torpedo_write_xy       = 1'b0;

        d_sprite_target_write_dxy       = 1'b0;
        d_sprite_torpedo_write_dxy      = 1'b0;

        d_sprite_target_enable_update   = 1'b0;
        d_sprite_torpedo_enable_update  = 1'b0;

        d_end_of_game_timer_start       = 1'b0;
        d_game_won                      = game_won;

        //--------------------------------------------------------------------

        case (state)

        STATE_START:
        begin
            d_sprite_target_write_xy        = 1'b1;
            d_sprite_torpedo_write_xy       = 1'b1;

            d_sprite_target_write_dxy       = 1'b1;

            d_game_won                      = 1'b0;

            d_state = STATE_AIM;
        end

        STATE_AIM:
        begin
            d_sprite_target_enable_update   = 1'b1;

            if (key)
            begin
                d_state = STATE_SHOOT;
            end
            else if (end_of_game)
            begin
                d_end_of_game_timer_start   = 1'b1;

                d_state = STATE_END;
            end
        end

        STATE_SHOOT:
        begin
            d_sprite_torpedo_write_dxy      = 1'b1;

            d_sprite_target_enable_update   = 1'b1;
            d_sprite_torpedo_enable_update  = 1'b1;

            if (collision)
                d_game_won = 1'b1;

            if (end_of_game)
            begin
                d_end_of_game_timer_start   = 1'b1;

                d_state = STATE_END;
            end
        end

        STATE_END:
        begin
            // TODO: Investigate why it needs collision detection here
            // and not in previous state

            if (collision)
                d_game_won = 1'b1;

            if (! end_of_game_timer_running)
                d_state = STATE_START;
        end

        endcase
    end

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
        begin
            state                         <= STATE_START;

            sprite_target_write_xy        <= 1'b0;
            sprite_torpedo_write_xy       <= 1'b0;

            sprite_target_write_dxy       <= 1'b0;
            sprite_torpedo_write_dxy      <= 1'b0;

            sprite_target_enable_update   <= 1'b0;
            sprite_torpedo_enable_update  <= 1'b0;

            end_of_game_timer_start       <= 1'b0;
            game_won                      <= 1'b0;
        end
        else
        begin
            state                         <= d_state;

            sprite_target_write_xy        <= d_sprite_target_write_xy;
            sprite_torpedo_write_xy       <= d_sprite_torpedo_write_xy;

            sprite_target_write_dxy       <= d_sprite_target_write_dxy;
            sprite_torpedo_write_dxy      <= d_sprite_torpedo_write_dxy;

            sprite_target_enable_update   <= d_sprite_target_enable_update;
            sprite_torpedo_enable_update  <= d_sprite_torpedo_enable_update;

            end_of_game_timer_start       <= d_end_of_game_timer_start;
            game_won                      <= d_game_won;
        end

endmodule
