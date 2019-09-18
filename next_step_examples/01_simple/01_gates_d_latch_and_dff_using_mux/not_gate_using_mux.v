module not_gate_using_mux
(
    input  i,
    output o
);

    mux_2_to_1 mux (1'b1, 1'b0, i, o);

endmodule
