module fpu_64_tb();
    parameter WIDTH = 64;

    reg [WIDTH - 1: 0] A ;
    reg [WIDTH - 1: 0] B ;
    reg clk;
    reg rst;
    reg [2:0] OpCode;
    wire [WIDTH - 1: 0] Result;
    wire Overflow_out;
    wire Underflow_out;

    fpu_64 #(
        .WIDTH(WIDTH)
    ) uut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .OpCode(OpCode),
        .Result(Result),
        .Overflow_out(Overflow_out),
        .Underflow_out(Underflow_out)
    );

    always #10 clk = ~clk; 

    initial begin
        rst = 0; 
        clk = 0;
        OpCode = 3'b000;
        #200;
        A = 64'h0000000000000000; // 0.0
        B = 64'h0000000000000000; // 0.0 
        #200; 
        rst = 1;

        // ADDITION
        OpCode = 3'b000;
        #200;
        A = 64'h4000000000000000; // 2.0
        B = 64'h4008000000000000; // 3.0
        #200;
        $display("ADD: A=%h, B=%h => Result=%h",A, B, Result); // 0x4014000000000000 for 5.0
        #200;

        #200;
        A = 64'h7FF0000000000000; // +INF
        B = 64'h4008000000000000; // 3.0
        #200;
        $display("ADD: A=%h, B=%h => Result=%h ",A, B, Result); // 0x7FF0000000000000 for +INF
        #200;

        #200;
        A = 64'hFFF0000000000000; // -INF
        B = 64'h7FF0000000000000; // +INF
        #200;
        $display("ADD: A=%h, B=%h => Result=%h ",A, B, Result); // 0x7FF8000000000000 for NaN
        #200;

        // SUBTRACTION
        OpCode = 3'b001;
        #200;
        A = 64'h4014000000000000; // 5.0
        B = 64'h4008000000000000; // 3.0
        #200;
        $display("SUB: A=%h, B=%h => Result=%h", A, B, Result); // 0x4000000000000000 for 2.0
        #50;

        // INF - INF = NaN
        #200;
        A = 64'h7FF0000000000000; //Inf
        B = 64'h7FF0000000000000; //Inf
        #200;
        $display("SUB: A=%h, B=%h => Result=%h", A, B, Result); // 0x7FF8000000000000 for NaN
        #200;

        // MULTIPLICATION
        OpCode = 3'b010;
        #200;
        A = 64'h4000000000000000; //2.0
        B = 64'h4008000000000000; //3.0
        #200;
        $display("MUL: A=%h, B=%h => Result=%h ", A, B, Result); // 0x4018000000000000 for 6.0
        #200;

        #200;
        A = 64'h0000000000000000; //0.0
        B = 64'h7FF0000000000000; //Inf
        #200;
        $display("MUL: A=0.0, B=+INF => Result=%h", A, B, Result); // 0x7FF8000000000000 for NaN
        #200;

        // DIVISION
        OpCode = 3'b011;
        #200;
        A = 64'h4018000000000000; // 6.0
        B = 64'h4000000000000000; // 2.0
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", A, B, Result); // 0x4008000000000000 for 3.0
        #200;

        #200;
        A = 64'h4000000000000000; // 2.0
        B = 64'h0000000000000000; // 0.0
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", A, B, Result); // 0x7FF0000000000000 for +INF
        #200;

        #200;
        A = 64'h0000000000000000; //0.0
        B = 64'h0000000000000000; //0.0
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", A, B, Result); // 0x7FF8000000000000 for NaN
        #200;

        // RECIPROCAL A
        OpCode = 3'b100;
        #200;
        A = 64'h4000000000000000; //2.0
        #200;
        $display("RECIP_A: A=%h => Result=%h", A, Result); // 0x3FF0000000000000 for 0.5
        #200;

        #200;
        A = 64'h0000000000000000; //0.0
        #200;
        $display("RECIP_A: A=%h => Result=%h", A, Result); // 0x7FF0000000000000 for +INF
        #200;

        // RECIPROCAL B
        // Reciprocal of 4.0 = 0.25
        OpCode = 3'b101;
        #200;
        B = 64'h4010000000000000; // 4.0
        #200;
        $display("RECIP_B: B=%h => Result=%h ", B, Result); // 0x3FD0000000000000 for 0.25
        #200;

        // Reciprocal of INF = 0.0
        #200;
        B = 64'h7FF0000000000000;
        #200;
        $display("RECIP_B: B=%h => Result=%h", B, Result); // 0x0000000000000000 for 0.0
        #200;

        $finish();
    end

endmodule
