# RISC-V Processor Design Project

## Overview
This repository contains Verilog implementations and testbenches for a series of exercises related to designing and implementing components of a RISC-V processor. The project focuses on essential modules such as an ALU, a calculator, a register file, a datapath, and a finite state machine (FSM)-based controller.

## Modules Implemented
1. **ALU (alu.v)**:
   - A 32-bit Arithmetic Logic Unit supporting operations such as addition, subtraction, bitwise logic, comparisons, and shifts.

2. **Calculator (calc.v, calc_enc.v)**:
   - A 16-bit accumulator-based calculator using the ALU to perform operations controlled by input signals.

3. **Register File (regfile.v)**:
   - A 32 × 32-bit register file supporting concurrent reads and writes.

4. **Datapath (datapath.v)**:
   - Implements the core logic for processing RISC-V instructions, including instruction fetch, decode, execute, memory access, and write-back stages.

5. **FSM-Based Controller (top_proc.v)**:
   - A multi-cycle finite state machine coordinating the execution of instructions.

## Features
- Support for RISC-V instructions:
  - Register-Register: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLT`, `SLL`, `SRL`, `SRA`
  - ALU Immediate: `ADDI`, `ANDI`, `ORI`, `XORI`, `SLTI`, `SLLI`, `SRLI`, `SRAI`
  - Memory: `LW`, `SW`
  - Branch: `BEQ`
- Verilog testbenches for validation of each module.

## File Structure

├── alu.v              # Arithmetic Logic Unit module
├── calc.v             # Calculator module
├── calc_enc.v         # Encoder for calculator operations
├── calc_tb.v          # Testbench for the calculator
├── regfile.v          # Register file module
├── datapath.v         # Datapath implementation
├── top_proc.v         # FSM-based processor controller
├── top_proc_tb.v      # Testbench for the top-level processor
├── .gitignore         # Optional: Git ignore file for simulation outputs
└── README.md          # Project documentation
.
├── dir1
│   ├── file11.ext
│   └── file12.ext
├── dir2
│   ├── file21.ext
│   ├── file22.ext
│   └── file23.ext
├── dir3
├── file_in_root.ext
└── README.md
