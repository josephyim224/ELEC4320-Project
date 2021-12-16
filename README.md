# ELEC4320-Project

This project builds a FPGA implementing bilinear interpolation resizing RGB image from 100x100 to 60x60, 80x80, 120x120, 140x140.

# FPGA Overview

Since communication between PC and FPGA is expected, a Finite State Machine is included to provide state control for other modules. The components:

![](/documentation/components.png)

On the FPGA side,
1. UART: communicate with the PC side
1. Finite State Machine (FSM): receive command from UART and change state accordingly. Each state change will trigger execution of other modules
1. LEDs: state indicator for debugging
1. Source memory A and B: 100x100xRGBx2 dual port block memory for storing input image, in total providing 4 concurrent access to source memory
1. Interpolation processor: pipelined interpolation processor
Result memory: 140x140xRGB block memory for storing result image

On the PC side,
1. UI: interaction with the FPGA by UART

# FPGA Components and State Diagram

1. UART

    For quick development, the UART verilog code is from http://www.nandland.com.

1. Source memory
    
    During bilinear interpolation, one pixel in the result image requires interpolation during the nearest 4 pixels in the source image. To facilitate pipelined computation, two dual port block ram of 100x100 bytes are set up for each RGB channel.

    When receiving source image from UART, both port A of the two dual port memory are used to write incoming bytes concurrently.

1. Result memory

    Since the memory receives one byte at a time, a single port block ram of 140x140 bytes are set up for each RGB channel.

1. FSM implementation

    The FSM needs to coordinate the following events:
    1. receive image from PC and store to source memory
    1. receive image resizing scale factor from PC
    1. start interpolation processor
    1. send result image to PC
    1. clear result image memory

    As a result, it includes the following 6 states (including idle) and transitions:


![](/documentation/state.png)

# Communication Protocol

All the state changes are initiated by UART command from the PC, and returns to idle state once the task is performed. The communication protocol is as shown below:

| Command from PC | FPGA action | FPGA response |
| --- | --- | --- |
| 8'd0 | reset | 8'd0 |
| 8'd1 + 8'dx | set scaling factor x<br>0:0.6<br>1:0.8<br>2:1.2<br>3:1.4 | 8'd1 |
| 8'd2 + 8'dx + <3x100 bytes> | set one row of input image<br>x is #th of row<br>sample: [R0,G0,B0,R1,G1,B1,...] | 8'd2 (after receiving the row)<br>8'd6 (after receiving the whole image) |
| 8'd3 | initiate image processing | 8'd3 (upon receiving)<br> 8'd4 (upon completion) |
| 8'd4 + 8'dx | read one row of output image<br>x is #th of row<br>sample: [R0,G0,B0,R1,G1,B1,...] | <3x140 bytes> |
| 8'd5 | clear result memory | 8'd5 |

# Interpolation Pipeline

During actual computation, due to timing constraints, a 8 stage pipeline is used as shown below.

In the pipeline, dx[8:0] and dy[8:0] are used to hold the destination pixels and range from 0 to the result image dimension. The pipeline will terminate when dx[8] and dx[y] meet the end of the result image dimension.

![](/documentation/pipeline.png)

Meanwhile, since floating point operation is not supported, values related with such operations are stored as integers and enlarged by 100 during computation. When the decimal is required, the values are modulo by 100 to get the decimal part.

# LED Indicators

| # | Purpose |
| --- | --- |
| 0 | breathing probe |
| 1 | uart: tx |
| 2 | uart: rx |
| 3 | state: idle |
| 4 | state: set scale factor |
| 5 | state: set write row number |
| 6 | state: set write row |
| 7 | state: process |
| 8 | state: set send row number |
| 9 | state: send row |

# Performance

- FPGA clock: 10MHz
- UART baud rate: 230400

- Theoretical time to send source image to FPGA:
	- Total bytes to transfer: 100x100x3 (image) + 2x100 (command) = 30200 bytes
	- Highest transfer rate: 28800 bytes/s
	- Expected time: 1.05 seconds
    - Actual time: ~3 seconds
    - Possible reason: potential cause would be slowing buffering and response waiting on the PC side as the FPGA is only passively receiving image

- Theoretical time to receive result image from FPGA:
	- Total bytes to transfer: 140x140x3 (image) + 2x100 (command) = 59000 bytes
	- Highest transfer rate: 28800 bytes/s
	- Expected time: 2.05 seconds
    - Actual time: ~5 seconds

- Theoretical time to process an image (from 100x100 to 140x140):
	- Stages needed: 140x140 + (8-1) = 19607
	- Per stage time: 1/10MHz = 100ns
	- Expected time: 19607x10 = 196070ns = 196ms = 0.2s
    - Actual time: similar

# Interpolation Sample

An apple is interpolated from 100x100 to 140x140:
![](/documentation/good_apple_140.png)

# Corrupted Sample

When the FPGA is overclocked from 10MHz to 100MHz (which clearly violates the timing constraint), part of the result image is corrupted:
![](/documentation/corrupted_apple_140.png)

# Repo Structure

- `/documentation`: images and earlier documents
- `/hw`: Vivado 2020.2 Project
- `/img`: test images
- `/ui`: UI implemented by Processing

# Milestones
| Task | Description | Progress |
| --- | --- | --- |
| UI | load image<br>send command<br>send image<br>receive image | ✅ |
| HW set up | | ✅ |
| HW uart | can communicate with host | ✅ |
| HW FSM | state control | ✅ |
| HW image memory | source_image_[R\|G\|B]<br>result_image_[R\|G\|B] | ✅ |
| HW receive, copy, send image | test memory access capability from host | ✅ | HW interpolate | compute interpolate parameters<br>can use verilog sim | ✅ |
| HW interpolate | design pipeline | ✅ |
| HW interpolate | receive interpolate parameters | ✅ |
| HW interpolate image | compute | ✅ |
| Report and Slide | | ✅ |

# Misc
| Task | Description | Progress |
| --- | --- | --- |
| check mem | mem has a read latency of 2 cycles, what's the impact? | |
| UI image border | border currently overlaps with image | |
| HW | break top.v into modules | ✅ |
| UART | try speed faster than 115200 | ✅ |
| UI | one button finish all | |
| UI | image hot reload | ✅ |
| UI | support reset | |