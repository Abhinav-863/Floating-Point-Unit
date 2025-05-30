module fpu_32_tb();
    parameter WIDTH = 32;

    reg [WIDTH - 1: 0] A ;
    reg [WIDTH - 1: 0] B ;
    reg clk;
    reg rst;
    reg [2:0] OpCode;
    wire [WIDTH - 1: 0] Result;
    wire Overflow_out;
    wire Underflow_out;

    fpu_32 #(
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
        A = 32'h00000000; // 0.0
        B = 32'h00000000; // 0.0 
        #200; 
        rst = 1;

        // ADDITION
        OpCode = 3'b000;
        #200;
        A = 32'h40000000; // 2.0
        B = 32'h40400000; // 3.0
        #200;
        $display("ADD: A=%h, B=%h => Result=%h",A, B, Result); // 0x40A00000 for 5.0
        #200;

        #200;
        A = 32'h7F800000; // +INF
        B = 32'h40400000; // 3.0
        #200;
        $display("ADD: A=%h, B=%h => Result=%h ",A, B, Result); //0x7F800000 for +INF
        #200;

        #200;
        A = 32'hFF800000; // -INF
        B = 32'h7F800000; // +INF
        #200;
        $display("ADD: A=%h, B=%h => Result=%h ",A, B, Result); //NaN
        #200;

        // SUBTRACTION
        OpCode = 3'b001;
        #200;
        A = 32'h40A00000; // 5.0
        B = 32'h40400000; // 3.0
        #200;
        $display("SUB: A=%h, B=%h => Result=%h", A, B, Result); //0x40000000 for 2.0
        #50;

        // INF - INF = NaN
        #200;
        A = 32'h7F800000; //Inf
        B = 32'h7F800000; //Inf
        #200;
        $display("SUB: A=%h, B=%h => Result=%h", A, B, Result); //NaN
        #200;

        // MULTIPLICATION
        OpCode = 3'b010;
        #200;
        A = 32'h40000000; //2.0
        B = 32'h40400000; //3.0
        #200;
        $display("MUL: A=%h, B=%h => Result=%h ", A, B, Result); //0x40C00000 for 6.0
        #200;

        #200;
        A = 32'h00000000; //0.0
        B = 32'h7F800000; //Inf
        #200;
        $display("MUL: A=0.0, B=+INF => Result=%h", A, B, Result); //NaN
        #200;

        // DIVISION
        OpCode = 3'b011;
        #200;
        A = 32'h40C00000; // 6.0
        B = 32'h40000000; // 2.0
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", A, B, Result); //0x40400000 for 3.0
        #200;

        #200;
        A = 32'h40000000; // 2.0
        B = 32'h00000000; // 0.0
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", A, B, Result); //0x7F800000 for +INF
        #200;

        #200;
        A = 32'h00000000; //0.0
        B = 32'h00000000; //0.0
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", A, B, Result); //NaN
        #200;

        // RECIPROCAL A
        OpCode = 3'b100;
        #200;
        A = 32'h40000000; //2.0
        #200;
        $display("RECIP_A: A=%h => Result=%h", A, Result); //0x3F000000 for 0.5
        #200;

        #200;
        A = 32'h00000000; //0.0
        #200;
        $display("RECIP_A: A=%h => Result=%h", A, Result); //0x7F800000 for +INF
        #200;

        // RECIPROCAL B
        // Reciprocal of 4.0 = 0.25
        OpCode = 3'b101;
        #200;
        B = 32'h40800000; // 4.0
        #200;
        $display("RECIP_B: B=%h => Result=%h ", B, Result); //0x3E800000 for 0.25
        #200;

        // Reciprocal of INF = 0.0
        #200;
        B = 32'h7F800000;
        #200;
        $display("RECIP_B: B=%h => Result=%h", B, Result); //0x00000000 for 0.0
        #200;

        $finish();
    end

endmodule
