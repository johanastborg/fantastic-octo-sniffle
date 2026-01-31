# Fantastic Octo Sniffle - MIPS 32-bit Clone

This project implements a 32-bit MIPS-compatible processor targeting Xilinx Virtex 5 FPGA. It features a classic 5-stage pipeline architecture with hazard detection and forwarding.

## Project Structure

```
├── src/                    # VHDL Source Files
│   ├── mips_top.vhd        # Top-level entity
│   ├── alu.vhd             # Arithmetic Logic Unit
│   ├── reg_file.vhd        # Register File
│   ├── control_unit.vhd    # Control Unit
│   ├── program_counter.vhd # Program Counter
│   ├── instruction_memory.vhd # Instruction Memory (w/ Test Program)
│   ├── data_memory.vhd     # Data Memory
│   ├── hazard_unit.vhd     # Hazard Detection Unit
│   ├── forwarding_unit.vhd # Forwarding Unit
│   ├── if_id.vhd           # IF/ID Pipeline Register
│   ├── id_ex.vhd           # ID/EX Pipeline Register
│   ├── ex_mem.vhd          # EX/MEM Pipeline Register
│   └── mem_wb.vhd          # MEM/WB Pipeline Register
├── test/                   # Testbenches
│   └── tb_mips_top.vhd     # Top-level Testbench
└── README.md
```

## Features

- **5-Stage Pipeline**: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory (MEM), Write Back (WB).
- **Hazard Handling**:
    - **Data Hazards**: Solved via a Forwarding Unit (EX to ID, MEM to ID).
    - **Load-Use Hazards**: Handled by a Hazard Detection Unit that inserts bubbles (stalls).
- **Instruction Set**: Supports a subset of MIPS32 instructions including:
    - R-Type: `ADD`, `SUB`, `AND`, `OR`, `SLT`, `NOR`
    - I-Type: `LW`, `SW`, `BEQ`, `ADDI`
    - J-Type: `J` (Jump)

## Verification

A test program is pre-loaded into the `InstructionMemory` component for verification.

To run the simulation:
1. Compile all files in `src/`.
2. Compile `test/tb_mips_top.vhd`.
3. Run the simulation using a VHDL simulator (e.g., GHDL, Vivado XSim, ModelSim).
