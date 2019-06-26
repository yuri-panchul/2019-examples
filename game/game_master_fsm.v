module game_master_fsm
(
    input  clk,
    input  reset,

    input  key,

    output sprite_target_write,
    output sprite_torpedo_write,

    input  sprite_target_within_screen,
    input  sprite_torpedo_within_screen,

    input  collision,

    output end_of_game_timer_start,
    output game_won,

    input  end_of_game_timer_running
);

    //------------------------------------------------------------------------

    // One-hot state machine

    localparam STATE_START_TARGET     = 0,
               STATE_WAIT_KEY         = 1,
               STATE_START_TORPEDO    = 2,
               STATE_WAIT_COLLISION   = 3,
               STATE_START_END_TIMER  = 4,
               STATE_GAME_WON         = 5,
               STATE_GAME_LOST        = 6;

    reg [STATE_START_TARGET:STATE_GAME_LOST] state, d_state;

    //------------------------------------------------------------------------

    wire end_of_game
        =   sprite_target_within_screen
          | sprite_torpedo_within_screen
          | collision;

    //------------------------------------------------------------------------

    reg collision_reg;

    always @ (posedge clk)
        collision_reg <= collision; 

    //------------------------------------------------------------------------

    always @*
    begin
       d_state = 0;

            if (      state [ STATE_START_TARGET    ] )
                    d_state [ STATE_WAIT_KEY        ] = 1;

       //---------------------------------------------------------------------

       else if (      state [ STATE_WAIT_KEY        ] )
            if ( key )
                    d_state [ STATE_START_TORPEDO   ] = 1;
            else
                    d_state [ STATE_WAIT_KEY        ] = 1;

       //---------------------------------------------------------------------

       else if (      state [ STATE_START_TORPEDO   ] )
                    d_state [ STATE_WAIT_COLLISION  ] = 1;

       //---------------------------------------------------------------------

       else if (      state [ STATE_WAIT_COLLISION  ] )
            if ( end_of_game )
                    d_state [ STATE_START_END_TIMER ] = 1;
            else
                    d_state [ STATE_WAIT_COLLISION  ] = 1;

       //---------------------------------------------------------------------

       else if (      state [ STATE_START_END_TIMER ] )
            if ( collision_reg )
                    d_state [ STATE_GAME_WON        ] = 1;
            else
                    d_state [ STATE_GAME_LOST       ] = 1;

       //---------------------------------------------------------------------

       else if (      state [ STATE_GAME_WON        ] )

            if ( end_of_game_timer_running )
                    d_state [ STATE_START_TARGET    ] = 1;
            else
                    d_state [ STATE_GAME_WON        ] = 1;

       //---------------------------------------------------------------------

       else if (      state [ STATE_GAME_LOST       ] )

            if ( end_of_game_timer_running )
                    d_state [ STATE_START_TARGET    ] = 1;
            else
                    d_state [ STATE_GAME_LOST       ] = 1;
    end

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
            state <= (1 << STATE_START_TARGET);
        else
            state <= d_state;

    //------------------------------------------------------------------------

    assign sprite_target_write     = state [ STATE_START_TARGET    ];
    assign sprite_torpedo_write    = state [ STATE_START_TORPEDO   ];
    assign end_of_game_timer_start = state [ STATE_START_END_TIMER ];
    assign game_won                = state [ STATE_GAME_WON        ];

endmodule
