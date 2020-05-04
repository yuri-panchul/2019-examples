module dffr (input clock, reset, d, output reg q);

    always @ (posedge clock)
        if (reset)
            q <= 1'b0;
        else
            q <= d;

endmodule

module top
(
    input  clock, reset, i1, i2,
    output o1, o2
);

    wire w1, w2, w3, w4;

    and  a1 (i1, i2, w1);
    or   o1 (i2, w1, w3);
    dffr f1 (clock, reset, w3, w4);
    and  a2 (w4, i2, o1);
    not  n1 (w1, o2);

endmodule
