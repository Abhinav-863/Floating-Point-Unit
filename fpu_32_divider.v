module fpu_32_divider #(
	parameter WIDTH=32
	)(
	input [WIDTH-1:0] A,
	input [WIDTH-1:0] B, 
	output [WIDTH-1:0] result,
	output overflow,
	output underflow
	);

	wire [WIDTH-1:0] B_reciprocal;

	fpu_32_reciprocal #(.WIDTH(WIDTH )) reciprocal (.in(B), .result(B_reciprocal));

	wire overflow_mult;
	wire underflow_mult;
	wire [7:0] exponent;

	fpu_32_multiplier Mult(.X(A), .Y(B_reciprocal), .res(result), .overflow_flag(overflow_mult), .underflow_flag(underflow_mult));

	assign exponent = result[30:23];
	assign overflow = (exponent == 8'b11111111); // Infinity
	assign underflow = (exponent == 8'b00000000 && result[22:0] == 0); // Zero

endmodule