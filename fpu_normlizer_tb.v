module fpu_normalizer_tb();

    parameter Mantissa_Size = 23;
    parameter Exponent_Size = 8;

    reg [Mantissa_Size+1:0] mantissa;
    reg [Exponent_Size-1:0] exponent;
    wire [Mantissa_Size-1:0] normalized_mantissa;
    wire [Exponent_Size-1:0] normalized_exponent;
    wire overflow;
    wire underflow;

    fpu_normalizer #(
        .Size_Mantissa(Mantissa_Size),
        .Size_Exponent(Exponent_Size)
    ) uut (
        .mantissa(mantissa),
        .exponent(exponent),
        .normalized_mantissa(normalized_mantissa),
        .normalized_exponent(normalized_exponent),
        .overflow(overflow),
        .underflow(underflow)
    );

    initial begin
        // Test case 1: Normal input, no normalization needed
        mantissa = 25'b011111111111111111111111; // hidden bit 1 + full mantissa
        exponent = 8'd100;
        #10;

        // Test case 2: Mantissa too big (overflow by hidden bit 2)
        mantissa = 25'b1000000000000000000000000; // overflow hidden bit
        exponent = 8'd100;
        #10;

        // Test case 3: Mantissa needs left shift
        mantissa = 25'b001111111111111111111111; // missing hidden 1
        exponent = 8'd100;
        #10;

        // Test case 4: Very small mantissa, triggering underflow
        mantissa = 25'b000000000000000000000001;
        exponent = 8'd1;
        #10;

        // Test case 5: Already normalized mantissa
        mantissa = 25'b010000000000000000000000; 
        exponent = 8'd50;
        #10;

        // Test case 6: Exponent maximum before overflow
        mantissa = 25'b1000000000000000000000000; 
        exponent = 8'd254;
        #10;

        // Test case 7: Exponent at zero (underflow edge)
        mantissa = 25'b000000000000000000000001;
        exponent = 8'd0;
        #10;
    end

    initial begin
        $monitor("Mantissa=%b, Exponent=%d, Normalized Mantissa=%b, Normalized Exponent=%d, Overflow=%b, Underflow=%b", mantissa, exponent, normalized_mantissa, normalized_exponent, overflow, underflow);
        $finish;
    end

endmodule
