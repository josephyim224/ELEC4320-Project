`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2021 15:04:03
// Design Name: 
// Module Name: fsm
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

integer color, channel, i;
`define LOOP_COLOR for (color=0;color<3;color=color+1)
`define LOOP_CHANNEL for (channel=0;channel<4;channel=channel+1)

module fsm(
    input i_clk,
    output [15:0] o_led,

    output reg [3:0][13:0] o_Source_Mem_Addr = 0,
    output reg [3:0][2:0][7:0] o_Source_Mem_Din = 0,
    output reg [3:0][2:0][0:0] o_Source_Mem_We = 0,
    input [3:0][2:0][7:0] i_Source_Mem_Dout,

    output reg [15:0] o_Result_Mem_Addr = 0,
    output reg [2:0][7:0] o_Result_Mem_Din = 0,
    output reg [2:0][0:0] o_Result_Mem_We = 0,
    input [2:0][7:0] i_Result_Mem_Dout,

    output o_Tx_DV,
    output reg [7:0] o_Tx_Byte = 0,
    input i_Tx_Active,

    input i_Rx_Dv,
    input [7:0] i_Rx_Byte,
    
    output [2:0] o_SM_Main
);

`include "fsm_header.vh"

reg [2:0] r_SM_Main = 0;
integer r_Result_Dim = 60;
reg [1:0] r_Color = 0;
reg [15:0] r_Mem_Counter = 0;
reg [2:0] r_Tx_Delay = 0;

assign o_SM_Main = r_SM_Main;

assign o_led[3] = r_SM_Main == s_IDLE;
assign o_led[4] = r_SM_Main == s_SET_SCALE_FACTOR;
assign o_led[5] = r_SM_Main == s_SET_WRITE_ROW_NUMBER;
assign o_led[6] = r_SM_Main == s_SET_WRITE_ROW;
assign o_led[7] = r_SM_Main == s_PROCESS;
assign o_led[8] = r_SM_Main == s_SET_SEND_ROW_NUMBER;
assign o_led[9] = r_SM_Main == s_SEND_ROW;

reg [1:0] r_Tx_DV = 1'b1;
reg [1:0] r_Tx_DV_Prev = 1'b0;
assign o_Tx_DV = r_Tx_DV != r_Tx_DV_Prev;

integer dx[9], dy[9], sx[2], sy[2], sx0, sy0, rx[2], ry[3], rxi, ryi;
integer x0[3], x1[3], out[3], out_left[3], out_right[3];
integer x0_left[3], x0_right[3], x1_left[3], x1_right[3];

reg [2:0][7:0] norm_out;
reg [15:0] out_mem_addr;

always @(posedge i_clk) begin
    r_Tx_DV_Prev <= r_Tx_DV;
    
    if (r_Tx_Delay != 0) r_Tx_Delay <= r_Tx_Delay-1;

    if (r_SM_Main != s_SET_WRITE_ROW) `LOOP_COLOR `LOOP_CHANNEL
        if (o_Source_Mem_We[channel][color]) o_Source_Mem_We[channel][color] <= 1'b0;

    if ((r_SM_Main != s_PROCESS) && (r_SM_Main != s_CLEAR_RESULT))
        `LOOP_COLOR o_Result_Mem_We[color] <= 1'b0;

    case (r_SM_Main)
        s_IDLE:
            if (i_Rx_Dv) begin
                case (i_Rx_Byte)
                    8'd0:
                    begin
                        o_Tx_Byte <= 8'd0;
                        r_Tx_DV <= r_Tx_DV+1;
                    end
                    c_SET_SCALE_FACTOR:
                    begin
                        r_SM_Main <= s_SET_SCALE_FACTOR;
                        o_Tx_Byte <= 8'd1;
                        r_Tx_DV <= r_Tx_DV+1;
                    end
                    c_SET_WRITE_ROW_NUMBER: 
                    begin
                        r_SM_Main <= s_SET_WRITE_ROW_NUMBER;
                        o_Tx_Byte <= 8'd2;
                        r_Tx_DV <= r_Tx_DV+1;
                    end
                    c_PROCESS:
                    begin
                        r_SM_Main <= s_PROCESS;

                        o_Tx_Byte <= 8'd3;
                        r_Tx_DV <= r_Tx_DV+1;

                        for (i=0;i<9;i=i+1) begin
                            dx[i] <= 0;
                            dy[i] <= 0;
                        end
                    end
                    c_SET_SEND_ROW_NUMBER: r_SM_Main <= s_SET_SEND_ROW_NUMBER;
                    c_CLEAR_RESULT: begin
                        r_SM_Main <= s_CLEAR_RESULT;
                        o_Result_Mem_Addr <= 0;
                    end
                endcase
            end
        s_SET_SCALE_FACTOR:
            if (i_Rx_Dv) begin
                case (i_Rx_Byte)
                0: r_Result_Dim <= 60;
                1: r_Result_Dim <= 80;
                2: r_Result_Dim <= 120;
                3: r_Result_Dim <= 140;
                endcase 
                r_SM_Main <= s_IDLE;
            end
        s_SET_WRITE_ROW_NUMBER:
            if (i_Rx_Dv) begin
                o_Source_Mem_Addr[0] <= 100 * i_Rx_Byte;
                o_Source_Mem_Addr[2] <= 100 * i_Rx_Byte;
                r_Color <= 0;
                r_Mem_Counter <= 0;
                r_SM_Main <= s_SET_WRITE_ROW;
            end
       s_SET_WRITE_ROW:
            if (i_Rx_Dv) begin
                `LOOP_COLOR if (r_Color == color) begin
                    o_Source_Mem_We[0][color] <= 1'b1;
                    o_Source_Mem_Din[0][color] <= i_Rx_Byte | 8'b0;
                    o_Source_Mem_We[2][color] <= 1'b1;
                    o_Source_Mem_Din[2][color] <= i_Rx_Byte | 8'b0;
                    r_Color <= (r_Color+1)%3;
                end

                if (r_Color==2) begin
                    if (r_Mem_Counter == 99) begin 
                        r_SM_Main = s_IDLE;
                        if (o_Source_Mem_Addr[0] == 100*100-1) begin
                            o_Tx_Byte <= 8'd6;
                            r_Tx_DV <= r_Tx_DV+1;
                        end
                    end
                    r_Mem_Counter <= r_Mem_Counter+1;
                    o_Source_Mem_Addr[0] <= o_Source_Mem_Addr[0]+1;
                    o_Source_Mem_Addr[2] <= o_Source_Mem_Addr[2]+1;
                end                
            end
       s_PROCESS:
            begin           
                // coordinate increment
                if (dx[0] != r_Result_Dim-1) dx[0] <= dx[0]+1;
                else if (dy[0] != r_Result_Dim-1) begin 
                    dx[0] <= 0;
                    dy[0] <= dy[0]+1;
                end // else do nth
                
                // calculate sx and sy - 1
                sx[0] <= dx[0] * 10000;
                sy[0] <= dy[0] * 10000;
                
                dx[1] <= dx[0];
                dy[1] <= dy[0];
                
                // calculate sx and sy - 2
                sx[1] <= sx[0] / r_Result_Dim;
                sy[1] <= sy[0] / r_Result_Dim;
                
                dx[2] <= dx[1];
                dy[2] <= dy[1];

                // calculate sx0, sy0
                sx0 <= sx[1] / 100;
                sy0 <= sy[1] - sy[1] % 100;
                rx[0] <= sx[1] % 100;
                ry[0] <= sy[1] % 100;
                
                dx[3] <= dx[2];
                dy[3] <= dy[2];

                // read source memory
                o_Source_Mem_Addr[0] <= sy0 + sx0;
                o_Source_Mem_Addr[1] <= sy0 + sx0 +1;
                o_Source_Mem_Addr[2] <= sy0 + sx0 +100;
                o_Source_Mem_Addr[3] <= sy0 + sx0 +101;

                rx[1] <= rx[0];
                ry[1] <= ry[0];
                rxi <= 100 - rx[0];

                dx[4] <= dx[3];
                dy[4] <= dy[3];

                // compute horizontal interpolation - 1
                `LOOP_COLOR begin
                    x0_left[color] <= i_Source_Mem_Dout[0][color] * rxi;
                    x0_right[color] <= i_Source_Mem_Dout[1][color] * rx[1];
                    x1_left[color] <= i_Source_Mem_Dout[2][color] * rxi;
                    x1_right[color] <= i_Source_Mem_Dout[3][color] * rx[1];
                end
                
                ry[2] <= ry[1];
                
                dx[5] <= dx[4];
                dy[5] <= dy[4];

                // compute horizontal interpolation - 2
                `LOOP_COLOR begin
                    x0[color] <= (x0_left[color] + x0_right[color]) / 100;
                    x1[color] <= (x1_left[color] + x1_right[color]) / 100;
                end
                
                ry[3] <= ry[2];
                ryi <= 100 - ry[2];

                dx[6] <= dx[5];
                dy[6] <= dy[5];

                // compute vertical interpolation - 1
                `LOOP_COLOR begin
                    out_left[color] <= x0[color] * (100-ry[3]);
                    out_right[color] <= x1[color] * ry[3];
                end
                
                dx[7] <= dx[6];
                dy[7] <= dy[6];

                // compute vertical interpolation - 2
                `LOOP_COLOR out[color] <= (out_left[color] + out_right[color]) / 100;
                out_mem_addr <= dy[6] * 140 + dx[6];

                dx[8] <= dx[7];
                dy[8] <= dy[7];

                // save to memory
                o_Result_Mem_Addr <= out_mem_addr;
                `LOOP_COLOR begin
                    o_Result_Mem_Din[color] <= out[color];
                    o_Result_Mem_We[color] <= 1'b1;
                end
                
                // interpolation done
                if (!i_Tx_Active && dx[8] == (r_Result_Dim-1) && dy[8] == (r_Result_Dim-1)) begin
                    r_SM_Main = s_IDLE;

                    o_Tx_Byte <= 8'd4;
                    r_Tx_DV <= r_Tx_DV+1;
                end
            end
        s_SET_SEND_ROW_NUMBER:
            if (i_Rx_Dv) begin
                o_Result_Mem_Addr <= 140 * i_Rx_Byte;
                r_SM_Main <= s_SEND_ROW;
                r_Color <= 0;
                r_Mem_Counter <= 0;
            end
        s_SEND_ROW:
            if (!i_Tx_Active && r_Tx_Delay == 0) begin
                 `LOOP_COLOR if (r_Color == color) begin
                     o_Tx_Byte <= i_Result_Mem_Dout[color];
                     r_Tx_DV <= r_Tx_DV+1;
                     r_Tx_Delay <= 8'b001;
                     r_Color <= (r_Color+1)%3;
                 end

                 if (r_Color==2) begin
                     if (r_Mem_Counter == 139) r_SM_Main = s_IDLE;
                     r_Mem_Counter <= r_Mem_Counter+1;
                     o_Result_Mem_Addr <= o_Result_Mem_Addr+1;
                 end
            end
        s_CLEAR_RESULT:
            if (o_Result_Mem_Addr != 140*140) begin
                `LOOP_COLOR begin
                    o_Result_Mem_Din[color] <= 0;
                    o_Result_Mem_We[color] <= 1'b1;
                end
                o_Result_Mem_Addr <= o_Result_Mem_Addr+1;
            end else if (!i_Tx_Active) begin
                r_SM_Main <= s_IDLE;
                
                o_Tx_Byte <= 8'd5;
                r_Tx_DV <= r_Tx_DV+1;
            end
    endcase
end

endmodule
