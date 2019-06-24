module game_strobe # ( parameter width = 32 )
(
    input      clk,
    input      reset,
    output reg strobe
);

    reg [width - 1:0] counter;

    always @(posedge clk or negedge reset)
        if (reset)
        begin
            counter <= { width, 1'b0 };
            strobe  <= 1'b0;
        end
        begin
            counter <= counter + 1'b1;
            strobe  <= & counter;
        end

endmodule
