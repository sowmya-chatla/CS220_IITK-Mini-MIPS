`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 12:35:40 PM
// Design Name: 
// Module Name: instruction_fetch
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


module instruction_fetch(input wire [15:0] mem_addr, output reg[31:0] ins, input clk);
  // Instruction memory - increased to accommodate more instructions
  reg [31:0]ins_address[4095:0];
  
  initial begin
    // R-type Arithmetic Instructions
    ins_address[0] = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b000000};  // add r3, r1, r2
    ins_address[1] = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b000001};  // sub r3, r1, r2
    ins_address[2] = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b000010};  // addu r3, r1, r2
    ins_address[3] = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b000011};  // subu r3, r1, r2
    ins_address[4] = {6'b000000, 5'b00001, 5'b00010, 5'b00000, 5'b00000, 6'b000100};  // madd r1, r2
    ins_address[5] = {6'b000000, 5'b00001, 5'b00010, 5'b00000, 5'b00000, 6'b000101};  // maddu r1, r2
    ins_address[6] = {6'b000000, 5'b00001, 5'b00010, 5'b00000, 5'b00000, 6'b000110};  // mul r1, r2
    ins_address[7] = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b000111};  // and r3, r1, r2
    ins_address[8] = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b001000};  // or r3, r1, r2
    ins_address[9] = {6'b000000, 5'b00001, 5'b00000, 5'b00011, 5'b00000, 6'b001001};  // not r3, r1
    ins_address[10] = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b001010}; // xor r3, r1, r2
    
    // Shift operations
    ins_address[11] = {6'b000000, 5'b00001, 5'b00000, 5'b00011, 5'd10, 6'b001011};  // sll r3, r1, 10
    ins_address[12] = {6'b000000, 5'b00001, 5'b00000, 5'b00011, 5'd10, 6'b001100};  // srl r3, r1, 10
    ins_address[13] = {6'b000000, 5'b00001, 5'b00000, 5'b00011, 5'd10, 6'b001101};  // sla r3, r1, 10
    ins_address[14] = {6'b000000, 5'b00001, 5'b00000, 5'b00011, 5'd10, 6'b001110};  // sra r3, r1, 10
    
    // I-type Arithmetic Instructions
    ins_address[15] = {6'b000001, 5'b00001, 5'b00011, 16'd1000};  // addi r3, r1, 1000
    ins_address[16] = {6'b000010, 5'b00001, 5'b00011, 16'd1000};  // addiu r3, r1, 1000
    ins_address[17] = {6'b000011, 5'b00001, 5'b00011, 16'd1000};  // andi r3, r1, 1000
    ins_address[18] = {6'b000100, 5'b00001, 5'b00011, 16'd1000};  // ori r3, r1, 1000
    ins_address[19] = {6'b000101, 5'b00001, 5'b00011, 16'd1000};  // xori r3, r1, 1000
    
    // Memory operations
    ins_address[20] = {6'b000110, 5'b00001, 5'b00011, 16'd10};  // lw r3, 10(r1)
    ins_address[21] = {6'b000111, 5'b00011, 5'b00001, 16'd10};  // sw r3, 10(r1)
    ins_address[22] = {6'b001000, 5'b00000, 5'b00011, 16'd1000};  // lui r3, 1000
    
    // Branch operations
    ins_address[23] = {6'b001001, 5'b00001, 5'b00010, 16'd10};  // beq r1, r2, 10
    ins_address[24] = {6'b001010, 5'b00001, 5'b00010, 16'd10};  // bne r1, r2, 10
    ins_address[25] = {6'b001011, 5'b00001, 5'b00010, 16'd10};  // bgt r1, r2, 10
    ins_address[26] = {6'b001100, 5'b00001, 5'b00010, 16'd10};  // bgte r1, r2, 10
    ins_address[27] = {6'b001101, 5'b00001, 5'b00010, 16'd10};  // ble r1, r2, 10
    ins_address[28] = {6'b001110, 5'b00001, 5'b00010, 16'd10};  // bleq r1, r2, 10
    ins_address[29] = {6'b001111, 5'b00001, 5'b00010, 16'd10};  // bleu r1, r2, 10
    ins_address[30] = {6'b010000, 5'b00001, 5'b00010, 16'd10};  // bgtu r1, r2, 10
    
    // Jump operations
    ins_address[31] = {6'b010001, 26'd10};  // j 10
    ins_address[32] = {6'b010010, 5'b00001, 21'd0};  // jr r1
    ins_address[33] = {6'b010011, 26'd10};  // jal 10
    
    // Comparison operations
    ins_address[34] = {6'b000000, 5'b00001, 5'b00010, 5'b00011, 5'b00000, 6'b001111};  // slt r3, r1, r2
    ins_address[35] = {6'b010100, 5'b00001, 5'b00011, 16'd100};  // slti r3, r1, 100
    ins_address[36] = {6'b010101, 5'b00001, 5'b00011, 16'd100};  // seq r3, r1, 100
    
    // Floating point operations
    ins_address[37] = {6'b010110, 5'b00001, 5'b00010, 16'd0};  // mfc1 r1, f2
    ins_address[38] = {6'b010111, 5'b00001, 5'b00010, 16'd0};  // mtc1 f1, r2
    ins_address[39] = {6'b011000, 5'b00001, 5'b00010, 5'b00011, 5'd0, 6'b000000};  // add.s f3, f1, f2
    ins_address[40] = {6'b011000, 5'b00001, 5'b00010, 5'b00011, 5'd0, 6'b000001};  // sub.s f3, f1, f2
    ins_address[41] = {6'b011001, 3'b001, 2'b00, 5'b00001, 5'b00010, 12'd0};  // c.eq.s cc1, f1, f2
    ins_address[42] = {6'b011001, 3'b001, 2'b00, 5'b00001, 5'b00010, 12'd1};  // c.le.s cc1, f1, f2
    ins_address[43] = {6'b011001, 3'b001, 2'b00, 5'b00001, 5'b00010, 12'd2};  // c.lt.s cc1, f1, f2
    ins_address[44] = {6'b011001, 3'b001, 2'b00, 5'b00001, 5'b00010, 12'd3};  // c.ge.s cc1, f1, f2
    ins_address[45] = {6'b011001, 3'b001, 2'b00, 5'b00001, 5'b00010, 12'd4};  // c.gt.s cc1, f1, f2
    ins_address[46] = {6'b011010, 3'b001, 2'b00, 5'b00001, 5'b00010, 12'd0};  // mov.s cc1, f1, f2
  end
  
  always @(posedge clk) begin
    ins = ins_address[mem_addr];
  end
endmodule
