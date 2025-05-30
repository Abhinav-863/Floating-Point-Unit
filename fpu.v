module fpu(
    input clk,
    input rst,
    input sp_dp,    // 0 = single precision, 1 = double precision
    input [2:0] opCode, // 000 = add, 001 = subtract, 010 = multiply, 011 = divide, 100 = reciprocal_A, 101 = reciprocal_B
    input [31:0] a_sp,
    input [31:0] b_sp,
    input [63:0] a_dp,
    input [63:0] b_dp,
    output [31:0] result_sp,
    output [63:0] result_dp,
    output overflow,
    output underflow
    //output ready
    );

    reg [31:0] result_sp1;
    reg [63:0] result_dp1;
    reg overflow1;
    reg underflow1;
    reg ready1;

    // Single precision
    wire overflow_sp;
    wire underflow_sp;
    wire ready_sp;
    wire [31:0] result_sp_temp;
    
    fpu_32 fpu_32 (
        .clk(clk),
        .rst(rst),
        .OpCode(opCode),
        .A(a_sp),
        .B(b_sp),
        .Result(result_sp_temp),
        //.Ready(ready_sp),
        .Overflow_out(overflow_sp),
        .Underflow_out(underflow_sp)
    );

    // Double precision
    wire overflow_dp;
    wire underflow_dp;
    wire ready_dp;
    wire [63:0] result_dp_temp;

    fpu_64 fpu_64 (
        .clk(clk),
        .rst(rst),
        .OpCode(opCode),
        .A(a_dp),
        .B(b_dp),
        .Result(result_dp_temp),
        //.Ready(ready_dp),
        .Overflow_out(overflow_dp),
        .Underflow_out(underflow_dp)
    );

    /*
    // Select single or double precision
    assign overflow = sp_dp ? overflow_dp : overflow_sp;
    assign underflow = sp_dp ? underflow_dp : underflow_sp;
    assign ready = sp_dp ? ready_dp : ready_sp;

    assign result_sp = sp_dp ? 32'b0 : result_sp_temp;
    assign result_dp = sp_dp ? result_dp_temp : 64'b0;
    */

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            result_sp1 = 32'b0;
            result_dp1 = 64'b0;
            overflow1 = 1'b0;
            underflow1 = 1'b0;
            ready1 = 1'b0;
        end 
        else begin
            overflow1 = sp_dp ? overflow_dp : overflow_sp;
            underflow1 = sp_dp ? underflow_dp : underflow_sp;
            ready1 = sp_dp ? ready_dp : ready_sp;
            result_sp1 = sp_dp ? 32'b0 : result_sp_temp;
            result_dp1 = sp_dp ? result_dp_temp : 64'b0;
        end
    end

    assign result_sp = result_sp1;
    assign result_dp = result_dp1;
    assign overflow = overflow1;
    assign underflow = underflow1;
    //assign ready = ready1;

endmodule