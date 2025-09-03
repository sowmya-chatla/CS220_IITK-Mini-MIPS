`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 01:00:02 PM
// Design Name: 
// Module Name: registerFile
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


//32 x 32 registerFile
module registerFile(ReadAddr1, ReadAddr2, WriteAddr, WriteData, WriteEnable, Data1, Data2, clk);
input [4:0] ReadAddr1, ReadAddr2, WriteAddr;  //32 register numbers from 00000 to 11111
input [31:0] WriteData;
input WriteEnable, clk;
output [31:0] Data1, Data2;
reg [31:0] RF [31:0];
assign Data1 = RF[ReadAddr1];   //if ReadAddr1 = 00001, then RF[1] is accessed
assign Data2 = RF[ReadAddr2];
always@(posedge clk) begin
    if(WriteEnable)
    RF[WriteAddr] <= WriteData;
    else
    RF[WriteAddr] <= RF[WriteAddr];
end
task displayRegister(input [4:0] addr);
    $display("RF[%0d] = %0d", addr, RF[addr]);
endtask
endmodule
