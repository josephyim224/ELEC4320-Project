# ELEC4320-Project

# Communication Protocol
| Code from Processing | FPGA action | FPGA response |
| --- | --- | --- |
| 8'd0 | reset | 8'd0 |
| 8'd1x | set scaling factor x<br>0:0.6<br>1:0.8<br>2:1.2<br>3:1.4 | 8'd1 |
| 8'd2x + <3x100 bytes> | set one row of input image<br>x is #th of row<br>sample: [R0,G0,B0,R1,G1,B1,...] | 8'd2<br>(after receiving the row) |
| 8'd3 | initiate image processing | 8'd3 (upon receiving)<br> 8'd4 (upon completion) |
| 8'd4x | read one row of output image<br>x is #th of row<br>sample: [R0,G0,B0,R1,G1,B1,...] | <3x100 bytes> |

# Interpolation Algorithm

TODO

# Milestones
| Task | Description | Progress |
| --- | --- | --- |
| UI | load image<br>send command<br>send image<br>receive image | ✅ |
| HW set up | | ✅ |
| HW uart | can communicate with host | ✅ |
| HW FSM | state control | ✅ |
| HW image memory | source_image_[R\|G\|B]<br>result_image_[R\|G\|B] | ✅ |
| HW receive, copy, send image | test memory access capability from host | ✅ | HW interpolate | compute interpolate parameters<br>can use verilog sim | |
| HW interpolate | design pipeline | |
| HW interpolate | receive interpolate parameters | |
| HW interpolate image | compute | |
| Report and Slide | | |

# Misc
| Task | Description |
| --- | --- |
| check mem | mem has a read latency of 2 cycles, what's the impact? |
| UI image border | border currently overlaps with image |
| HW | break top.v into modules |
| UART | try speed faster than 115200 |
| UI | one button finish all |
| UI | image hot reload |
| UI | support reset |