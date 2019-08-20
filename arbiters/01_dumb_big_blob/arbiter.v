module arbiter
(
    input            clk,
    input            rst,
    input      [7:0] req,
    output reg [7:0] gnt
);

    reg [7:0] d_gnt;
    reg [2:0] ptr;

    // Dumb way of doing arbiter - for comparison only

    always @*
        case (ptr)

        3'd0:
                   if (req [0]) d_gnt = 8'b00000001;
              else if (req [1]) d_gnt = 8'b00000010;
              else if (req [2]) d_gnt = 8'b00000100;
              else if (req [3]) d_gnt = 8'b00001000;
              else if (req [4]) d_gnt = 8'b00010000;
              else if (req [5]) d_gnt = 8'b00100000;
              else if (req [6]) d_gnt = 8'b01000000;
              else if (req [7]) d_gnt = 8'b10000000;
              else              d_gnt = 8'b00000000;

        3'd1:
                   if (req [1]) d_gnt = 8'b00000010;
              else if (req [2]) d_gnt = 8'b00000100;
              else if (req [3]) d_gnt = 8'b00001000;
              else if (req [4]) d_gnt = 8'b00010000;
              else if (req [5]) d_gnt = 8'b00100000;
              else if (req [6]) d_gnt = 8'b01000000;
              else if (req [7]) d_gnt = 8'b10000000;
              else if (req [0]) d_gnt = 8'b00000001;
              else              d_gnt = 8'b00000000;

        3'd2:
                   if (req [2]) d_gnt = 8'b00000100;
              else if (req [3]) d_gnt = 8'b00001000;
              else if (req [4]) d_gnt = 8'b00010000;
              else if (req [5]) d_gnt = 8'b00100000;
              else if (req [6]) d_gnt = 8'b01000000;
              else if (req [7]) d_gnt = 8'b10000000;
              else if (req [0]) d_gnt = 8'b00000001;
              else if (req [1]) d_gnt = 8'b00000010;
              else              d_gnt = 8'b00000000;

        3'd3:
                   if (req [3]) d_gnt = 8'b00001000;
              else if (req [4]) d_gnt = 8'b00010000;
              else if (req [5]) d_gnt = 8'b00100000;
              else if (req [6]) d_gnt = 8'b01000000;
              else if (req [7]) d_gnt = 8'b10000000;
              else if (req [0]) d_gnt = 8'b00000001;
              else if (req [1]) d_gnt = 8'b00000010;
              else if (req [2]) d_gnt = 8'b00000100;
              else              d_gnt = 8'b00000000;

        3'd4:
                   if (req [4]) d_gnt = 8'b00010000;
              else if (req [5]) d_gnt = 8'b00100000;
              else if (req [6]) d_gnt = 8'b01000000;
              else if (req [7]) d_gnt = 8'b10000000;
              else if (req [0]) d_gnt = 8'b00000001;
              else if (req [1]) d_gnt = 8'b00000010;
              else if (req [2]) d_gnt = 8'b00000100;
              else if (req [3]) d_gnt = 8'b00001000;
              else              d_gnt = 8'b00000000;

        3'd5:
                   if (req [5]) d_gnt = 8'b00100000;
              else if (req [6]) d_gnt = 8'b01000000;
              else if (req [7]) d_gnt = 8'b10000000;
              else if (req [0]) d_gnt = 8'b00000001;
              else if (req [1]) d_gnt = 8'b00000010;
              else if (req [2]) d_gnt = 8'b00000100;
              else if (req [3]) d_gnt = 8'b00001000;
              else if (req [4]) d_gnt = 8'b00010000;
              else              d_gnt = 8'b00000000;

        3'd6:
                   if (req [6]) d_gnt = 8'b01000000;
              else if (req [7]) d_gnt = 8'b10000000;
              else if (req [0]) d_gnt = 8'b00000001;
              else if (req [1]) d_gnt = 8'b00000010;
              else if (req [2]) d_gnt = 8'b00000100;
              else if (req [3]) d_gnt = 8'b00001000;
              else if (req [4]) d_gnt = 8'b00010000;
              else if (req [5]) d_gnt = 8'b00100000;
              else              d_gnt = 8'b00000000;

        3'd7:
                   if (req [7]) d_gnt = 8'b10000000;
              else if (req [0]) d_gnt = 8'b00000001;
              else if (req [1]) d_gnt = 8'b00000010;
              else if (req [2]) d_gnt = 8'b00000100;
              else if (req [3]) d_gnt = 8'b00001000;
              else if (req [4]) d_gnt = 8'b00010000;
              else if (req [5]) d_gnt = 8'b00100000;
              else if (req [6]) d_gnt = 8'b01000000;
              else              d_gnt = 8'b00000000;

        endcase

    always @ (posedge clk or posedge rst)
        if (rst)
            gnt <= 8'b0;
        else
            gnt <= d_gnt;

    always @ (posedge clk or posedge rst)
        if (rst)
            ptr <= 3'b0;
        else
            case (1'b1)  // synopsys parallel_case
            gnt [0]: ptr <= 2'd1;
            gnt [1]: ptr <= 2'd2;
            gnt [2]: ptr <= 2'd3;
            gnt [3]: ptr <= 2'd0;
            gnt [4]: ptr <= 2'd1;
            gnt [5]: ptr <= 2'd2;
            gnt [6]: ptr <= 2'd3;
            gnt [7]: ptr <= 2'd0;
            endcase

endmodule
