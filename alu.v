`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 12:33:34 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input wire [31:0] operand_a,
    input wire [31:0] operand_b,
    input wire [4:0] shamt,
    input wire [3:0] alu_op,
    output reg [31:0] result,
    output reg zero_flag,
    output reg negative_flag,
    output reg overflow_flag,
    output reg carry_out,

    // Special outputs for multiplication operations
    output reg [31:0] hi_out,
    output reg [31:0] lo_out
);

    // Wire declarations for intermediate results
    wire [31:0] add_result, sub_result, addu_result, subu_result;
    wire [31:0] and_result, or_result, not_result, xor_result;
    wire [31:0] sll_result, srl_result, sla_result, sra_result;
    wire [31:0] slt_result;
    wire [63:0] mul_result, madd_temp, maddu_temp;
    wire add_overflow, sub_overflow;
    wire [32:0] full_add_result;

    // Intermediate values for HI and LO registers
    reg [31:0] hi_reg, lo_reg;

    // Addition unit with full result for carry_out
    assign full_add_result = {1'b0, operand_a} + {1'b0, operand_b};
    assign add_result = full_add_result[31:0];
    assign add_overflow = (~operand_a[31] & ~operand_b[31] & add_result[31]) |
                          (operand_a[31] & operand_b[31] & ~add_result[31]);

    // Subtraction unit
    assign sub_result = operand_a - operand_b;
    assign sub_overflow = (~operand_a[31] & operand_b[31] & sub_result[31]) |
                          (operand_a[31] & ~operand_b[31] & ~sub_result[31]);

    // Unsigned addition and subtraction
    assign addu_result = operand_a + operand_b;
    assign subu_result = operand_a - operand_b;

    // Logical operations
    assign and_result = operand_a & operand_b;
    assign or_result = operand_a | operand_b;
    assign not_result = ~operand_a;
    assign xor_result = operand_a ^ operand_b;

    // Shift operations
    assign sll_result = operand_a << shamt;
    assign srl_result = operand_a >> shamt;
    assign sla_result = operand_a << shamt;
    assign sra_result = $signed(operand_a) >>> shamt;

    // Set less than
    assign slt_result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;

    // Multiplication
    assign mul_result = operand_a * operand_b;

    // MADD and MADDU operations
    assign madd_temp = $signed(operand_a) * $signed(operand_b) + {hi_reg, lo_reg};
    assign maddu_temp = operand_a * operand_b + {hi_reg, lo_reg};

    // ALU operation selection
    always @(*) begin
        // Default values
        result = 32'h00000000;
        zero_flag = 1'b0;
        negative_flag = 1'b0;
        overflow_flag = 1'b0;
        carry_out = 1'b0;
        hi_out = hi_reg;
        lo_out = lo_reg;

        case(alu_op)
            4'b0000: begin // ADD
                result = add_result;
                carry_out = full_add_result[32];
                overflow_flag = add_overflow;
            end
            4'b0001: begin // SUB
                result = sub_result;
                overflow_flag = sub_overflow;
            end
            4'b0010: begin // ADDU
                result = addu_result;
            end
            4'b0011: begin // SUBU
                result = subu_result;
            end
            4'b0100: begin // MADD
                {hi_out, lo_out} = madd_temp;
            end
            4'b0101: begin // MADDU
                {hi_out, lo_out} = maddu_temp;
            end
            4'b0110: begin // MUL
                hi_out = mul_result[63:32];
                lo_out = mul_result[31:0];
            end
            4'b0111: begin // AND
                result = and_result;
            end
            4'b1000: begin // OR
                result = or_result;
            end
            4'b1001: begin // NOT
                result = not_result;
            end
            4'b1010: begin // XOR
                result = xor_result;
            end
            4'b1011: begin // SLL
                result = sll_result;
            end
            4'b1100: begin // SRL
                result = srl_result;
            end
            4'b1101: begin // SLA
                result = sla_result;
            end
            4'b1110: begin // SRA
                result = sra_result;
            end
            4'b1111: begin // SLT
                result = slt_result;
            end
        endcase

        // Set flags
        zero_flag = (result == 32'h00000000);
        negative_flag = result[31];
    end

    // For multiplication operations that update HI/LO
    always @(*) begin
        if (alu_op == 4'b0100 || alu_op == 4'b0101 || alu_op == 4'b0110) begin
            hi_reg = hi_out;
            lo_reg = lo_out;
        end
    end

endmodule