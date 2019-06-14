module seven_segment_digit
(
    input      [3:0] dig,
    output reg [6:0] abcdefg
);

    always @*
        case (dig)
        'h0: abcdefg = 'b0000001;  // a b c d e f g
        'h1: abcdefg = 'b1001111;
        'h2: abcdefg = 'b0010010;  //   --a--
        'h3: abcdefg = 'b0000110;  //  |     |
        'h4: abcdefg = 'b1001100;  //  f     b
        'h5: abcdefg = 'b0100100;  //  |     |
        'h6: abcdefg = 'b0100000;  //   --g--
        'h7: abcdefg = 'b0001111;  //  |     |
        'h8: abcdefg = 'b0000000;  //  e     c
        'h9: abcdefg = 'b0001100;  //  |     |
        'ha: abcdefg = 'b0001000;  //   --d-- 
        'hb: abcdefg = 'b1100000;
        'hc: abcdefg = 'b0110001;
        'hd: abcdefg = 'b1000010;
        'he: abcdefg = 'b0110000;
        'hf: abcdefg = 'b0111000;
        endcase

endmodule
