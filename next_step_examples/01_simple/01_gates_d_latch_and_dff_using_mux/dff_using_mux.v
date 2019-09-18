module dff_using_mux
(
    input  clk,
    input  d,
    output q
);

    wire w;

    mux_2_to_1 master (w, d, ~ clk, w);
    mux_2_to_1 slave  (q, w,   clk, q);

endmodule
