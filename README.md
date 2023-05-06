# Non Von Neumann 4-bit Processor
Yuhe Zheng
18-224/624 Spring 2023 Final Tapeout Project
## Overview
A 4-bit microprocessor that takes 12-bit instructions as input and outputs 4-bit calculation results represented in 12 output pins. The processor computes a series 
of instructions over an array of processing elements. It supports simple bitwise calculations including and, or, and shifting.

## How it Works
The processor contains a scheduler and a series of processing elements. The number of processing elements is bounded by the size limit of the chip and the 4-bit operand size. Each processing element can take two input operands, either from the immediate value within the instruction or from the output of other processing elements. The scheduler decodes an incoming instruction and set matching control signals to the next available PE. When all the PEs are occupied, the scheduler clears a PE by latching its old output into a register, and assign it to perform new calculation. When a program finishes running, the 4-bit result of the program is available at the output of the processor.
![Process Element Diagram](/Processing_Element_diagram.jpeg)
![Processor Diagram](/Processor_Diagram.jpeg)
## Inputs/Outputs
The design has 12 input pins and 12 output pins. 

The 12 inputs represent the current instruction of a program. It is partitioned into three parts: inputs[0:4] encodes the first operand, inputs[4:8] encodes the second operand, and inputs[8:12] encodes the opcode of the instruction. Each operand can represent a 4-bit immediate value, or select a PE’s result.
The 12 outputs contain the output of the program. The least significant 4-bit of the output is the result of the program’s computation, and the rest of the output pins are set to 0.

## Design Testing / Bringup
The design is tested by using software to drive a series a instruction to the processor. When the program terminates by a terminating instruction, the result of the computation should appear on the output pins of the processor. For simulation, the testbench should contain the instructions driven into the processor one at a clock cycle. 

