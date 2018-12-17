`timescale 1 ns / 1ps

module tb;

    reg CLK, D, Q, Q1, Q2, Q3;

    initial
    begin
        CLK = 0;

        forever
            # 50 CLK = ~ CLK;
    end

    always @ (posedge CLK)
        Q <= D;

    always @ (negedge CLK)
        Q1 <= D;

    always @ (CLK)
        Q2 <= D;

    always @*
        if (CLK)
            Q3 <= D;

    integer n;

    initial
    begin
        $dumpvars;

        D = 0;
    
        repeat (1000)
        begin
            n = $urandom_range (5, 60);
            # (n);
            D <= ! D;
        end

        $finish;
    end

endmodule
