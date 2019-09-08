module arbiter
(
    input            clk,
    input            rst,
    input      [3:0] req,
    output reg [3:0] gnt
);

    reg  [1:0] ptr;

    wire [7:0] shift_req_double = { req, req } >> ptr;
    wire [3:0] shift_req = shift_req_double [3:0];

    wire [3:0] higher_pri_reqs;

    assign     higher_pri_reqs [3:1] = higher_pri_reqs [2:0] | shift_req [2:0];
    assign     higher_pri_reqs [0]   = 0;

    wire [3:0] shift_gnt = shift_req & ~ higher_pri_reqs;

    wire [7:0] d_gnt_double = { shift_gnt, shift_gnt } << ptr;
    wire [3:0] d_gnt = d_gnt_double [7:4];

    always @ (posedge clk or posedge rst)
        if (rst)
            gnt <= 4'b0;
        else
            gnt <= d_gnt;  // Should we & ~ gnt ?

    always @ (posedge clk or posedge rst)
        if (rst)
            ptr <= 2'b0;
        else
            case (1'b1)  // synopsys parallel_case
            gnt [0]: ptr <= 2'd1;
            gnt [1]: ptr <= 2'd2;
            gnt [2]: ptr <= 2'd3;
            gnt [3]: ptr <= 2'd0;
            endcase

endmodule
