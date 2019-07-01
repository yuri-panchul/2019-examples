`ifndef GAME_CONFIG_VH
`define GAME_CONFIG_VH

`include "config.vh"

`define SCREEN_WIDTH   640
`define SCREEN_HEIGHT  480

`define X_WIDTH        10  // X coordinate width in bits
`define Y_WIDTH        10  // Y coordinate width in bits

`define RGB_WIDTH      3

`define GAME_MASTER_FSM_MODULE      game_master_fsm_alt_4

`define N_MIXER_PIPE_STAGES         2

`define GAME_SPRITE_DISPLAY_MODULE  game_sprite_display_alt_1
// `define GAME_SPRITE_DISPLAY_MODULE  game_sprite_display

`endif
