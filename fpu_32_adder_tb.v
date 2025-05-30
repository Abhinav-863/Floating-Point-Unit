module fpu_32_adder_tb ();
    reg [31:0] X;
    reg [31:0] Y;
    wire [31:0] result;
    wire overflow_flag;
    wire underflow_flag;
    
    fpu_32_adder uut(
        .a(X),
        .b(Y),
        .result(result),
        .overflow(overflow_flag),
        .underflow(underflow_flag)
    );

    initial begin
        X = 32'b0111_1111_0000_0000_0000_0000_0000_0000;  // +0.0
        Y = 32'b0111_1111_0000_0000_0000_0000_0000_0000;  // +0.0
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, result, overflow_flag, underflow_flag);

        X = 32'b01000011010010001001010001111011;  // 200.58 in IEEE 754
        Y = 32'b01000010001011100110011001100110;  // 43.6 in IEEE 754
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, result, overflow_flag, underflow_flag);// Ouput is 244.18

        X = 32'b11000001100100011111011111001111;  // -18.246 in IEEE 754
        Y = 32'b01000001111110110110110010001011;  // 31.428 in IEEE 754
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, result, overflow_flag, underflow_flag); //Output is 13.181

        X = 32'b11000010111111000000000000000000;  // -126
        Y = 32'b01000010111111100000000000000000;  // 127 in IEEE 754
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, result, overflow_flag, underflow_flag); //Output is 1

        X = 32'b11111111100000000000000000000000;  //-Infintiy
        Y = 32'b11111111100000000000000000000000;  // -Infinity
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, result, overflow_flag, underflow_flag); //Underflow

        X = 32'b01111111100000000000000000000000;  // +Infinity
        Y = 32'b01000000001000000000000000000000;  // 2.5 in IEEE 754
        #10 $display("X = %h, Y = %h => Result = %h (OF: %b, UF: %b)", X, Y, result, overflow_flag, underflow_flag); //Overflow

        $finish;
    end
endmodule
