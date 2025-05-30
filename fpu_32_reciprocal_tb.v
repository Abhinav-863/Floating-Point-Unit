
`timescale 1ns / 1ps

module fpu_32_reciprocal_tb();

    parameter WIDTH = 32;
    reg  [WIDTH-1:0] in;
    wire [WIDTH-1:0] result;


    // Correct port names
    fpu_32_reciprocal #(.WIDTH(WIDTH)) uut (
        .in(in),
        .result(result)
    );

    initial begin
        $display("Testing 32-bit Floating-Point Reciprocal");

        in = 32'h40000000; // 2.0
        #10;
        $display("Input = %h | Reciprocal = %h", in, result);

        in = 32'h3E800000; // 0.25
        #10;
        $display("Input = %h | Reciprocal = %h", in, result);

        in = 32'h3F800000; // 1.0
        #10;
        $display("Input = %h | Reciprocal = %h", in, result);

        in = 32'h3F000000; // 0.5
        #10;
        $display("Input = %h | Reciprocal = %h", in, result);

        in = 32'h40800000; // 4.0
        #10;
        $display("Input = %h | Reciprocal = %h", in, result);

        $finish;
    end

endmodule

/*
`timescale 1ns / 1ps

module fpu_32_reciprocal_tb();

    parameter WIDTH = 32;
    reg [WIDTH-1:0] in;
    wire [WIDTH-1:0] result;

    // Instantiate the DUT
    fpu_32_reciprocal #(.WIDTH(WIDTH))uut (
        .in(in),
        .result(result)
    );

    // Task for printing float values
    task print_result;
        input [31:0] input_val;
        input [31:0] output_val;
        input [31:0] expected_val;
        begin
            $display("Input:    0x%h", input_val);
            $display("Result:   0x%h", output_val);
            $display("Expected: 0x%h", expected_val);
            $display("Match:    %s", (output_val === expected_val) ? "YES" : "NO");
            $display("-----------");
        end
    endtask

    initial begin
        $display("Starting fpu_32_reciprocal Testbench...\n");

        // Test Case 1: Reciprocal of 2.0
        in = 32'h40000000; // 2.0
        #100;
        print_result(in, result, 32'h3F000000); // Expect 0.5

        // Test Case 2: Reciprocal of 4.0
        in = 32'h40800000; // 4.0
        #100;
        print_result(in, result, 32'h3E800000); // Expect 0.25

        // Test Case 3: Reciprocal of 1.0
        in = 32'h3F800000; // 1.0
        #100;
        print_result(in, result, 32'h3F800000); // Expect 1.0

        // Test Case 4: Reciprocal of 0.5
        in = 32'h3F000000; // 0.5
        #100;
        print_result(in, result, 32'h40000000); // Expect 2.0

        // Test Case 5: Reciprocal of 10.0
        in = 32'h41200000; // 10.0
        #100;
        print_result(in, result, 32'h3DCCCCCD); // ~0.1

        $display("\nTestbench completed.");
        $finish;
    end
endmodule
*/
