module fpu_32 #(
	parameter WIDTH = 32
	)(
	input [WIDTH-1:0] A, 
	input [WIDTH-1:0] B,
	input clk,
	input rst,	
	input [2:0] OpCode,	
	output [WIDTH-1:0] Result,
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
	
	reg [31:0] Adder_A;
	reg [31:0] Adder_B;
	wire [31:0] Adder_Result;

	reg [31:0] Subtractor_A;
	reg [31:0] Subtractor_B;
	wire [31:0] Subtractor_Result;

	reg [31:0] Multiplier_A;
	reg [31:0] Multiplier_B;
	wire [31:0] Multiplier_Result;

	reg [31:0] Divider_A;
	reg [31:0] Divider_B;
	wire [31:0] Divider_Result;

	reg [31:0] Reciprocal_A;
	wire [31:0] Reciprocal_Result_A;

	reg [31:0] Reciprocal_B;
	wire [31:0] Reciprocal_Result_B;

	reg [31:0] Output;
	reg Overflow;
	reg Underflow;

	wire [31:0] posZero;
	assign posZero = 32'b00000000000000000000000000000000;

	wire [31:0] negZero;
	assign negZero = 32'b10000000000000000000000000000000;

	wire [31:0] posINF;
	assign posINF = 32'b01111111100000000000000000000000;

	wire [31:0] negINF;
	assign negINF = 32'b11111111100000000000000000000000;

	wire [31:0] NaN;
	assign NaN = 32'bX111111111XXXXXXXXXXXXXXXXXXXXXX;

	assign Result = Output;
	assign Overflow_out = Overflow;
	assign Underflow_out = Underflow;

	assign ADD = !OpCode[2] & !OpCode[1] & !OpCode[0];
	assign SUB = !OpCode[2] & !OpCode[1] & OpCode[0];
	assign MUL = !OpCode[2] & OpCode[1] & !OpCode[0];	
	assign DIV = !OpCode[2] & OpCode[1] & OpCode[0];
	assign RECIPROCAL_A = OpCode[2] & !OpCode[1] & !OpCode[0];
	assign RECIPROCAL_B = OpCode[2] & !OpCode[1] & OpCode[0];

	fpu_32_adder adder_32_fpu(.a(Adder_A), .b(Adder_B), .result(Adder_Result), .overflow(Overflow_Add), .underflow(Underflow_Add));
	fpu_32_adder subtractor_32_fpu(.a(Subtractor_A), .b(Subtractor_B), .result(Subtractor_Result), .overflow(Overflow_Sub), .underflow(Underflow_Sub));
	fpu_32_multiplier multiplier_32_fpu(.X(Multiplier_A), .Y(Multiplier_B), .res(Multiplier_Result), .overflow_flag(Overflow_Mul), .underflow_flag(Underflow_Mul));
	fpu_32_divider #(.WIDTH(WIDTH)) divider_32_fpu(.A(Divider_A), .B(Divider_B), .result(Divider_Result), .overflow(Overflow_Div), .underflow(Underflow_Div));
	fpu_32_reciprocal #(.WIDTH(WIDTH)) reciprocal_32_fpu_A(.in(Reciprocal_A), .result(Reciprocal_Result_A));
	fpu_32_reciprocal #(.WIDTH(WIDTH)) reciprocal_32_fpu_B(.in(Reciprocal_B), .result(Reciprocal_Result_B));

	always @ (posedge clk or negedge rst) begin
		if (!rst) begin
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
					Output = {A[31], posINF[30:0]};
				end 
				else if ((B == posINF || B == negINF) && (A != posINF || A != negINF)) begin
					Output = {B[31], posINF[30:0]};
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
					Output = {A[31], posINF[30:0]};
				end 
				else if ((B == posINF || B == negINF) && (A != posINF || A != negINF)) begin
					Output = {~B[31], posINF[30:0]};
				end 
				else begin
					Subtractor_A = A;
					Subtractor_B = {~B[31], B[30:0]};
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
					Output[31] = A[31] ^ B[31];
					Output[30:0] = posZero[30:0];
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
				else if (A == negZero) begin
					Output = negINF;
				end 
				else if (A == posINF) begin
					Output = posZero;
				end
				else if(A == negINF) begin
					Output = posZero;
				end
				else if (A == NaN) begin
					Output = NaN;
				end 
				else begin
					Reciprocal_A = A;
					Output = Reciprocal_Result_A;
				end
			end 
			else if (RECIPROCAL_B) begin
				if (B == posZero) begin
					Output = posINF;
				end
				else if (B == negZero) begin
					Output = negINF;
				end
				else if (B == posINF) begin
					Output = posZero;
				end  
				else if (B == negINF) begin
					Output = posZero;
				end 
				else if (B == NaN) begin
					Output = NaN;
				end 
				else begin
					Reciprocal_B = B;
					Output = Reciprocal_Result_B;
				end
			end 
			else begin
				Output = 32'b0;
			end
		end
	end

endmodule			
