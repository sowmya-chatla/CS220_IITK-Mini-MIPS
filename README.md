# IITK-Mini-MIPS

This project was submitted as part of coursework for **CS220: Computer Organization** during Semester II, 2024–25 at **IIT Kanpur**.  

---

## Overview
**IITK-Mini-MIPS** is a simulation tool built to interpret and execute **MIPS assembly code**.  
It models the behavior of a processor using a **5-stage pipeline architecture** as a reference framework, but executes instructions step-by-step.  

The project serves as an **educational model** to explore how different stages of instruction processing work in modern processors.

---

## Execution Stages

### 1. Instruction Fetch (IF)
- **Goal:** Retrieve the next instruction from memory using the Program Counter (PC).  
- **Details:** Instruction memory holds a sequence of MIPS instructions, which are fetched and passed on for decoding.  

### 2. Instruction Decode (ID)
- **Goal:** Interpret the instruction and prepare for execution.  
- **Details:** Identifies instruction type (R-type, I-type, J-type), extracts operands, and sets up control signals.  

### 3. Execution / ALU (EX)
- **Goal:** Perform arithmetic or address computations.  
- **Details:** Handles operations like integer multiplication, floating-point subtraction, and address calculation for memory access.  

### 4. Memory Access (MEM)
- **Goal:** Read from or write to data memory (if required).  
- **Details:** Applies to load/store instructions; others skip this phase.  

### 5. Write Back (WB)
- **Goal:** Store the result in the register file or memory.  
- **Details:** Final results from ALU or memory are written to their destination (e.g., registers), completing the instruction lifecycle.  

---

## Key Features
- **Structured Execution Model:** Simulates instruction flow through a five-stage pipeline design, aiding conceptual understanding of pipelined processors.  
- **Step-by-Step Processing:** Instructions are executed one at a time, with each stage clearly represented.  
- **MIPS Instruction Support:** Implements key MIPS operations, including:  
  - Insertion Sort  
  - Floating-Point Subtraction  
  - Integer Multiplication  

---

## Future Improvements
- Extend support for parallel pipelined execution.  
- Add hazard detection and forwarding mechanisms.  

---

## Tech Stack
- **Language:** Verilog HDL  
- **Tools:** Xilinx Vivado (for simulation & synthesis)  
- **Hardware:** FPGA Board  

---
