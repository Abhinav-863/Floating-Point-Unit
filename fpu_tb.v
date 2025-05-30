module fpu_tb;

    reg clk;
    reg rst;
    reg sp_dp; // 0 = single, 1 = double
    reg [2:0] opCode;
    reg [31:0] a_sp;
    reg [31:0] b_sp;
    reg [63:0] a_dp;
    reg [63:0] b_dp;

    wire [31:0] result_sp;
    wire [63:0] result_dp;
    wire overflow;
    wire underflow;
    //wire ready;

    fpu uut (
        .clk(clk),
        .rst(rst),
        .sp_dp(sp_dp),
        .opCode(opCode),
        .a_sp(a_sp),
        .b_sp(b_sp),
        .a_dp(a_dp),
        .b_dp(b_dp),
        .result_sp(result_sp),
        .result_dp(result_dp),
        .overflow(overflow),
        .underflow(underflow)
        //.ready(ready)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;
        sp_dp = 1; // double-precision
        opCode = 3'b000;
        a_sp = 32'b0;
        b_sp = 32'b0;
        a_dp = 64'b0;
        b_dp = 64'b0;
        #200;

        rst = 1;
        sp_dp = 1; // double-precision
        #200;

        // ADDITION: 2.0 + 3.0 = 5.0
        opCode = 3'b000;
        #200;
        a_dp = 64'h4000000000000000; // 2.0
        b_dp = 64'h4008000000000000; // 3.0
        #200;
        $display("ADD: A=%h, B=%h => Result=%h", a_dp, b_dp, result_dp);
        #200;

        // ADD: +INF + 3.0 = +INF
        a_dp = 64'h7FF0000000000000;
        b_dp = 64'h4008000000000000;
        #200;
        $display("ADD: A=%h, B=%h => Result=%h", a_dp, b_dp, result_dp);
        #200;

        // ADD: -INF + +INF = NaN
        a_dp = 64'hFFF0000000000000;
        b_dp = 64'h7FF0000000000000;
        #200;
        $display("ADD: A=%h, B=%h => Result=%h", a_dp, b_dp, result_dp);
        #200;

        // SUBTRACTION: 5.0 - 3.0 = 2.0
        opCode = 3'b001;
        #200;
        a_dp = 64'h4014000000000000;
        b_dp = 64'h4008000000000000;
        #200;
        $display("SUB: A=%h, B=%h => Result=%h", a_dp, b_dp, result_dp);
        #200;

        // SUB: +INF - +INF = NaN
        a_dp = 64'h7FF0000000000000;
        b_dp = 64'h7FF0000000000000;
        #200;
        $display("SUB: A=%h, B=%h => Result=%h", a_dp, b_dp, result_dp);
        #200;

        // MULTIPLICATION: 2.0 * 3.0 = 6.0
        opCode = 3'b010;
        #200;
        a_dp = 64'h4000000000000000;
        b_dp = 64'h4008000000000000;
        #200;
        $display("MUL: A=%h, B=%h => Result=%h", a_dp, b_dp, result_dp);
        #200;

        // MUL: 0.0 * +INF = NaN
        a_dp = 64'h0000000000000000;
        b_dp = 64'h7FF0000000000000;
        #200;
        $display("MUL: A=%h, B=%h => Result=%h", a_dp, b_dp, result_dp);
        #200;

        // DIVISION: 6.0 / 2.0 = 3.0
        opCode = 3'b011;
        #200;
        a_dp = 64'h4018000000000000;
        b_dp = 64'h4000000000000000;
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", a_dp, b_dp, result_dp);
        #200;

        // DIV: 2.0 / 0.0 = +INF
        a_dp = 64'h4000000000000000;
        b_dp = 64'h0000000000000000;
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", a_dp, b_dp, result_dp);
        #200;

        // DIV: 0.0 / 0.0 = NaN
        a_dp = 64'h0000000000000000;
        b_dp = 64'h0000000000000000;
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", a_dp, b_dp, result_dp);
        #200;

        // RECIPROCAL A: 1/2.0 = 0.5
        opCode = 3'b100;
        #200;
        a_dp = 64'h4000000000000000;
        #200;
        $display("RECIP_A: A=%h => Result=%h", a_dp, result_dp);
        #200;

        // RECIPROCAL A: 1/0.0 = +INF
        a_dp = 64'h0000000000000000;
        #200;
        $display("RECIP_A: A=%h => Result=%h", a_dp, result_dp);
        #200;

        // RECIPROCAL B: 1/4.0 = 0.25
        opCode = 3'b101;
        #200;
        b_dp = 64'h4010000000000000;
        #200;
        $display("RECIP_B: B=%h => Result=%h", b_dp, result_dp);
        #200;

        // RECIPROCAL B: 1/INF = 0.0
        b_dp = 64'h7FF0000000000000;
        #200;
        $display("RECIP_B: B=%h => Result=%h", b_dp, result_dp);
        #200;

        #200;
        sp_dp = 0; // single-precision
        #200;

        // ADDITION: 2.0 + 3.0 = 5.0
        opCode = 3'b000;
        #200;
        a_sp = 32'h40000000; // 2.0
        b_sp = 32'h40400000; // 3.0
        #200;
        $display("ADD: A=%h, B=%h => Result=%h", a_sp, b_sp, result_sp);
        #200;

        // ADD: +INF + 3.0 = +INF
        a_sp = 32'h7F800000;
        b_sp = 32'h40400000;
        #200;
        $display("ADD: A=%h, B=%h => Result=%h", a_sp, b_sp, result_sp);
        #200;

        // ADD: -INF + +INF = NaN
        a_sp = 32'hFF800000;
        b_sp = 32'h7F800000;
        #200;
        $display("ADD: A=%h, B=%h => Result=%h", a_sp, b_sp, result_sp);
        #200;

        // SUBTRACTION: 5.0 - 3.0 = 2.0
        opCode = 3'b001;
        #200;
        a_sp = 32'h40A00000; // 5.0
        b_sp = 32'h40400000; // 3.0
        #200;
        $display("SUB: A=%h, B=%h => Result=%h", a_sp, b_sp, result_sp);
        #200;

        // SUB: +INF - +INF = NaN
        a_sp = 32'h7F800000;
        b_sp = 32'h7F800000;
        #200;
        $display("SUB: A=%h, B=%h => Result=%h", a_sp, b_sp, result_sp);
        #200;

        // MULTIPLICATION: 2.0 * 3.0 = 6.0
        opCode = 3'b010;
        #200;
        a_sp = 32'h40000000;
        b_sp = 32'h40400000;
        #200;
        $display("MUL: A=%h, B=%h => Result=%h", a_sp, b_sp, result_sp);
        #200;

        // MUL: 0.0 * +INF = NaN
        a_sp = 32'h00000000;
        b_sp = 32'h7F800000;
        #200;
        $display("MUL: A=%h, B=%h => Result=%h", a_sp, b_sp, result_sp);
        #200;

        // DIVISION: 6.0 / 2.0 = 3.0
        opCode = 3'b011;
        #200;
        a_sp = 32'h40C00000; // 6.0
        b_sp = 32'h40000000; // 2.0
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", a_sp, b_sp, result_sp);
        #200;

        // DIV: 2.0 / 0.0 = +INF
        a_sp = 32'h40000000;
        b_sp = 32'h00000000;
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", a_sp, b_sp, result_sp);
        #200;

        // DIV: 0.0 / 0.0 = NaN
        a_sp = 32'h00000000;
        b_sp = 32'h00000000;
        #200;
        $display("DIV: A=%h, B=%h => Result=%h", a_sp, b_sp, result_sp);
        #200;

        // RECIPROCAL A: 1/2.0 = 0.5
        opCode = 3'b100;
        #200;
        a_sp = 32'h40000000;
        #200;
        $display("RECIP_A: A=%h => Result=%h", a_sp, result_sp);
        #200;

        // RECIPROCAL A: 1/0.0 = +INF
        a_sp = 32'h00000000;
        #200;
        $display("RECIP_A: A=%h => Result=%h", a_sp, result_sp);
        #200;

        // RECIPROCAL B: 1/4.0 = 0.25
        opCode = 3'b101;
        #200;
        b_sp = 32'h40800000;
        #200;
        $display("RECIP_B: B=%h => Result=%h", b_sp, result_sp);
        #200;

        // RECIPROCAL B: 1/INF = 0.0
        b_sp = 32'h7F800000;
        #200;
        $display("RECIP_B: B=%h => Result=%h", b_sp, result_sp);
        #200;

        $finish;
    end

endmodule
