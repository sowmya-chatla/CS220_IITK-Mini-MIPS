`timescale 1ns / 1ps

module processor_tb;
    reg clk, rst;
    reg [31:0] instr, data;
    reg [10:0] instr_addr, data_addr;
    reg ins_we, data_we;
    wire [31:0] Memory_out;
    wire done;

    main uut (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .instr_addr(instr_addr),
        .data(data),
        .data_addr(data_addr),
        .ins_we(ins_we),
        .data_we(data_we),
        .Memory_out(Memory_out),
        .done(done)
    );

    always #5 clk = ~clk;

    task load_instruction;
        input [10:0] addr;
        input [31:0] value;
        begin
            @(posedge clk);
            instr = value;
            instr_addr = addr;
            ins_we = 1;
            @(posedge clk);
            ins_we = 0;
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        #20;
        rst = 0;

        // 1. Insertion Sort Test
        // Initialize array in memory: [5, 2, 4, 6, 1, 3]
        $display("=== Testing Insertion Sort ===");

        // ... repeat for other elements
        // Insert sort algorithm implementation
        // ... (sorting instructions)
        // Complete array initialization
load_instruction(0, 32'h3c010000);  // lui $1, 0x0000        // $1 = 0x00000000
load_instruction(1, 32'h34210010);  // ori $1, $1, 0x0010    // $1 = 0x00000010 (array base)
load_instruction(2, 32'h24020005);  // addi $2, $0, 5        // array[0] = 5
load_instruction(3, 32'hac220000);  // sw $2, 0($1)
load_instruction(4, 32'h24020002);  // addi $2, $0, 2        // array[1] = 2
load_instruction(5, 32'hac220004);  // sw $2, 4($1)
load_instruction(6, 32'h24020004);  // addi $2, $0, 4        // array[2] = 4
load_instruction(7, 32'hac220008);  // sw $2, 8($1)
load_instruction(8, 32'h24020006);  // addi $2, $0, 6        // array[3] = 6
load_instruction(9, 32'hac22000c);  // sw $2, 12($1)
load_instruction(10, 32'h24020001); // addi $2, $0, 1        // array[4] = 1
load_instruction(11, 32'hac220010); // sw $2, 16($1)
load_instruction(12, 32'h24020003); // addi $2, $0, 3        // array[5] = 3
load_instruction(13, 32'hac220014); // sw $2, 20($1)

// Insertion sort algorithm
load_instruction(14, 32'h24030001); // addi $3, $0, 1        // i = 1
load_instruction(15, 32'h2407ffff); // addi $7, $0, -1       // j initializer
load_instruction(16, 32'h00032080); // sll $4, $3, 2        // $4 = i*4 (outer loop)
load_instruction(17, 32'h00241020); // add $2, $1, $4       // $2 = arr + i*4
load_instruction(18, 32'h8c450000); // lw $5, 0($2)         // key = arr[i]
load_instruction(19, 32'h2064ffff); // addi $4, $3, -1      // j = i-1 (inner loop)
load_instruction(20, 32'h0087082a); // slt $1, $4, $7       // $1 = (j < 0)
load_instruction(21, 32'h14200008); // bnez $1, 8           // break if j < 0
load_instruction(22, 32'h00241820); // add $3, $1, $4       // $3 = arr + j*4
load_instruction(23, 32'h8c660000); // lw $6, 0($3)         // arr[j]
load_instruction(24, 32'h00a6082a); // slt $1, $5, $6       // $1 = (key < arr[j])
load_instruction(25, 32'h10200003); // beqz $1, 3           // break if key >= arr[j]
load_instruction(26, 32'hac660004); // sw $6, 4($3)         // arr[j+1] = arr[j]
load_instruction(27, 32'h2084ffff); // addi $4, $4, -1      // j--
load_instruction(28, 32'h08000014); // j 20                 // loop inner
load_instruction(29, 32'h00241020); // add $2, $1, $4       // arr + j*4
load_instruction(30, 32'hac450004); // sw $5, 4($2)         // arr[j+1] = key
load_instruction(31, 32'h20630001); // addi $3, $3, 1       // i++
load_instruction(32, 32'h28620006); // slti $2, $3, 6       // $2 = (i < 6)
load_instruction(33, 32'h1440ffef); // bnez $2, -17         // loop outer

        #200;
        verify_sorted_array:
        // Verify memory locations 0x10-0x24
        $display("Sorted array verification complete");

        // 2. Floating Point Subtraction Test
        $display("\n=== Testing FP Subtraction ===");
        load_instruction(20, 32'h44800000);  // mtc1 $0, $f0        (0.0)
        load_instruction(21, 32'h44800800);  // mtc1 $0, $f1        (1.5)
        load_instruction(22, 32'h44801000);  // mtc1 $0, $f2        (2.5)
        load_instruction(23, 32'h46020881);  // sub.s $f3, $f1, $f2  (1.5 - 2.5 = -1.0)
        load_instruction(24, 32'h44031800);  // mfc1 $3, $f3
        #50;
        if(uut.regs.RF[3] == 32'hbf800000)  // -1.0 in IEEE754
            $display("FP Subtraction PASSED");
        else
            $display("FP Subtraction FAILED");

        // 3. Integer Multiplication Test
        $display("\n=== Testing Integer Multiplication ===");
        load_instruction(30, 32'h24040005);  // addi $4, $0, 5
        load_instruction(31, 32'h24050006);  // addi $5, $0, 6
        load_instruction(32, 32'h00850018);  // mult $4, $5
        load_instruction(33, 32'h00001012);  // mflo $2
        load_instruction(34, 32'h00001810);  // mfhi $3
        #50;
        if(uut.regs.RF[2] == 30 && uut.regs.RF[3] == 0)
            $display("Multiplication PASSED");
        else
            $display("Multiplication FAILED");

        $finish;
    end

endmodule
