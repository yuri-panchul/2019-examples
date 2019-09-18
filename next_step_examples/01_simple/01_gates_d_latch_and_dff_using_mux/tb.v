module tb;

    reg        a, b, c;
    wire [9:0] o, e;

    mux_2_to_1           i_mux      ( a, b, c, o [0] );
    and_gate_using_mux   i_and      ( a, b,    o [1] );
    or_gate_using_mux    i_or       ( a, b,    o [2] );
    not_gate_using_mux   i_not      ( a,       o [3] );
    xor_gate_using_mux   i_xor      ( a, b,    o [4] );
    nand_gate_using_mux  i_nand     ( a, b,    o [5] );
    nor_gate_using_mux   i_nor      ( a, b,    o [6] );
    xnor_gate_using_mux  i_xnor     ( a, b,    o [7] );
    d_latch_using_mux    i_d_latch  ( a, b,    o [8] );
    dff_using_mux        i_dff      ( a, b,    o [9] );

    reg l, f;

    always @ (a or b)
        if (a)
           l = b;

    always @ (posedge a)
        f <= b;

    assign e [0] = c ? b : a;
    assign e [1] =   a  & b;
    assign e [2] =   a  | b;
    assign e [3] = ~ a;
    assign e [4] =   a  ^ b;
    assign e [5] =   a ~& b;
    assign e [6] =   a ~| b;
    assign e [7] =   a ~^ b;
    assign e [8] =   l;
    assign e [9] =   f;

    wire [9:0] oxe = o ^ e;

    initial
    begin
        $dumpvars;

        repeat (100)
        begin
            a = $urandom;
            # 10
            b = $urandom;
            c = $urandom;
            # 10

            if (o !== e)
                $display ("%d a=%b b=%b c=%b o=%b e=%b",
                    $time, a, b, c, o, e);
        end

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
