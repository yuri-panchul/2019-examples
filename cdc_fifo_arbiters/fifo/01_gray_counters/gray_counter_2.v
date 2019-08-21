module gray_counter_2
# (
    parameter N = 4
)
(
    input              clk,
    input              rst,
    input              inc,
    input              not_full_or_empty,
    output reg [N-2:0] bin,
    output reg [N-1:0] ptr
);

    wire [N-2:0] d_bin = bin + (inc | not_full_or_empty);

    always @ (posedge clk or posedge rst)
        if (reset) bin <= 0;
        else       bin <= d_bin;
            
    always @ (posedge clk or posedge rst)
        if (reset) ptr <= 0;
        else       ptr <= d_bin ^ (d_bin >> 1);
        
endmodule
