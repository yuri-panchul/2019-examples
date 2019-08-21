module arbiter
(
    input            clk,
    input            rst,
    input      [7:0] req,
    output reg [7:0] gnt
);

    reg  [ 2:0] ptr;

    wire [15:0] shift_req_double = { req, req } >> ptr;
    wire [ 7:0] shift_req = shift_req_double [7:0];

    wire [ 7:0] higher_pri_reqs;

    assign      higher_pri_reqs [7:1] = higher_pri_reqs [6:0] | shift_req [6:0];
    assign      higher_pri_reqs [0]   = 0;

    wire [ 7:0] shift_gnt = shift_req & ~ higher_pri_reqs;

    wire [15:0] d_gnt_double = { shift_gnt, shift_gnt } << ptr;
    wire [ 7:0] d_gnt = d_gnt_double [15:8];

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
