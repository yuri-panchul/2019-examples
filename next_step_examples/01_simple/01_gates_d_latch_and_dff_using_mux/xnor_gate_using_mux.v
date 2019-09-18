module xnor_gate_using_mux
(
    input  a,
    input  b,
    output o
);

    mux_2_to_1 mux (~ a, a, b, o);

endmodule

