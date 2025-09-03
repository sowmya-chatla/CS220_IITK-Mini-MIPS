`timescale 1ns / 1ps

module instruction_decode(
    input wire [31:0] instruction,
    input wire clk,
    output reg [5:0] opcode,
    output reg [4:0] rs,
    output reg [4:0] rt,
    output reg [4:0] rd,
    output reg [4:0] shamt,
    output reg [5:0] funct,
    output reg [15:0] immediate,
    output reg [25:0] target_address,
    output reg [3:0] alu_op,
    output reg RegDst,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg Jump,
    output reg FPOperation,
    output reg FPRegWrite,
    output reg FPRegRead
);

    always @(posedge clk) begin
        // Extract instruction fields
        opcode         = instruction[31:26];
        rs             = instruction[25:21];
        rt             = instruction[20:16];
        rd             = instruction[15:11];
        shamt          = instruction[10:6];
        funct          = instruction[5:0];
        immediate      = instruction[15:0];
        target_address = instruction[25:0];

        // Default all control signals
        RegDst      = 0;
        ALUSrc      = 0;
        MemtoReg    = 0;
        RegWrite    = 0;
        MemRead     = 0;
        MemWrite    = 0;
        Branch      = 0;
        Jump        = 0;
        FPOperation = 0;
        FPRegWrite  = 0;
        FPRegRead   = 0;
        alu_op      = 4'b0000;

        case (opcode)
            6'b000000: begin  // R-type
                case (funct)
                    6'b100000: begin // add
                        alu_op = 4'b0000; RegDst = 1; RegWrite = 1;
                    end
                    6'b100010: begin // sub
                        alu_op = 4'b0001; RegDst = 1; RegWrite = 1;
                    end
                    6'b100001: begin // addu
                        alu_op = 4'b0010; RegDst = 1; RegWrite = 1;
                    end
                    6'b100011: begin // subu
                        alu_op = 4'b0011; RegDst = 1; RegWrite = 1;
                    end
                    6'b011000: begin // mult
                        alu_op = 4'b0100; // Extended
                    end
                    6'b011001: begin // multu
                        alu_op = 4'b0101; // Extended
                    end
                    6'b011010: begin // mul
                        alu_op = 4'b0110; RegDst = 1; RegWrite = 1; // Pseudo (extension)
                    end
                    6'b100100: begin // and
                        alu_op = 4'b0111; RegDst = 1; RegWrite = 1;
                    end
                    6'b100101: begin // or
                        alu_op = 4'b1000; RegDst = 1; RegWrite = 1;
                    end
                    6'b100111: begin // nor
                        alu_op = 4'b1001; RegDst = 1; RegWrite = 1;
                    end
                    6'b100110: begin // xor
                        alu_op = 4'b1010; RegDst = 1; RegWrite = 1;
                    end
                    6'b000000: begin // sll
                        alu_op = 4'b1011; RegDst = 1; RegWrite = 1;
                    end
                    6'b000010: begin // srl
                        alu_op = 4'b1100; RegDst = 1; RegWrite = 1;
                    end
                    6'b000011: begin // sra
                        alu_op = 4'b1110; RegDst = 1; RegWrite = 1;
                    end
                    6'b101010: begin // slt
                        alu_op = 4'b1111; RegDst = 1; RegWrite = 1;
                    end
                    6'b001000: begin // jr
                        Jump = 1;
                    end
                endcase
            end

            // I-Type
            6'b001000: begin // addi
                alu_op = 4'b0000; ALUSrc = 1; RegWrite = 1;
            end
            6'b001001: begin // addiu
                alu_op = 4'b0010; ALUSrc = 1; RegWrite = 1;
            end
            6'b001100: begin // andi
                alu_op = 4'b0111; ALUSrc = 1; RegWrite = 1;
            end
            6'b001101: begin // ori
                alu_op = 4'b1000; ALUSrc = 1; RegWrite = 1;
            end
            6'b001110: begin // xori
                alu_op = 4'b1010; ALUSrc = 1; RegWrite = 1;
            end
            6'b100011: begin // lw
                alu_op = 4'b0000; ALUSrc = 1; MemRead = 1; MemtoReg = 1; RegWrite = 1;
            end
            6'b101011: begin // sw
                alu_op = 4'b0000; ALUSrc = 1; MemWrite = 1;
            end
            6'b001111: begin // lui
                alu_op = 4'b0000; ALUSrc = 1; RegWrite = 1;
            end

            // Branch
            6'b000100: begin // beq
                alu_op = 4'b0001; Branch = 1;
            end
            6'b000101: begin // bne
                alu_op = 4'b0001; Branch = 1;
            end

            // Jump
            6'b000010: begin // j
                Jump = 1;
            end
            6'b000011: begin // jal
                Jump = 1; RegWrite = 1; // write return address to $ra
            end

            // Extended / Custom
            6'b011000: begin // FP arithmetic (add.s, sub.s, etc.)
                FPOperation = 1; FPRegWrite = 1;
            end
            6'b011001: begin // FP compare
                FPOperation = 1;
            end
            6'b010110: begin // mfc1
                FPRegRead = 1; RegWrite = 1;
            end
            6'b010111: begin // mtc1
                FPRegWrite = 1;
            end
            6'b011010: begin // mov.s (conditional move)
                FPOperation = 1; FPRegWrite = 1;
            end
        endcase
    end
endmodule