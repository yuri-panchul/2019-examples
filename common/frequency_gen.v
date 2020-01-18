//----------------------------------------------------------------------------
//
//  Упражнение с генерацией звуков До-Ми-Соль и зуммера
//
//  Exercise with sound generator, C4-E4-G4 and bazzer
//
//----------------------------------------------------------------------------

module frequency_gen
#
(
    parameter clock_frequency          = 50000000,  // 50 MHz
              output_frequency_mul_100 = 26163      // Частота ноты До   первой октавы * 100
                                                    // C4 frequency * 100
)
(
    input      clock,
    input      reset_n,
    output reg out
);

    parameter [31:0] period_in_cycles
        = clock_frequency * 100 / output_frequency_mul_100;

    reg [15:0] counter;

    always @(posedge clock or negedge reset_n)
    begin
        if (! reset_n)
        begin
            counter <= 16'b0;
            out     <= 1'b0;
        end
        else
        begin
            if (counter == period_in_cycles / 2 - 1)
            begin
                out     <= ! out;
                counter <= 16'b0;
            end
            else
            begin
                counter <= counter + 16'b1;
            end
        end
    end

endmodule


module topf
(
    input         clock,
    input         reset_n,
    input  [ 3:0] key,
    input  [ 9:0] sw,
    output [ 9:0] led,
    output [ 6:0] hex0,
    output [ 6:0] hex1,
    output [ 6:0] hex2,
    output [ 6:0] hex3,
    output [ 6:0] hex4,
    output [ 6:0] hex5,
    inout  [35:0] gpio_0,
    inout  [35:0] gpio_1
);

    parameter clock_frequency      = 50000000;

    parameter frequency_c4_mul_100 = 26163,  // Частота ноты До первой октавы * 100
                                             // C4 frequency * 100
                                             
              frequency_e4_mul_100 = 32963,  // Частота ноты Ми первой октавы * 100
                                             // E4 frequency * 100
                                             
              frequency_g4_mul_100 = 39200;  // Частота ноты Соль первой октавы * 100
                                             // G4 frequency * 100
    
    wire button_c4 = ~ key [3];
    wire button_e4 = ~ key [2];
    wire button_g4 = ~ key [1];
    wire buzzer    = ~ key [0];

    wire note_c4, note_e4, note_g4;

    frequency_generator
    # (
        .clock_frequency          ( clock_frequency      ),
        .output_frequency_mul_100 ( frequency_c4_mul_100 )
    )
    (
        .clock   ( clock     ),
        .reset_n ( button_c4 ),
        .out     ( note_c4   )
    );

    frequency_generator
    # (
        .clock_frequency          ( clock_frequency      ),
        .output_frequency_mul_100 ( frequency_e4_mul_100 )
    )
    (
        .clock   ( clock     ),
        .reset_n ( button_e4 ),
        .out     ( note_e4   )
    );

    frequency_generator
    # (
        .clock_frequency          ( clock_frequency      ),
        .output_frequency_mul_100 ( frequency_g4_mul_100 )
    )
    (
        .clock   ( clock     ),
        .reset_n ( button_g4 ),
        .out     ( note_g4   )
    );

    assign gpio_1 [35] = note_c4 | note_e4 | note_g4;
    assign gpio_1 [ 1] = buzzer;
                 
endmodule
