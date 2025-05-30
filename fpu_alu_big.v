module fpu_alu_big #(
    parameter WIDTH=64
    )(
    input op, // 0 for add, 1 for subtract
    input [WIDTH-1:0] a,
    input a_sign, // 0 for positive, 1 for negative
    input [WIDTH-1:0] b,
    input b_sign, // 0 for positive, 1 for negative
    output [WIDTH:0] result,
    output result_sign
    );

    // convert to signed
    wire [2*WIDTH:0] temp_a;
    wire [2*WIDTH:0] temp_b;
    // concat zeros to the left of the number
    assign temp_a = {WIDTH{1'b0}} + a;
    assign temp_b = {WIDTH{1'b0}} + b;

    wire signed [2*WIDTH:0] a_signed;
    wire signed [2*WIDTH:0] b_signed;
    assign a_signed = a_sign ? -a : a;
    assign b_signed = b_sign ? -b : b;

    // perform the operation
    wire signed [2*WIDTH:0] inter_result;
    assign inter_result = op ? a_signed - b_signed : a_signed + b_signed;

    // convert back to unsigned
    assign result = inter_result < 0 ? -inter_result : inter_result;
    assign result_sign = inter_result[2*WIDTH];

endmodule
