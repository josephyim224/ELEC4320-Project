`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2021 00:21:47
// Design Name: 
// Module Name: result_mem
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

module result_mem(
    input i_clk_100MHz,
    input [15:0] i_Addr,
    
    input [7:0] i_Din_R,
    input [7:0] i_Din_G,
    input [7:0] i_Din_B,
    
    input [0:0] i_We_R,
    input [0:0] i_We_G,
    input [0:0] i_We_B,
    
    output [7:0] o_Dout_R,
    output [7:0] o_Dout_G,
    output [7:0] o_Dout_B
);

mem_result_image RESULT_IMAGE_R(
    .clka(i_clk_100MHz),
    .addra(i_Addr),
    .douta(o_Dout_R),
    .dina(i_Din_R),
    .wea(i_We_R)

);

mem_result_image RESULT_IMAGE_G(
    .clka(i_clk_100MHz),
    .addra(i_Addr),
    .douta(o_Dout_G),
    .dina(i_Din_G),
    .wea(i_We_G)
);

mem_result_image RESULT_IMAGE_B(
    .clka(i_clk_100MHz),
    .addra(i_Addr),
    .douta(o_Dout_B),
    .dina(i_Din_B),
    .wea(i_We_B)
);

endmodule
