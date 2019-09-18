module nor_gate_using_mux
(
    input  a,
    input  b,
    output o
);

    mux_2_to_1 mux (~ a, 1'b0, b, o);

endmodule

