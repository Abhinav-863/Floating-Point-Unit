module fpu_normalizer #(
    parameter Size_Mantissa = 23, 
    parameter Size_Exponent = 8
    )(
    input [Size_Mantissa+1:0] mantissa,
    input [Size_Exponent -1:0] exponent,
    output [Size_Mantissa-1:0] normalized_mantissa,
    output [Size_Exponent -1:0] normalized_exponent,
    output overflow,
    output underflow
    );

    // if mantissa[Size_Mantissa] is 1, then shift right by 1 and increment exponent
    // if mantissa[Size_Mantissa-1] is 0, then shift left by 1 and decrement exponent till mantissa[Size_Mantissa-1] is 1

    reg [Size_Mantissa+1:0] temp_mantissa;
    reg [Size_Exponent-1:0] temp_exponent;
    reg temp_overflow;
    reg temp_underflow;

    // create a counter to use it in the loop
    reg [Size_Mantissa-1:0] count;

    always @(*) begin
        temp_mantissa = mantissa;
        temp_exponent = exponent;
        if (mantissa[Size_Mantissa+1] == 1) begin
            temp_mantissa = mantissa >> 1;
            temp_exponent = exponent + 1;
        end
        else begin
            count = 0;
            while (temp_exponent != 0 && temp_mantissa[Size_Mantissa] == 0 && count != Size_Mantissa) begin
                if (temp_mantissa != 0) begin
                    temp_mantissa = temp_mantissa << 1;
                    temp_exponent = temp_exponent - 1;
                end
                count = count + 1;
            end
        end

        temp_overflow = 0;
        temp_underflow = 0;
        if (temp_exponent == 0) begin
            temp_underflow = 1;
        end
        else if (temp_exponent == (1 << Size_Exponent ) - 1) begin
            temp_overflow = 1;
        end
    end
    // Overflow and underflow flag will be triggered if the exponent is smaller than 1 or greater than 254
    // 1 is the smallest exponent that can be represented in the fpu
    // 254 is the largest exponent that can be represented in the fpu
    // check if the exponent after normalization is all 1s or all 0s
    assign overflow = temp_overflow;
    assign underflow = temp_underflow;
    assign normalized_mantissa = temp_mantissa[Size_Mantissa-1:0];
    assign normalized_exponent = temp_exponent;

endmodule
