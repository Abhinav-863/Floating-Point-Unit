module fpu_32_divider_tb ();
    
    parameter WIDTH = 32;
    reg [WIDTH-1:0] A;
    reg [WIDTH-1:0] B;
    wire [WIDTH-1:0] result;
    wire overflow;
    wire underflow;

    fpu_32_divider #(.WIDTH(WIDTH)) uut (
        .A(A),
        .B(B),
        .result(result),
        .overflow(overflow),
        .underflow(underflow)
    );

    initial begin
        $monitor("A = %h | B = %h | Result = %h | Overflow = %b | Underflow = %b", A, B, result, overflow, underflow);
        // Test case 1: 4.0 / 2.0
        A = 32'h40800000; // 4.0
        B = 32'h40000000; // 2.0
        #10;

        // Test case 2: 1.0 / 0.5
        A = 32'h3F800000; // 1.0
        B = 32'h3F000000; // 0.5
        #10;

        // Test case 3: 2.0 / 4.0
        A = 32'h40000000; // 2.0
        B = 32'h40800000; // 4.0
        #10;

        // Test case 4: Division by zero (B=0)
        A = 32'h40000000; // 2.0
        B = 32'h00000000; // 0.0
        #10;

        // Test case 5: Zero divided by a number (A=0)
        A = 32'h00000000; // 0.0
        B = 32'h40000000; // 2.0
        #10;
        
        $finish();
    end
endmodule