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
    input [1:0][7:0] i_Din,
    input [1:0][0:0] i_We,
    output [1:0][7:0] o_Dout
);

generate
    genvar color;
    for (color=0;color<3;color=color+1) begin
        mem_result_image RESULT_IMAGE(
            .clka(i_clk_100MHz),
            .addra(i_Addr),
            .douta(o_Dout[color]),
            .dina(i_Din[color]),
            .wea(i_We[color])
        );
    end
endgenerate

endmodule
