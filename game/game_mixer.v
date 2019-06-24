module game_mixer
(
    input            clk,
    input            reset,

    input            sprite_target_en,
    input      [2:0] sprite_target_rgb,

    input            sprite_torpedo_en,
    input      [2:0] sprite_torpedo_rgb,

    input            game_won,
    input            end_of_game_timer_running,
    input            random,

    output reg [2:0] rgb
);

    always @ (posedge clk or posedge reset)
        if (reset)
            rgb <= 3'b0;
        else if (end_of_game_timer_running)
            rgb <= { 1'b1, game_won, random [0] };
        else if (sprite_torpedo_en)
            rgb <= sprite_torpedo_rgb)
        else if (sprite_target_en)
            rgb <= sprite_target_rgb)
        else
            rgb <= 3'b0;

endmodule
