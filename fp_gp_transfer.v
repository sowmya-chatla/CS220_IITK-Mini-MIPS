`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 12:37:16 PM
// Design Name: 
// Module Name: fp_gp_transfer
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


module fp_gp_transfer(
    input wire [31:0] gp_reg,     // General purpose register value
    input wire [31:0] fp_reg,     // Floating point register value
    input wire is_mtc1,           // Direction: 1 for GP to FP, 0 for FP to GP
    output reg [31:0] result      // Result based on direction
);
    always @(*) begin
        if (is_mtc1)
            result = gp_reg;      // Move to coprocessor 1 (FP)
        else
            result = fp_reg;      // Move from coprocessor 1
    end
endmodule
