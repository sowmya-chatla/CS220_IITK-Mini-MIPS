`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 12:37:50 PM
// Design Name: 
// Module Name: lui_handler
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


module lui_handler(
    input wire [15:0] immediate,
    output wire [31:0] result
);
    // LUI: Load upper immediate - places immediate value in upper 16 bits
    assign result = {immediate, 16'd0};
endmodule
