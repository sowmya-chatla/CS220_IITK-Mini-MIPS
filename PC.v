`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 05:58:08 AM
// Design Name: 
// Module Name: PC
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


module PC(clk, rst, done, PC_in, PC_out);
input clk, rst, done;
input [31:0] PC_in;
output reg [31:0] PC_out;
always @(posedge clk) begin
    if (rst) PC_out <= 32'b0;
    else if (!done) begin
        PC_out <= PC_in;
    end
end
endmodule
