`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2021 13:25:36
// Design Name: 
// Module Name: source_mem
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

// [channel][color][bits]

module source_mem(
    input i_clk_100MHz,
    input [1:0][13:0] i_Addr,
    input [1:0][1:0][7:0] i_Din,
    input [1:0][1:0][0:0] i_We,
    output [1:0][1:0][7:0] o_Dout
);

generate
    genvar color;
    for (color=0;color<3;color=color+1) begin
        mem_source_image SOURCE_IMAGE_A(
            .clka(i_clk_100MHz),
            .clkb(i_clk_100MHz),

            .addra(i_Addr[0]),
            .douta(o_Dout[0][color]),
            .dina(i_Din[0][color]),
            .wea(i_We[0][color]),

            .addrb(i_Addr[1]),
            .doutb(o_Dout[1][color]),
            .dinb(i_Din[1][color]),
            .web(i_We[1][color])
        );

        mem_source_image SOURCE_IMAGE_B(
            .clka(i_clk_100MHz),
            .clkb(i_clk_100MHz),

            .addra(i_Addr[2]),
            .douta(o_Dout[2][color]),
            .dina(i_Din[2][color]),
            .wea(i_We[2][color]),

            .addrb(i_Addr[3]),
            .doutb(o_Dout[3][color]),
            .dinb(i_Din[3][color]),
            .web(i_We[3][color])
        );
    end
endgenerate

endmodule
