module nand_gate_using_mux
(
    input  a,
    input  b,
    output o
);

    mux_2_to_1 mux (1'b0, a, b, o);

endmodule

