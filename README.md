IITK-Mini-MIPS

IITK-Mini-MIPS is a simulation tool built to interpret and execute MIPS assembly code. It models the behavior of a processor using a 5-stage pipeline architecture as a reference framework, but executes instructions in a step-by-step manner. This project serves as an educational model to explore how different stages of instruction processing work in modern processors.

Execution Stages
Instruction Fetch (IF)
Goal: Retrieve the next instruction from memory using the program counter (PC).
Details: The instruction memory holds a sequence of MIPS instructions, which are fetched and passed on for decoding.
Instruction Decode (ID)
Goal: Interpret the instruction and prepare for execution.
Details: Identifies instruction type (R-type, I-type, J-type), extracts operands, and sets up control signals.
Execution / ALU (EX)
Goal: Perform arithmetic or address computations.
Details: Handles operations like integer multiplication, floating-point subtraction, and address calculation for memory access.
Memory Access (MEM)
Goal: Read from or write to data memory (if required).
Details: Applies to load/store instructions; others skip this phase.
Write Back (WB)
Goal: Store the result in the register file or memory.
Details: Final results from ALU or memory are written to their destination (e.g., registers), completing the instruction lifecycle.

Key Features
Structured Execution Model: Simulates instruction flow through a five-stage pipeline design, aiding conceptual understanding of pipelined processors.
Step-by-Step Processing: Instructions are executed one at a time, with each stage clearly represented.
MIPS Instruction Support: Handles key MIPS operations used in tasks such as:
Insertion Sort
Floating Point Subtraction
Integer Multiplication
