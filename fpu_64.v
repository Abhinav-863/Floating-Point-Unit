module fpu_64 #(
	parameter WIDTH=64
	)(
	input [WIDTH-1:0] A, 
	input [WIDTH-1:0] B,
	input clk,
	input rst,	
	input [2:0] OpCode,	
	output [WIDTH-1:0] Result,
	//output Ready,
	output Overflow_out,
	output Underflow_out
	);
	
	wire Overflow_Add;
	wire Underflow_Add;
	wire Overflow_Sub;
	wire Underflow_Sub;
	wire Overflow_Mul;
	wire Underflow_Mul;
	wire Overflow_Div;
	wire Underflow_Div;

	reg [63:0] Adder_A;
	reg [63:0] Adder_B;
	wire [63:0] Adder_Result;

	reg [63:0] Subtractor_A;
	reg [63:0] Subtractor_B;
	wire [63:0] Subtractor_Result;

	reg [63:0] Multiplier_A;
	reg [63:0] Multiplier_B;
	wire [63:0] Multiplier_Result;

	reg [63:0] Divider_A;
	reg [63:0] Divider_B;
	wire [63:0] Divider_Result;

	reg [63:0] Reciprocal_A;
	wire [63:0] Reciprocal_Result_A;

	reg [63:0] Reciprocal_B;
	wire [63:0] Reciprocal_Result_B;

	reg [63:0] Output;
	reg Overflow;
	reg Underflow;

	wire [63:0] posZero;
	assign posZero = 64'b0000000000000000000000000000000000000000000000000000000000000000;

	wire [63:0] negZero;
	assign negZero = 64'b1000000000000000000000000000000000000000000000000000000000000000;

	wire [63:0] posINF;
	assign posINF = 64'b0111111111110000000000000000000000000000000000000000000000000000;

	wire [63:0] negINF;
	assign negINF = 64'b1111111111110000000000000000000000000000000000000000000000000000;

	wire [63:0] NaN;
	assign NaN = 64'bX111111111111XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

	assign Result = Output;
	assign Overflow_out = Overflow;
	assign Underflow_out = Underflow;

	assign ADD = !OpCode[2] & !OpCode[1] & !OpCode[0];
	assign SUB = !OpCode[2] & !OpCode[1] & OpCode[0];
	assign MUL = !OpCode[2] & OpCode[1] & !OpCode[0];	
	assign DIV = !OpCode[2] & OpCode[1] & OpCode[0];
	assign RECIPROCAL_A = OpCode[2] & !OpCode[1] & !OpCode[0];
	assign RECIPROCAL_B = OpCode[2] & !OpCode[1] & OpCode[0];

	fpu_64_adder Adder_FPU_64(.a(Adder_A), .b(Adder_B), .result(Adder_Result), .overflow(Overflow_Add), .underflow(Underflow_Add));
	fpu_64_adder Subtractor_FPU_64(.a(Subtractor_A), .b(Subtractor_B), .result(Subtractor_Result), .overflow(Overflow_Sub), .underflow(Underflow_Sub));
	fpu_64_multiplier Multiplier_FPU_64(.X(Multiplier_A), .Y(Multiplier_B), .res(Multiplier_Result), .overflow_flag(Overflow_Mul), .underflow_flag(Underflow_Mul));
	fpu_64_divider#(.WIDTH(WIDTH)) Divider_FPU_64(.A(Divider_A), .B(Divider_B), .result(Divider_Result), .overflow(Overflow_Div), .underflow(Underflow_Div));
	fpu_64_reciprocal #(.WIDTH(WIDTH)) reciprocal_64_fpu_A(.in(Reciprocal_A), .result(Reciprocal_Result_A));
	fpu_64_reciprocal #(.WIDTH(WIDTH)) reciprocal_64_fpu_B(.in(Reciprocal_B), .result(Reciprocal_Result_B));

	always @ (posedge clk or negedge rst) begin
		if(!rst) begin
			Output = 32'b0;
			Overflow = 1'b0;
			Underflow = 1'b0;
		end
		else begin
			if (A == NaN || B == NaN) begin
				Output = NaN;
			end 
			else if (ADD) begin
				if ((A == posINF || A == negINF) && (B == posINF || B == negINF)) begin
					Output = NaN;
				end 
				else if ((A == posINF || A == negINF) && (B != posINF || B != negINF)) begin
					Output = {A[63], posINF[62:0]};
				end 
				else if ((B == posINF || B == negINF) && (A != posINF || A != negINF)) begin
					Output = {B[63], posINF[62:0]};
				end 
				else begin
					Adder_A = A;
					Adder_B = B;
					Output = Adder_Result;
					Overflow = Overflow_Add;
					Underflow = Underflow_Add;
				end
			end 
			else if (SUB) begin
				if ((A == posINF || A == negINF) && (B == posINF || B == negINF)) begin
					Output = NaN;
				end 
				else if ((A == posINF || A == negINF) && (B != posINF || B != negINF)) begin
					Output = {A[63], posINF[62:0]};
				end 
				else if ((B == posINF || B == negINF) && (A != posINF || A != negINF)) begin
					Output = {~B[63], posINF[62:0]};
				end 
				else begin
					Subtractor_A = A;
					Subtractor_B = {~B[63], B[62:0]};
					Output = Subtractor_Result;
					Overflow = Overflow_Sub;
					Underflow = Underflow_Sub;
				end
			end 
			else if (MUL) begin
				if ((A == posZero || A == negZero) && (B == posINF || B == negINF)) begin
					Output = NaN;
				end 
				else if ((A == posINF || A == negINF) && (B == posZero || B == negZero)) begin
					Output = NaN;
				end 
				else if (A == posZero || A == negZero || B == posZero || B == negZero) begin
					Output[63] = A[63] ^ B[63];
					Output[62:0] = posZero[62:0];
				end 
				else if ((A != posZero || A != negZero) && B == posINF) begin
					Output = posINF;
				end 
				else if ((A != posZero || A != negZero) && B == negINF) begin
					Output = negINF;
				end 
				else if ((B != posZero || B != negZero) && A == posINF) begin
					Output = posINF;
				end 
				else if ((B != posZero || B != negZero) && A == negINF) begin
					Output = negINF;
				end 
				else begin
					Multiplier_A = A;
					Multiplier_B = B;
					Output = Multiplier_Result;
					Overflow = Overflow_Mul;
					Underflow = Underflow_Mul;
				end
			end 
			else if (DIV) begin
				if ((A != posZero && A != negZero) && B == posZero) begin
					Output = posINF;
				end 
				else if ((A != posZero && A != negZero) && B == negZero) begin
					Output = negINF;
				end 
				else if ((A == posZero || A == negZero) && (B == posZero || B == negZero)) begin
					Output = NaN;
				end 
				else if ((A == posINF || A == negINF) && (B == posINF || B == negINF)) begin
					Output = NaN;
				end 
				else if ((A != posINF || A != negINF) && B == posINF) begin
					Output = posINF;
				end 
				else if ((A != posINF || A != negINF) && B == negINF) begin
					Output = negINF;
				end 
				else begin
					Divider_A = A;
					Divider_B = B;
					Output = Divider_Result;
					Overflow = Overflow_Div;
					Underflow = Underflow_Div;
				end
			end
			else if (RECIPROCAL_A) begin
				if (A == posZero) begin
					Output = posINF;
				end
				else if(A == negZero) begin
					Output = negINF;
				end
				else if (A == posINF) begin
					Output = posZero;
				end
				else if (A == negINF) begin
					Output = negZero;
				end 
				else begin
					Reciprocal_A = A;
					Output = Reciprocal_Result_A;
				end
			end 
			else if (RECIPROCAL_B) begin
				if (B == posZero || B == negZero) begin
					Output = posINF;
				end 
				else if (B == posINF || B == negINF) begin
					Output = posZero;
				end 
				else begin
					Reciprocal_B = B;
					Output = Reciprocal_Result_B;
				end
			end
			else begin
				Output = 64'b0;
			end
		end
	end

endmodule			