module fpu_64_divider #(
	parameter WIDTH=64
	)(
	input [WIDTH-1:0] A,
	input [WIDTH-1:0] B, 
	output [WIDTH-1:0] result, 
	output wire overflow, 
	output wire underflow
	);

	// A/B = A * 1/B
	wire [WIDTH-1:0] B_reciprocal;

	fpu_64_reciprocal reciprocal64(.in(B), .result(B_reciprocal));
	wire overflow_mult;
	wire underflow_mult;
	wire [10:0] exponent;

	fpu_64_multiplier mult64(.X(A), .Y(B_reciprocal), .res(result), .overflow_flag(overflow_mult), .underflow_flag(underflow_mult));

	assign exponent = result[62:52];
	assign overflow = (exponent == 11'b11111111111); // Infinity
	assign underflow = (exponent == 11'b00000000000 && result[51:0] == 0); // Zero

endmodule