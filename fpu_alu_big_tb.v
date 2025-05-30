module fpu_alu_big_tb ();
    parameter WIDTH = 64;
    reg op;
    reg [WIDTH-1:0] a;
    reg a_sign;
    reg [WIDTH-1:0] b;
    reg b_sign;
    wire [WIDTH:0] result;
    wire result_sign;

    fpu_alu_big #(.WIDTH(WIDTH)) uut (
        .op(op),
        .a(a),
        .a_sign(a_sign),
        .b(b),
        .b_sign(b_sign),
        .result(result),
        .result_sign(result_sign)
    );

    initial begin
        // Test case 1: Add two positive numbers
        op = 1'b1;
        a = 64'd5;
        a_sign = 1'b0;
        b = 64'd10;
        b_sign = 1'b0;
        #10; 

        $display("op = %d, a = %d, a_sign = %d , b = %d, b_sign = %d, result = %d, result_sign = %d", op, a, a_sign, b, b_sign, result, result_sign);


        // Test case 2: Subtract two positive numbers
        op = 1'b0;
        a = 64'd5;
        a_sign = 1'b0;
        b = 64'd3;
        b_sign = 1'b0;
        #10; 

        $display("op = %d, a = %d, a_sign = %d , b = %d, b_sign = %d, result = %d, result_sign = %d", op, a, a_sign, b, b_sign, result, result_sign);

        // Test case 3: Add two negative numbers
        op = 1'b1;
        a = 64'd5;
        a_sign = 1'b1;
        b = 64'd3;
        b_sign = 1'b1;
        #10; 

        $display("op = %d, a = %d, a_sign = %d , b = %d, b_sign = %d, result = %d, result_sign = %d", op, a, a_sign, b, b_sign, result, result_sign);

        // Test case 4: Subtract two negative numbers
        op = 1'b0;
        a = 64'd5;
        a_sign = 1'b1;
        b = 64'd10;
        b_sign = 1'b1;
        #10; 

        $display("op = %d, a = %d, a_sign = %d , b = %d, b_sign = %d, result = %d, result_sign = %d", op, a, a_sign, b, b_sign, result, result_sign);
        $finish;
    end
endmodule