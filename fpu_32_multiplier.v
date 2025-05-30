`define  Exponent_X X[30:23]
`define  Exponent_Y Y[30:23]
`define  Sign_X X[31]
`define  Sign_Y Y[31]

module fpu_32_multiplier (
    input [31:0] X,
    input [31:0] Y,
    output [31:0] res,
    output overflow_flag,
    output underflow_flag
);

    wire sign;
    wire [23:0] Mantissa_X, Mantissa_Y;
    wire [22:0] Mantissa;
    wire [47:0] Temp_Mantissa;
    wire [8:0] Temp_Exponent, Exponent;
    wire is_zero_input;

    assign sign = `Sign_X ^ `Sign_Y;

    assign Mantissa_X = (|`Exponent_X) ? {1'b1, X[22:0]} : {1'b0, X[22:0]};
    assign Mantissa_Y = (|`Exponent_Y) ? {1'b1, Y[22:0]} : {1'b0, Y[22:0]};

    assign Temp_Mantissa = Mantissa_X * Mantissa_Y;

    assign Mantissa = Temp_Mantissa[47] ? Temp_Mantissa[46:24] : Temp_Mantissa[45:23];

    assign Temp_Exponent = `Exponent_X + `Exponent_Y - 8'd127;
    assign Exponent = Temp_Mantissa[47] ? (Temp_Exponent + 1) : Temp_Exponent;

    assign is_zero_input = (X[30:0] == 31'd0) || (Y[30:0] == 31'd0);

    assign res = is_zero_input ? 32'd0 : overflow_flag ? {sign, 8'b11111111, 23'd0} : underflow_flag ? {sign, 31'd0} : {sign, Exponent[7:0], Mantissa};

    assign overflow_flag  = is_zero_input ? 1'b0 : ((Exponent[8] & ~Exponent[7]) ? 1'b1 : 1'b0);
    assign underflow_flag = is_zero_input ? 1'b0 : ((Exponent[8] &  Exponent[7]) ? 1'b1 : 1'b0);

endmodule

/*
`define  Exponent_X X[30:23]
`define  Exponent_Y Y[30:23]
`define  Sign_X X[31]
`define  Sign_Y Y[31]

module fpu_32_multiplier(
    input [31:0] X,
    input [31:0] Y,
    output [31:0] res,
    output overflow_flag,
    output underflow_flag
);
    wire sign, zero;
    wire [23:0] Mantissa_X, Mantissa_Y;
    wire [22:0] Mantissa;
    wire [47:0] Temp_Mantissa;
    wire [8:0] Exponent, Temp_Exponent;

	assign sign = `Sign_X ^ `Sign_Y;
    assign Mantissa_X = (|`Exponent_X) ? {1'b1, X[22:0]} : {1'b0, X[22:0]};
    assign Mantissa_Y = (|`Exponent_Y) ? {1'b1, Y[22:0]} : {1'b0, Y[22:0]};
    assign Temp_Mantissa = Mantissa_X * Mantissa_Y;
    assign Mantissa = Temp_Mantissa[47] ? Temp_Mantissa[46:24] : Temp_Mantissa[45:23];
    assign zero = (Mantissa == 23'd0) ? 1'b1 : 1'b0;
    assign Temp_Exponent = `Exponent_X + `Exponent_Y - 8'b01111111;
    assign Exponent = Temp_Mantissa[47] ? (Temp_Exponent + 1'b1) : Temp_Exponent;
    assign overflow_flag = ((Exponent[8] & !Exponent[7]) & !zero) ? 1'b1 : 1'b0;
    assign underflow_flag = ((Exponent[8] & Exponent[7]) & !zero) ? 1'b1 : 1'b0;

    assign res = overflow_flag ? {sign, 8'b11111111, 23'd0} : underflow_flag ? {sign, 31'd0} :{sign, Exponent[7:0], Mantissa};

endmodule
*/