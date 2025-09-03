`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 12:34:14 PM
// Design Name: 
// Module Name: branch_unit
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

module branch_unit(
    input wire [31:0] pc,              // Current program counter
    input wire [31:0] register_rs,     // Value in rs register (for jr instruction)
    input wire [15:0] branch_offset,   // Branch offset from immediate field
    input wire [25:0] jump_target,     // Jump target address
    input wire [31:0] alu_result,      // Result from ALU for condition checking
    input wire zero_flag,              // Zero flag from ALU
    input wire negative_flag,          // Negative flag from ALU
    input wire carry_out,              // Carry out flag from ALU
    input wire Branch,                 // Branch control signal
    input wire Jump,                   // Jump control signal
    input wire [5:0] opcode,           // Opcode to determine branch/jump type
    output reg [31:0] next_pc,         // Next PC value
    output reg branch_taken            // Indicates if branch is taken
);
    // Calculated PC values for different branch types
    wire [31:0] pc_plus_one = pc + 32'd1;
    wire [31:0] branch_target = pc_plus_one + {{14{branch_offset[15]}}, branch_offset, 2'b00}; // Account for word addressing
    wire [31:0] jump_address = {pc_plus_one[31:28], jump_target, 2'b00};
    // Logic to determine if branch is taken based on condition
    always @(*) begin
        // Default: proceed to next instruction
        next_pc = pc_plus_one;
        branch_taken = 1'b0;
        if (Branch) begin
            case(opcode)
                6'b000100: begin // beq - Branch if Equal
                    if (zero_flag) begin
                        next_pc = branch_target;
                        branch_taken = 1'b1;
                    end
                end
                6'b000101: begin // bne - Branch if Not Equal
                    if (!zero_flag) begin
                        next_pc = branch_target;
                        branch_taken = 1'b1;
                    end
                end
                6'b001011: begin // bgt - Branch if Greater Than
                    if (!zero_flag && !negative_flag) begin
                        next_pc = branch_target;
                        branch_taken = 1'b1;
                    end
                end
                6'b001100: begin // bgte - Branch if Greater Than or Equal
                    if (zero_flag || !negative_flag) begin
                        next_pc = branch_target;
                        branch_taken = 1'b1;
                    end
                end
                6'b001101: begin // ble - Branch if Less Than
                    if (negative_flag) begin
                        next_pc = branch_target;
                        branch_taken = 1'b1;
                    end
                end
                6'b001110: begin // bleq - Branch if Less Than or Equal
                    if (zero_flag || negative_flag) begin
                        next_pc = branch_target;
                        branch_taken = 1'b1;
                    end
                end
                6'b001111: begin // bleu - Branch if Less Than or Equal Unsigned
                    if (zero_flag || carry_out) begin
                        next_pc = branch_target;
                        branch_taken = 1'b1;
                    end
                end
                6'b010000: begin // bgtu - Branch if Greater Than Unsigned
                    if (!zero_flag && !carry_out) begin
                        next_pc = branch_target;
                        branch_taken = 1'b1;
                    end
                end
            endcase
        end
        if (Jump) begin
            branch_taken = 1'b1;
            case(opcode)
                6'b000010: next_pc = jump_address;       // j (Opcode 0x02)
                6'b000011: next_pc = jump_address;       // jal (Opcode 0x03)
                6'b000000: next_pc = register_rs;        // jr (R-type, handled via funct in decode)
            endcase
        end
    end
endmodule