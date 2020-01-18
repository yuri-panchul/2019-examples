`include "config.vh"

module frequency_gen
#
(
    parameter output_frequency_mul_100 = 26163  // C4 frequency * 100
)
(
    input      clk,
    input      reset,
    input      enable,
    output reg out
);

    parameter [15:0] end_of_half_period_in_cycles
        = `CLK_FREQUENCY * 100 / output_frequency_mul_100 / 2 - 1;

    reg [15:0] counter;

    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            counter <= 16'b0;
            out     <= 1'b0;
        end
        else if (enable)
        begin
            if (counter == end_of_half_period_in_cycles)
            begin
                out     <= ~ out;
                counter <= 16'b0;
            end
            else
            begin
                counter <= counter + 16'b1;
            end
        end
    end

endmodule
