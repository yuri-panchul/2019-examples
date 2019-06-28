`include "game_config.vh"

module game_master_fsm_alt_1
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

    localparam [2:0] STATE_START_TARGET     = 0,
                     STATE_WAIT_KEY         = 1,
                     STATE_START_TORPEDO    = 2,
                     STATE_WAIT_COLLISION   = 3,
                     STATE_START_END_TIMER  = 4,
                     STATE_GAME_WON         = 5,
                     STATE_GAME_LOST        = 6,
                     N_STATES               = 7;

    reg [2:0] state;
    reg [2:0] d_state;

    //------------------------------------------------------------------------

    wire end_of_game
        =   ~ sprite_target_within_screen
          | ~ sprite_torpedo_within_screen
          |   collision;

    //------------------------------------------------------------------------

    reg collision_reg;

    always @ (posedge clk)
        collision_reg <= collision;

    //------------------------------------------------------------------------

    always @*
    begin
        d_state = state;
       
        case (state)

        STATE_START_TARGET:
       
            d_state = STATE_WAIT_KEY;


        STATE_WAIT_KEY:

             if (key)
                 d_state = STATE_START_TORPEDO;
             else if (end_of_game)
                 d_state = STATE_START_END_TIMER;

        STATE_START_TORPEDO:

             d_state = STATE_WAIT_COLLISION;

        STATE_WAIT_COLLISION:

             if (end_of_game)
                 d_state = STATE_START_END_TIMER;

        STATE_START_END_TIMER:

            if (collision_reg)
                d_state = STATE_GAME_WON;
            else
                d_state = STATE_GAME_LOST;

        STATE_GAME_WON:

            if (! end_of_game_timer_running)
                d_state = STATE_START_TARGET;

        STATE_GAME_LOST:

            if (! end_of_game_timer_running)
                d_state = STATE_START_TARGET;
                
        endcase
    end

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
            state <= STATE_START_TARGET;
        else
            state <= d_state;

    //------------------------------------------------------------------------

    assign sprite_target_write_xy       =   state == STATE_START_TARGET    ;
    assign sprite_torpedo_write_xy      =   state == STATE_START_TARGET    ;

    assign sprite_target_write_dxy      =   state == STATE_START_TARGET    ;

    assign sprite_torpedo_write_dxy     =   state == STATE_WAIT_KEY
                                          | state == STATE_WAIT_COLLISION  ;

    assign sprite_target_enable_update  =   state == STATE_WAIT_KEY
                                          | state == STATE_WAIT_COLLISION  ;

    assign sprite_torpedo_enable_update =   state == STATE_WAIT_COLLISION  ;

    assign end_of_game_timer_start      =   state == STATE_START_END_TIMER ;
    assign game_won                     =   state == STATE_GAME_WON        ;

endmodule
