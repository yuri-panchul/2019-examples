module seven_segment_digit
(
    input  [3:0] dig,
    output [6:0] abcdefg
);

    always @*
        case (dig)
        'h0: dig_to_seg = 'b0000001;  // a b c d e f g
        'h1: dig_to_seg = 'b1001111;
        'h2: dig_to_seg = 'b0010010;  //   --a--
        'h3: dig_to_seg = 'b0000110;  //  |     |
        'h4: dig_to_seg = 'b1001100;  //  f     b
        'h5: dig_to_seg = 'b0100100;  //  |     |
        'h6: dig_to_seg = 'b0100000;  //   --g--
        'h7: dig_to_seg = 'b0001111;  //  |     |
        'h8: dig_to_seg = 'b0000000;  //  e     c
        'h9: dig_to_seg = 'b0001100;  //  |     |
        'ha: dig_to_seg = 'b0001000;  //   --d-- 
        'hb: dig_to_seg = 'b1100000;
        'hc: dig_to_seg = 'b0110001;
        'hd: dig_to_seg = 'b1000010;
        'he: dig_to_seg = 'b0110000;
        'hf: dig_to_seg = 'b0111000;
        endcase

endmodule
