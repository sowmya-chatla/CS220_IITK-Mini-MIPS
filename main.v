`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/13/2025 12:12:18 PM
// Design Name:
// Module Name: main
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
module main(clk,rst,instr,instr_addr, data, data_addr, ins_we,data_we,Memory_out,done);
input clk,rst;
input [31:0] instr,data;
input [10:0] instr_addr,data_addr;
input ins_we,data_we;
output [31:0] Memory_out;
output reg done;
wire [31:0] PC_out,ins_out;
wire [31:0] PC_in;
PC program_counter(clk,rst,done,PC_in,PC_out);
memory_wrapper ins_mem (
  .a(instr_addr),
  .d(instr),
  .dpra(PC_out[10:0]), // 2048 x 32
  .clk(clk),
  .we(ins_we),
  .dpo(ins_out)
);
wire [4:0] rs, rt, rd, shamt;
wire [5:0] code, funct;
wire [15:0] imm;
wire [25:0] jump_addr;
// Control signals
wire RegWrite, ALUSrc, Branch, Jump, MemRead, MemWrite, MemtoReg, ShiftEnable;
wire [1:0] RegDst;
wire [3:0] ALUOp;
wire FPOperation;
wire FPRegWrite;
wire FPRegRead;
instruction_decode dc(
    ins_out, clk, code, rs, rt, rd, shamt, funct, imm, jump_addr, ALUOp,
    RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, FPOperation, FPRegWrite, FPRegRead
);

reg [4:0] WriteReg;
always@(*)
begin
if(RegDst==2'd2)
WriteReg<=5'd31;   // $ra, jal instruction
else if(RegDst==2'd1)
WriteReg<=rd;
else
WriteReg<=rt;
end
wire [31:0] WriteData,Data1,Data2;
wire [31:0] WB_data;
assign WriteData=(RegDst==2'd2)?(PC_out+1):WB_data;
registerFile regs(rs, rt, WriteReg, WriteData, RegWrite, Data1, Data2, clk);

wire [31:0] inp1;
wire [31:0] inp2;
wire [31:0] immediate;
wire [31:0] shiftamt;
assign immediate = (code == 6'b001111) ? {imm, 16'b0} : {{16{imm[15]}}, imm};
assign inp1 = Data1;
assign inp2 = (ALUSrc == 1'b1) ? immediate : Data2;

wire [31:0] ALU_out;
wire zero_flag;
wire negative_flag;
wire overflow_flag;
wire carry_out;
alu ins(inp1, inp2, shamt, ALUOp, ALU_out, zero_flag, negative_flag, overflow_flag, carry_out);

reg [10:0] data_write_addr; reg [10:0] data_read_addr;
always@(*)
begin
if(done)
data_read_addr<=data_addr;
else
data_read_addr<=ALU_out[10:0];
end
always@(*)
begin
if(rst)
data_write_addr<=data_addr;
else
data_write_addr<=ALU_out[10:0];
end
wire [31:0] data_write; wire mem_we;
assign data_write=(rst==1)?data:Data2;
assign mem_we=(rst==1)?data_we:MemWrite;
memory_wrapper data_mem (
  .a(data_write_addr),
  .d(data_write),
  .dpra(data_read_addr),
  .clk(clk),
  .we(mem_we),
  .dpo(Memory_out)
);
assign WB_data=(MemtoReg)?Memory_out:ALU_out;

always@ (posedge clk) begin
  if(code == 6'b111111) 
  done <= 1;
  else done <= 0;
end
wire branch_taken;
branch_unit bu(PC_out, Data1, imm, jump_addr, ALU_out, zero_flag, negative_flag, carry_out, Branch, Jump, code, PC_in, branch_taken);
endmodule