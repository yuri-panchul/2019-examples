module dff_using_mux
(
    input  clk,
    input  d,
    output q
);

    mux_2_to_1 mux (1'b0, d, clk, q);

endmodule


