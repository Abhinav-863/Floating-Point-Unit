/*
`define  Exponent_X X[62:52]
`define  Exponent_Y Y[62:52]
`define  Sign_X X[63]
`define  Sign_Y Y[63]

module fpu_64_multiplier(
    input [63:0] X,
    input [63:0] Y,
    output [63:0] res,
    output overflow_flag,
    output underflow_flag
);
    wire sign, zero;
    wire [52:0] Mantissa_X, Mantissa_Y;
    wire [51:0] Mantissa;
    wire [105:0] Temp_Mantissa;
    wire [11:0] Exponent, Temp_Exponent;

	assign sign = `Sign_X ^ `Sign_Y;
    assign Mantissa_X = (|`Exponent_X) ? {1'b1, X[51:0]} : {1'b0, X[51:0]};
    assign Mantissa_Y = (|`Exponent_Y) ? {1'b1, Y[51:0]} : {1'b0, Y[51:0]};
    assign Temp_Mantissa = Mantissa_X * Mantissa_Y;
    assign Mantissa = Temp_Mantissa[105] ? Temp_Mantissa[104:53] : Temp_Mantissa[103:52];
    assign zero = (Mantissa == 52'd0) ? 1'b1 : 1'b0;
    assign Temp_Exponent = `Exponent_X + `Exponent_Y - 11'b01111111111;
    assign Exponent = Temp_Mantissa[105] ? (Temp_Exponent + 1'b1) : Temp_Exponent;
    assign overflow_flag = ((Exponent[11] & !Exponent[10]) & !zero) ? 1'b1 : 1'b0;
    assign underflow_flag = ((Exponent[11] & Exponent[10]) & !zero) ? 1'b1 : 1'b0;

    assign res = overflow_flag ? {sign, 11'b11111111111, 52'd0} : underflow_flag ? {sign, 63'd0} :{sign, Exponent[10:0], Mantissa};

endmodule
*/

`define  Exponent_X X[62:52]
`define  Exponent_Y Y[62:52]
`define  Sign_X X[63]
`define  Sign_Y Y[63]

module fpu_64_multiplier(
    input [63:0] X,
    input [63:0] Y,
    output [63:0] res,
    output overflow_flag,
    output underflow_flag
);
    wire sign;
    wire [52:0] Mantissa_X, Mantissa_Y;
    wire [51:0] Mantissa;
    wire [105:0] Temp_Mantissa;
    wire [11:0] Temp_Exponent, Exponent;
    wire is_zero_input;

    assign sign = `Sign_X ^ `Sign_Y;

    // Handle normalized and denormalized values
    assign Mantissa_X = (|`Exponent_X) ? {1'b1, X[51:0]} : {1'b0, X[51:0]};
    assign Mantissa_Y = (|`Exponent_Y) ? {1'b1, Y[51:0]} : {1'b0, Y[51:0]};

    assign Temp_Mantissa = Mantissa_X * Mantissa_Y;

    assign Mantissa = Temp_Mantissa[105] ? Temp_Mantissa[104:53] : Temp_Mantissa[103:52];

    // Exponent calculation with bias
    assign Temp_Exponent = `Exponent_X + `Exponent_Y - 11'd1023;
    assign Exponent = Temp_Mantissa[105] ? (Temp_Exponent + 1'b1) : Temp_Exponent;

    // Zero input detection
    assign is_zero_input = (X[62:0] == 0) || (Y[62:0] == 0);

    // Result formatting
    assign res = is_zero_input ? 64'd0 : overflow_flag ? {sign, 11'b11111111111, 52'd0} : underflow_flag ? {sign, 63'd0} :{sign, Exponent[10:0], Mantissa};

    // Overflow and underflow detection
    assign overflow_flag  = is_zero_input ? 1'b0 : (Exponent[11] & ~Exponent[10]);
    assign underflow_flag = is_zero_input ? 1'b0 : (Exponent[11] &  Exponent[10]);

endmodule
