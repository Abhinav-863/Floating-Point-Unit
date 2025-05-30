`timescale 1ns / 1ps

module fpu_64_reciprocal_tb();

    parameter WIDTH = 64;
    reg  [WIDTH-1:0] in;
    wire [WIDTH-1:0] result;


    // Correct port names
    fpu_64_reciprocal #(.WIDTH(WIDTH)) uut (
        .in(in),
        .result(result)
    );

    initial begin

        in = 64'h4000000000000000; // 2.0
        #10;
        $display("Input = %h | Reciprocal = %h", in, result);

        in = 64'h4010000000000000; // 0.25
        #10;
        $display("Input = %h | Reciprocal = %h", in, result);

        in = 64'h3FF0000000000000; // 1.0
        #10;
        $display("Input = %h | Reciprocal = %h", in, result);

        in = 64'h3FE0000000000000; // 0.5
        #10;
        $display("Input = %h | Reciprocal = %h", in, result);

        in = 64'h4010000000000000; // 4.0
        #10;
        $display("Input = %h | Reciprocal = %h", in, result);

        $finish;
    end

endmodule
/*
`timescale 1ns / 1ps

module fpu_64_reciprocal_tb();

    parameter WIDTH = 64;
    reg [WIDTH-1:0] in;
    wire [WIDTH-1:0] result;

    // Instantiate the DUT
    fpu_64_reciprocal #(.WIDTH(WIDTH)) uut (
        .in(in),
        .result(result)
    );

    // Task for printing double-precision float values
    task print_result;
        input [63:0] input_val;
        input [63:0] output_val;
        input [63:0] expected_val;
        begin
            $display("Input:    0x%h", input_val);
            $display("Result:   0x%h", output_val);
            $display("Expected: 0x%h", expected_val);
            $display("Match:    %s", (output_val === expected_val) ? "YES" : "NO");
            $display("-----------");
        end
    endtask

    initial begin
        $display("Starting fpu_64_reciprocal Testbench...\n");

        // Test Case 1: Reciprocal of 2.0
        in = 64'h4000000000000000; // 2.0
        #100;
        print_result(in, result, 64'h3FE0000000000000); // Expect 0.5

        // Test Case 2: Reciprocal of 4.0
        in = 64'h4010000000000000; // 4.0
        #100;
        print_result(in, result, 64'h3FD0000000000000); // Expect 0.25

        // Test Case 3: Reciprocal of 1.0
        in = 64'h3FF0000000000000; // 1.0
        #100;
        print_result(in, result, 64'h3FF0000000000000); // Expect 1.0

        // Test Case 4: Reciprocal of 0.5
        in = 64'h3FE0000000000000; // 0.5
        #100;
        print_result(in, result, 64'h4000000000000000); // Expect 2.0

        // Test Case 5: Reciprocal of 10.0
        in = 64'h4024000000000000; // 10.0
        #100;
        print_result(in, result, 64'h3FB999999999999A); // ~0.1


        $display("\nTestbench completed.");
        $finish;
    end
endmodule
*/