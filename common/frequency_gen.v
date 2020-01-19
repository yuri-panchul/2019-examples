`include "config.vh"

module frequency_gen
#
(
    parameter output_frequency_mul_100 = 26163  // C4 frequency * 100
)
(
    input      clk,
    input      en,
    output reg out
);

    parameter [15:0] end_of_half_period_in_cycles
        = `CLK_FREQUENCY * 100 / output_frequency_mul_100 / 2 - 1;

    reg [15:0] cnt;

    always @(posedge clk)
    begin
        if (! en)
        begin
            cnt <= 16'b0;
            out <= 1'b0;
        end
        else
        begin
            if (cnt == end_of_half_period_in_cycles)
            begin
                out <= ~ out;
                cnt <= 16'b0;
            end
            else
            begin
                cnt <= cnt + 16'b1;
            end
        end
    end

endmodule
