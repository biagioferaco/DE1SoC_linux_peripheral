# DE1SoC Linux Peripheral for HEVC
Master's Degree Thesis: An Hardware Accelerator for HEVC implemented on a DE1SoC FPGA 

## Introduction
HEVC (High Efficiency Video Coding), the most recent standard for video
compression, has led to an huge increase of the encoding efficiency with the
respect to the previous standards but, on the other hand, several tasks have
became highly time demanding and power consuming.
The HEVC encoder doubled the coding efficiency without affecting the quality,
but increased exponentially the computational cost.
According to the standard, the encoder, at every cycle, selects a frame from the
input stream and subdivide it into partitions of blocks.
Forn each of those block is then performed a prediction with **Intra** or
**Inter** prediction. The first technique performs a comparison between
blocks in the same picture and, thus, remove spatial redundancy.
The second technique, instead, compares blocks of samples present in different
frames, exploiting motion compensation and reducing temporal redundancy.
This thesis proposes, therefore, a fast, dynamically reconfigurable and flexible
hardware accelerator for the SATD (Sum of Absolute Transformed Differences),
that is one of the cost functions adopted by HM HEVC reference software in both
the prediction techniques (Intra Prediction search and Fractional Motion
Estimation).

## DE1-SoC and Quartus Prime
The entire project started with the purpose of the final implementation on a
FPGA. The system that was selected was the **DE1-SoC Development Kit**.

In this system is included an Intel Altera System-on-Chip
(SoC) FPGA, which contains a dual-core Cortex-A9 embedded cores. The SoC
includes two parts: the effective FPGA chip and the HPS, that includes the
processor and the levels of cache, and all the interfaces.
In addition two external DDR RAM memory are present in the system.

The board contains:
1. USB to UART (for the command-line interface);
2. 1GB (2x256Mx16) DDR3 SDRAM on HPS;
3. Micro SD Card Socket on HPS (to store the Linux OS);

The FPGA chip mounted on the board is a Cyclone V that consists of an Hard
Processor System (HPS) and FPGA are combined togheter in the same chip.

# Architecture Description
The developed architecture is an hardware peripheral fully compatible with the
interfaces to the ARM processor able to compute the SATD operation on block sizes
based on 8x8 block.
SATD is a metric to estimate distortion between two blocks for mode decision
(Rate-Distortion Optimization) in video encoding and it consists in the product of
the block under evaluation with the Hadamrd matrix, the absolute value of each
coefficient and the final sum.
Therefore, the main idea of this work was to create an accelerator that handle this
computation and, since the architecture works on different matrix dimensions, it takes different
clock cycles to calculate the result, varying from a minimum delay with 8x8 size
to a maximum for 64x64 size.

##Architecture Structure
The architecture is divided into two parts:
* **Datapath**:
it contains the memories to store and it is both parallelized and pipelined in order to
increase the performances and satisfy the constaints of the resources.
* **Control Unit**:
it contains the FSM that manages the pipeline inside
the Datapath, and also controls the interface with the LW Bridge.

## How to create a Linux Peripheral
Using **Platform Designer** it was possible to create the exact environment in which insert the
design. By the graphical user interface it is possible to interconnect your custom
design to the bridges and also to add configurable components from the IP
libraries of the software.

\includegraphics[width=\textwidth]{images/interconnections.png}

### Creation of the custom component
The custom component has to include the necessary interfaces in order to comunicate with
both the FPGA and the HPS. Platform Designer contains several templates of communication
interfaces. When you choose one of those, you can create a blank VHDL/Verilog file, that will
contain the architecture. In my case it is the top entity for the accelerator.


The next step, after that everything has been connected, is to generate the subsystem.

## Steps:
###Creation of a New Project:
* **File** -> **New Project Wizard** -> **Next**.
* Define the directory of the and the name of the project -> **Next**.
* Select "**Empty Project**" -> **Next**.
* If you do not have files to add to the project, go **Next**.
* Select the FPGA Model of your developer kit (in case of DE1-SoC is C...) -> **Next**.
* (No EDA Tools) Select **Next** and then **Finish**.

###Creation of an HPS Subsystem:
* **File** -> **Tools** -> **Platform Designer** (**Qsys** in the previous version of Quartus).
* From the IP Catalog it is possible to add all the





