module arbiter
(
    input            clk,
    input            rst,
    input      [7:0] req,
    output reg [7:0] gnt
);

    reg [2:0] ptr;

    wire [15:0] shift_req_double = { req, req } >> ptr;
    wire [ 7:0] shift_req = shift_req_double [7:0];

    reg [7:0] d_gnt;

    // Priority arbiter using if

    always @*
    begin
        shift_gnt = 8'b0;

             if (shift_req [0]) shift_gnt [0] = 1;
        else if (shift_req [1]) shift_gnt [1] = 1;
        else if (shift_req [2]) shift_gnt [2] = 1;
        else if (shift_req [3]) shift_gnt [3] = 1;
        else if (shift_req [4]) shift_gnt [4] = 1;
        else if (shift_req [5]) shift_gnt [5] = 1;
        else if (shift_req [6]) shift_gnt [6] = 1;
        else if (shift_req [7]) shift_gnt [7] = 1;
    end

    always @*
        case (ptr)
        3'd0: d_gnt =   shift_gnt [7:0]                   ;
        3'd1: d_gnt = { shift_gnt [6:0], shift_gnt [7:7] };
        3'd2: d_gnt = { shift_gnt [5:0], shift_gnt [7:6] };
        3'd3: d_gnt = { shift_gnt [4:0], shift_gnt [7:5] };
        3'd4: d_gnt = { shift_gnt [3:0], shift_gnt [7:4] };
        3'd5: d_gnt = { shift_gnt [2:0], shift_gnt [7:3] };
        3'd6: d_gnt = { shift_gnt [1:0], shift_gnt [7:2] };
        3'd7: d_gnt = { shift_gnt [0:0], shift_gnt [7:1] };
        endcase

    always @ (posedge clk or posedge rst)
        if (rst)
            gnt <= 8'b0;
        else
            gnt <= d_gnt;  // Should we & ~ gnt ?

    always @ (posedge clk or posedge rst)
        if (rst)
            ptr <= 3'b0;
        else
            case (1'b1)  // synopsys parallel_case
            gnt [0]: ptr <= 3'd1;
            gnt [1]: ptr <= 3'd2;
            gnt [2]: ptr <= 3'd3;
            gnt [3]: ptr <= 3'd4;
            gnt [4]: ptr <= 3'd5;
            gnt [5]: ptr <= 3'd6;
            gnt [6]: ptr <= 3'd7;
            gnt [7]: ptr <= 3'd0;
            endcase

endmodule
