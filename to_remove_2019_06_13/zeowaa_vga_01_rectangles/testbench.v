`include "config.vh"

module testbench;

    reg         clk;
    reg  [ 3:0] key;
    reg  [ 7:0] sw;
    wire [11:0] led;

    wire [ 7:0] abcdefgh;
    wire [ 7:0] digit;

    wire        buzzer;

    wire        vsync;
    wire        hsync;
    wire [ 2:0] rgb;

    top i_top
    (
        .clk      ( clk      ),
        .key      ( key      ),
        .sw       ( sw       ),
        .led      ( led      ),

        .abcdefgh ( abcdefgh ),
        .digit    ( digit    ),

        .buzzer   ( buzzer   ),

        .vsync    ( vsync    ),
        .hsync    ( hsync    ),
        .rgb      ( rgb      )
    );


    initial
    begin
        clk = 0;

        forever
            # 10 clk = ! clk;
    end

    reg rst;
    
    always @*
        key [3] = ! rst;

    initial
    begin
        repeat (10) @ (posedge clk);
        rst <= 1;
        repeat (10) @ (posedge clk);
        rst <= 0;
    end

    initial
    begin
        #0
        $dumpvars;

        @ (negedge rst);

        repeat (1000)
        begin
            @ (posedge clk);

            key <= $random;
            sw  <= $random;
        end

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
