module d_latch_using_mux
(
    input  en,
    input  d,
    output q
);

    mux_2_to_1 mux (q, d, en, q);

endmodule
