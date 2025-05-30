module fpu_64_reciprocal #(
	parameter WIDTH=64
	)(
		input [WIDTH-1:0] in, 
		output [WIDTH-1:0] result
	);
	
	//Newton Raphson
	wire [63:0] D;
	assign D = {1'b0, 11'd1022, in[51:0]};
	//wire overflow_underflow_flag;
	wire overflow_flag1;
	wire underflow_flag1;
	wire overflow_flag2;
	wire underflow_flag2;
	wire overflow_flag3;
	wire underflow_flag3;
	wire overflow_flag4;
	wire underflow_flag4;
	wire overflow_flag5;
	wire underflow_flag5;
	wire overflow_flag6;
	wire underflow_flag6;
	wire overflow_flag7;
	wire underflow_flag7;
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
	wire TempS;
	wire TempT;
	wire TempU;
	wire TempV;
	wire TempW;
	wire TempX;
	wire TempY;
	wire TempZ;

	wire [63:0] C1; //C1 = 48/17
	assign C1 = 64'b0100000000000110100101101001011010010110100101101001011010010111;
	wire [63:0] C2; //C2 = 32/17
	assign C2 = 64'b0011111111111110000111100001111000011110000111100001111000011110;
	wire [63:0] C3; //C3 = 2
	assign C3 = 64'b0100000000000000000000000000000000000000000000000000000000000000;

	wire [63:0] X0;
	wire [63:0] X1;
	wire [63:0] X2;
	wire [63:0] X3;
	wire [63:0] X4;
	wire [63:0] X5;
	wire [63:0] X6;

	wire [63:0] Temp0;
	wire [63:0] Temp1;
	wire [63:0] Temp2;
	wire [63:0] Temp3;
	wire [63:0] Temp4;
	wire [63:0] Temp5;
	wire [63:0] Temp6;
	wire [63:0] Temp7;
	wire [63:0] Temp8;
	wire [63:0] Temp9;
	wire [63:0] Temp10;
	wire [63:0] Temp11;
	wire [63:0] Temp12;
	
	//X0 = 48/17 - (32/17 * D)
	fpu_64_multiplier M0(.X(C2), .Y(D), .res(Temp0), .overflow_flag(TempA), .underflow_flag(TempB));
	fpu_64_adder A0(.a(C1), .b({~Temp0[63], Temp0[62:0]}), .result(X0), .overflow(overflow_flag1), .underflow(underflow_flag1));
	
	//X1 = X0 (2 - X0 * D)
	fpu_64_multiplier M11(.X(D), .Y(X0), .res(Temp1), .overflow_flag(TempC), .underflow_flag(TempD));
	fpu_64_adder A1(.a(C3), .b({~Temp1[63], Temp1[62:0]}), .result(Temp2), .overflow(overflow_flag2), .underflow(underflow_flag2));
	fpu_64_multiplier M12(.X(X0), .Y(Temp2), .res(X1), .overflow_flag(TempE), .underflow_flag(TempF));

	//X2 = X1 (2 - X1 * D)
	fpu_64_multiplier M21(.X(D), .Y(X1), .res(Temp3), .overflow_flag(TempG), .underflow_flag(TempH));
	fpu_64_adder A2(.a(C3), .b({~Temp3[63], Temp3[62:0]}), .result(Temp4), .overflow(overflow_flag3), .underflow(underflow_flag3));
	fpu_64_multiplier M22(.X(X1), .Y(Temp4), .res(X2), .overflow_flag(TempI), .underflow_flag(TempJ));
	
	//X3 = X2 (2 - X2 * D)
	fpu_64_multiplier M31(.X(D), .Y(X2), .res(Temp5), .overflow_flag(TempK), .underflow_flag(TempL));
	fpu_64_adder A3(.a(C3), .b({~Temp5[63], Temp5[62:0]}), .result(Temp6), .overflow(overflow_flag4), .underflow(underflow_flag4));
	fpu_64_multiplier M32(.X(X2), .Y(Temp6), .res(X3), .overflow_flag(TempM), .underflow_flag(TempN));
	
	//X4 = X3 (2 - X3 * D)
	fpu_64_multiplier M41(.X(D), .Y(X3), .res(Temp7), .overflow_flag(TempO), .underflow_flag(TempP));
	fpu_64_adder A4(.a(C3), .b({~Temp7[63], Temp7[62:0]}), .result(Temp8), .overflow(overflow_flag5), .underflow(underflow_flag5));
	fpu_64_multiplier M42(.X(X3), .Y(Temp8), .res(X4), .overflow_flag(TempQ), .underflow_flag(TempR));
	
	//X5 = X4 (2 - X4 * D)
	fpu_64_multiplier M51(.X(D), .Y(X4), .res(Temp9), .overflow_flag(TempS), .underflow_flag(TempT));
	fpu_64_adder A5(.a(C3), .b({~Temp9[63], Temp9[62:0]}), .result(Temp10), .overflow(overflow_flag6), .underflow(underflow_flag6));
	fpu_64_multiplier M52(.X(X4), .Y(Temp10), .res(X5), .overflow_flag(TempU), .underflow_flag(TempV));
	
	//X6 = X5 (2 - X5 * D)
	fpu_64_multiplier M61(.X(D), .Y(X5), .res(Temp11), .overflow_flag(TempW), .underflow_flag(TempX));
	fpu_64_adder A6(.a(C3), .b({~Temp11[63], Temp11[62:0]}), .result(Temp12), .overflow(overflow_flag7), .underflow(underflow_flag7));
	fpu_64_multiplier M62(.X(X5), .Y(Temp12), .res(X6), .overflow_flag(TempY), .underflow_flag(TempZ));
	
	assign result[63] = in[63];
	assign result[62:52] = X6[62:52] + 11'd1022 - in[62:52];
	assign result[51:0] = X6[51:0];

endmodule
