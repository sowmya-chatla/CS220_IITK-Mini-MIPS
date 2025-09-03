`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2025 11:22:05 AM
// Design Name: 
// Module Name: memory_wrapper
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

module memory_wrapper(a,d,dpra,clk,we,dpo);

input [10:0] a, dpra;   // Address lines for reading & writing
input clk, we;         // Clock and Write Enable
output [31:0] dpo;     // Output data (read)
input [31:0] d;        // Input data (write)

dist_mem_gen_0 your_instance_name (
  .a(a),        // input wire [10 : 0] a
  .d(d),        // input wire [31 : 0] d
  .dpra(dpra),  // input wire [10 : 0] dpra
  .clk(clk),    // input wire clk
  .we(we),      // input wire we
  .dpo(dpo)    // output wire [31 : 0] dpo
);

endmodule
