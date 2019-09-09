module gray_counter_2
# (
    parameter N = 4
)
(
    input              clk,
    input              rst,
    input              inc,
    input              not_full_or_empty,
    output     [N-2:0] bin,
    output reg [N-1:0] ptr
);

    reg  [N-1:0] bin_1;
    wire [N-1:0] d_bin_1 = bin_1 + (inc & not_full_or_empty);
    
    assign bin = bin_1 [N-2:0];

    always @ (posedge clk or posedge rst)
        if (rst) bin_1 <= 0;
        else     bin_1 <= d_bin_1;
            
    always @ (posedge clk or posedge rst)
        if (rst) ptr <= 0;
        else     ptr <= d_bin_1 ^ (d_bin_1 >> 1);
        
endmodule
