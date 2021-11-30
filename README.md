# ELEC4320-Project

# Communication Protocol
| Code from Processing | FPGA action | FPGA response |
| --- | --- | --- |
| 8'd1x | set scaling factor x<br>0:0.6<br>1:0.8<br>2:1.2<br>3:1.4 | 8'd1 |
| 8'd2x + <3x100 bytes> | set one row of input image<br>x is #th of row<br>sample: [R0,G0,B0,R1,G1,B1,...] | 8'd2<br>(after receiving the row) |
| 8'd3 | initiate image processing | 8'd3 (upon receiving)<br> 8'd4 (upon completion) |
| 8'd4x | read one row of output image<br>x is #th of row<br>sample: [R0,G0,B0,R1,G1,B1,...] | <3x100 bytes> |