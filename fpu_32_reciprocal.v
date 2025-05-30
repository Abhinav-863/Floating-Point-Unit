module fpu_32_reciprocal #(
	parameter WIDTH=32
	)(
		input [WIDTH-1:0] in, 
		output [WIDTH-1:0] result
	);
	
	//Newton Raphson
	wire [31:0] D;
	assign D = {1'b0, 8'd126, in[22:0]};
	wire overflow_flag1;
	wire overflow_flag2;
	wire overflow_flag3;
	wire overflow_flag4;
	wire overflow_flag5;
	wire underflow_flag1;
	wire underflow_flag2;
	wire underflow_flag3;
	wire underflow_flag4;
	wire underflow_flag5;
	wire TempA;
	wire TempB;
	wire TempC;
	wire TempD;
	wire TempE;
	wire TempF;
	wire TempG;
	wire TempH;
	wire TempI;
	wire TempJ;
	wire TempK;
	wire TempL;
	wire TempM;
	wire TempN;
	wire TempO;
	wire TempP;
	wire TempQ;
	wire TempR;

	wire [31:0] C1; //C1 = 48/17
	assign C1 = 32'b01000000001101001011010010110101;
	wire [31:0] C2; //C2 = 32/17
	assign C2 = 32'b00111111111100001111000011110001;
	wire [31:0] C3; //C3 = 2
	assign C3 = 32'b01000000000000000000000000000000;

	wire [31:0] X0;
	wire [31:0] X1;
	wire [31:0] X2;
	wire [31:0] X3;
	wire [31:0] X4;

	wire [31:0] Temp0;
	wire [31:0] Temp1;
	wire [31:0] Temp2;
	wire [31:0] Temp3;
	wire [31:0] Temp4;
	wire [31:0] Temp5;
	wire [31:0] Temp6;
	wire [31:0] Temp7;
	wire [31:0] Temp8;

	//X0 = 48/17 - (32/17 * D)
	fpu_32_multiplier M0(.X(C2), .Y(D), .res(Temp0), .overflow_flag(TempA), .underflow_flag(TempB));
	fpu_32_adder A0(.a(C1), .b({~Temp0[31], Temp0[30:0]}), .result(X0), .overflow(overflow_flag1), .underflow(underflow_flag1));

	//X1 = X0 (2 - X0 * D)
	fpu_32_multiplier M11(.X(D), .Y(X0), .res(Temp1), .overflow_flag(TempC), .underflow_flag(TempD));
	fpu_32_adder A1(.a(C3), .b({~Temp1[31], Temp1[30:0]}), .result(Temp2), .overflow(overflow_flag2), .underflow(underflow_flag2));
	fpu_32_multiplier M12(.X(X0), .Y(Temp2), .res(X1), .overflow_flag(TempE), .underflow_flag(TempF));

	//X2 = X1 (2 - X1 * D)
	fpu_32_multiplier M21(.X(D), .Y(X1), .res(Temp3), .overflow_flag(TempG), .underflow_flag(TempH));
	fpu_32_adder A2(.a(C3), .b({~Temp3[31], Temp3[30:0]}), .result(Temp4), .overflow(overflow_flag3), .underflow(underflow_flag3));
	fpu_32_multiplier M22(.X(X1), .Y(Temp4), .res(X2), .overflow_flag(TempI), .underflow_flag(TempJ));

	//X3 = X2 (2 - X2 * D)
	fpu_32_multiplier M31(.X(D), .Y(X2), .res(Temp5), .overflow_flag(TempK), .underflow_flag(TempL));
	fpu_32_adder A3(.a(C3), .b({~Temp5[31], Temp5[30:0]}), .result(Temp6), .overflow(overflow_flag4), .underflow(underflow_flag4));
	fpu_32_multiplier M32(.X(X2), .Y(Temp6), .res(X3), .overflow_flag(TempM), .underflow_flag(TempN));

	//X4 = X3 (2 - X3 * D)
	fpu_32_multiplier M41(.X(D), .Y(X3), .res(Temp7), .overflow_flag(TempO), .underflow_flag(TempP));
	fpu_32_adder A4(.a(C3), .b({~Temp7[31], Temp7[30:0]}), .result(Temp8), .overflow(overflow_flag5), .underflow(underflow_flag5));
	fpu_32_multiplier M42(.X(X3), .Y(Temp8), .res(X4), .overflow_flag(TempQ), .underflow_flag(TempR));

	assign result[31] = in[31];
	assign result[30:23] = X4[30:23] + 8'd126 - in[30:23];
	assign result[22:0] = X4[22:0] - 1'b1;

endmodule
