module gray_counter_1
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

    function [N-1:0] bin_to_gray (input [N-1:0] bin);
    begin
        bin_to_gray = (bin >> 1) ^ bin;
    end
    endfunction

    function [N-1:0] gray_to_bin (input [N-1:0] gray);
        integer i;
    begin
        for (i = 0; i < N; i = i + 1)
            gray_to_bin [i] = ^ (gray >> i);
    end
    endfunction

    wire [N-1:0] d_ptr = gray_to_bin (ptr) + (inc & not_full_or_empty);
    
    wire [N-1:0] d_bin
        = { d_ptr [N-1], d_ptr [N-2] ^ d_ptr [N-1], d_ptr [N-3:0] };

    always @ (posedge clk or posedge rst)
        if (reset) bin <= 0;
        else       bin <= d_bin;
            
    always @ (posedge clk or posedge rst)
        if (reset) ptr <= 0;
        else       ptr <= d_ptr;
        
endmodule
