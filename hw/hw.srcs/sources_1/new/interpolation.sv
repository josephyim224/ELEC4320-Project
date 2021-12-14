`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2021 04:40:58 PM
// Design Name: 
// Module Name: interpolation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module interpolation(
    input wire dx,
    input wire dy,
    input clk,
    output reg val
    );
    real sx, sy, sx_0, sy_0, sx_1, sy_1, r_x, r_y, x_0, x_1;
    
    always @(posedge clk)
    begin
        //Stage 1
        sx <= dx * 100 / 140;
        sy <= dy * 100 / 140;
        $display("dx: ",dx);
        $display("dy: ",dy);
        $display("sx: ",sx);
        $display("sy: ",sy);
        
        //Stage 2
        sx_0 <= $floor(sx);
        sx_1 <= $ceil(sx);
        sy_0 <= $floor(sy);
        sy_1 <= $ceil(sy);
        r_x  <= sx - sx_0;
        r_y  <= sy - sy_0;
        $display("r_x: ",r_x);
        $display("r_y: ",r_y);
        
        //Stage 3 (10,20,1,2 are place holders of mem(*)
        x_0  <= r_x * 10 + (1-r_x) * 20;
        x_1  <= r_x * 1 + (1-r_x) * 2;
        $display("x_0: ",x_0);
        $display("x_1: ",x_1);
        
        //Stage 4
        val  <= r_y * x_0 + (1-r_y) * x_1;
        $display("val: ", val);
    end
    
endmodule