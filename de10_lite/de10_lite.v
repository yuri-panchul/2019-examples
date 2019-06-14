module top
(
    input           adc_clk_10,
    input           max10_clk1_50,
    input           max10_clk2_50,

    input   [ 1:0]  key,
    input   [ 9:0]  sw,
    output  [ 9:0]  ledr,

    output  [ 7:0]  hex0,
    output  [ 7:0]  hex1,
    output  [ 7:0]  hex2,
    output  [ 7:0]  hex3,
    output  [ 7:0]  hex4,
    output  [ 7:0]  hex5,

    output  [ 3:0]  vga_b,
    output  [ 3:0]  vga_g,
    output          vga_hs,
    output  [ 3:0]  vga_r,
    output          vga_vs,

    output  [12:0]  dram_addr,
    output  [ 1:0]  dram_ba,
    output          dram_cas_n,
    output          dram_cke,
    output          dram_clk,
    output          dram_cs_n,
    inout   [15:0]  dram_dq,
    output          dram_ldqm,
    output          dram_ras_n,
    output          dram_udqm,
    output          dram_we_n,

    output          gsensor_cs_n,
    input   [ 2:1]  gsensor_int,
    output          gsensor_sclk,
    inout           gsensor_sdi,
    inout           gsensor_sdo,

    inout   [15:0]  arduino_io,
    inout           arduino_reset_n,

    inout   [35:0]  gpio
);

