module fpu_comparator_tb();
    parameter size = 32;
    reg [size-1:0] a, b;
    wire [size-1:0] difference;
    wire sign;

    fpu_comparator #(.size(size)) uut (
        .a(a),
        .b(b),
        .difference(difference),
        .sign(sign)
    );

    initial begin
        a = 32'd10;
        b = 32'd5;
        #10;

        a = 32'd5;
        b = 32'd10;
        #10;

        a = 32'd10;
        b = 32'd10;
        #10;

        a = 32'b11111111111111111111111111111011; //-5
        b = 32'b11111111111111111111111111110110; //-10
        #10;
    end

    initial begin
        $monitor("a = %d, b = %d, difference = %d, sign = %b", a, b, difference, sign);
    end
    
endmodule