module fpu_comparator #(
    parameter size = 32
    )(
    input [size-1:0] a,b,
    output [size-1:0] difference,
    output sign
    );

    assign difference = (a >= b) ? a - b : b - a;
    assign sign = (a >= b) ? 1'b0 : 1'b1;
endmodule