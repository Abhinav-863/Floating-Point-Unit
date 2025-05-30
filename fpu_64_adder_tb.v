module fpu_64_adder_tb ();
    reg [63:0] X;
    reg [63:0] Y;
    wire [63:0] res;
    wire overflow_flag;
    wire underflow_flag;
    
    fpu_64_adder uut(
        .a(X),
        .b(Y),
        .result(res),
        .overflow(overflow_flag),
        .underflow(underflow_flag)
    );

    initial begin

        X = 64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;  // +0.0
        Y = 64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;  // +0.0
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, res, overflow_flag, underflow_flag); //0.0

        X = 64'h4_0_6_1_D_00000000000;  // 142.5 in IEEE 754
        Y = 64'h4_0_2_9_000000000000;  // 12.5 in IEEE 754
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, res, overflow_flag, underflow_flag);// Ouput is 155.0

        X = 64'b1100000000110010001111111010010000111111111001011100100100011101;  // -18.2486 in IEEE 754
        Y = 64'b0100000000111111011011011011001000101101000011100101011000000100;  // 31.4285 in IEEE 754
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, res, overflow_flag, underflow_flag); //Output is 13.1799

        X = 64'b0111111111111111111111111111111111111111111111111111111111111111;  // 1.7976931348623157 × 10^30
        Y = 64'b0100000000000000000000000000000000000000000000000000000000000000;  // 2.0 in IEEE 754
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, res, overflow_flag, underflow_flag); //Output is +Infinity

        X = 64'b1000000000010000000000000000000000000000000000000000000000000000;  // Smallest normalized double 2.2250738585072014E-308
        Y = 64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;  // 0.0000000000000000001
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, res, overflow_flag, underflow_flag); //Underflow

        X = 64'b0111111111110000000000000000000000000000000000000000000000000000;  // +Infinity
        Y = 64'b0100000000000100000000000000000000000000000000000000000000000000;  // 2.5 in IEEE 754
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, res, overflow_flag, underflow_flag); //Overflow

        $finish;
    end
endmodule
