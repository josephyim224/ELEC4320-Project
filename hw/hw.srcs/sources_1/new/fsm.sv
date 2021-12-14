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

integer color, channel;
`define LOOP_COLOR for (color=0;color<3;color=color+1)
`define LOOP_CHANNEL for (channel=0;channel<4;channel=channel+1)

module fsm(
    input i_clk_100MHz,
    output [15:0] o_led,

    output reg [1:0][13:0] o_Source_Mem_Addr = 0,
    output reg [1:0][1:0][7:0] o_Source_Mem_Din = 0,
    output reg [1:0][1:0][0:0] o_Source_Mem_We = 0,
    input [1:0][1:0][7:0] i_Source_Mem_Dout,

    output reg [15:0] o_Result_Mem_Addr = 0,
    output reg [1:0][7:0] o_Result_Mem_Din = 0,
    output reg [1:0][0:0] o_Result_Mem_We = 0,
    input [1:0][7:0] i_Result_Mem_Dout,

    output o_Tx_DV,
    output reg [7:0] o_Tx_Byte = 0,
    input i_Tx_Active,

    input i_Rx_Dv,
    input [7:0] i_Rx_Byte
);

parameter s_IDLE = 3'b000;
parameter s_SET_SCALE_FACTOR = 3'b001;
parameter s_SET_WRITE_ROW_NUMBER = 3'b010;
parameter s_SET_WRITE_ROW = 3'b011;
parameter s_PROCESS = 3'b100;
parameter s_SET_SEND_ROW_NUMBER = 3'b101;
parameter s_SEND_ROW  = 3'b110;

reg [2:0] r_SM_Main = 0;
reg [1:0] r_Scale_Factor = 0;
reg [1:0] r_Color = 0;
reg [15:0] r_Mem_Counter = 0;
reg [2:0] r_Tx_Delay = 0;

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

always @(posedge i_clk_100MHz) begin
    r_Tx_DV_Prev <= r_Tx_DV;

    `LOOP_COLOR `LOOP_CHANNEL
        if (o_Source_Mem_We[channel][color]) o_Source_Mem_We[channel][color] <= 1'b0;

    if (r_Tx_Delay != 0) r_Tx_Delay <= r_Tx_Delay-1;

    if (r_SM_Main != s_PROCESS)
        `LOOP_COLOR o_Result_Mem_We[color] <= 1'b0;

    case (r_SM_Main)
        s_IDLE:
            begin
                if (i_Rx_Dv)
                    case (i_Rx_Byte)
                        8'd0:
                        begin
                            o_Tx_Byte <= 8'd0;
                            r_Tx_DV <= r_Tx_DV+1;
                        end
                        8'd1:
                        begin
                            r_SM_Main <= s_SET_SCALE_FACTOR;
                            o_Tx_Byte <= 8'd1;
                            r_Tx_DV <= r_Tx_DV+1;
                        end
                        8'd2: 
                        begin
                            r_SM_Main <= s_SET_WRITE_ROW_NUMBER;
                            o_Tx_Byte <= 8'd2;
                            r_Tx_DV <= r_Tx_DV+1;
                        end
                        8'd3:
                        begin
                            r_SM_Main <= s_PROCESS;

                            r_Mem_Counter <= 0;
                            o_Source_Mem_Addr[0] <= 0;
                            o_Source_Mem_Addr[1] <= 0;
                            o_Result_Mem_Addr <= 0;

                            o_Tx_Byte <= 8'd3;
                            r_Tx_DV <= r_Tx_DV+1;
                        end
                        8'd4: r_SM_Main <= s_SET_SEND_ROW_NUMBER;
                    endcase
             end
        s_SET_SCALE_FACTOR:
            begin
                if (i_Rx_Dv)
                    begin
                        r_Scale_Factor <= i_Rx_Byte[1:0];
                        r_SM_Main <= s_IDLE;
                    end
            end
        s_SET_WRITE_ROW_NUMBER:
            begin
                if (i_Rx_Dv)
                    begin
                        o_Source_Mem_Addr[0] <= 100 * i_Rx_Byte;
                        r_Color <= 0;
                        r_Mem_Counter <= 0;
                        r_SM_Main <= s_SET_WRITE_ROW;
                    end
            end
       s_SET_WRITE_ROW:
            begin
                if (i_Rx_Dv)
                    begin
                        case (r_Color)
                            0:
                            begin
                                o_Source_Mem_We[0][0] <= 1'b1;
                                o_Source_Mem_Din[0][0] <= i_Rx_Byte | 8'b0;
                                r_Color <= 1;
                            end
                            1:
                            begin
                                o_Source_Mem_We[0][1] <= 1'b1;
                                o_Source_Mem_Din[0][1] <= i_Rx_Byte | 8'b0;
                                r_Color <= 2;
                            end
                            2:
                            begin
                                o_Source_Mem_We[0][2] <= 1'b1;
                                o_Source_Mem_Din[0][2] <= i_Rx_Byte | 8'b0;;
                                r_Color <= 0;

                                if (r_Mem_Counter == 99) r_SM_Main = s_IDLE;
                                r_Mem_Counter <= r_Mem_Counter+1;
                                o_Source_Mem_Addr[0] <= o_Source_Mem_Addr[0]+1;
                            end
                        endcase
                    end
            end
       s_PROCESS:
            begin
                o_Result_Mem_Din[0] <= i_Source_Mem_Dout[0][0];
                o_Result_Mem_Din[1] <= i_Source_Mem_Dout[0][1];
                o_Result_Mem_Din[2] <= i_Source_Mem_Dout[0][2];

                `LOOP_COLOR o_Result_Mem_We[color] <= 1'b1;

                o_Source_Mem_Addr[0] <= o_Source_Mem_Addr[0] + 1;

                if (o_Source_Mem_Addr[0] == 10000) 
                begin
                    r_SM_Main = s_IDLE;

                    o_Tx_Byte <= 8'd4;
                    r_Tx_DV <= r_Tx_DV+1;
                end

                if (r_Mem_Counter == 99)
                    begin
                        r_Mem_Counter <= 0;
                        o_Result_Mem_Addr <= o_Result_Mem_Addr + 1 + 40;
                    end
                else
                    begin
                        r_Mem_Counter <= r_Mem_Counter+1;
                        o_Result_Mem_Addr <= o_Result_Mem_Addr + 1;
                    end
            end
        s_SET_SEND_ROW_NUMBER:
            begin
                if (i_Rx_Dv)
                    begin
                        o_Result_Mem_Addr <= 140 * i_Rx_Byte;
                        r_SM_Main <= s_SEND_ROW;
                        r_Color <= 0;
                        r_Mem_Counter <= 0;
                    end
            end
        s_SEND_ROW:
            begin
                if (!i_Tx_Active && r_Tx_Delay == 0)
                    begin
                        case (r_Color)
                            0:
                            begin
                                o_Tx_Byte <= i_Result_Mem_Dout[0];
                                r_Tx_DV <= r_Tx_DV+1;
                                r_Tx_Delay <= 8'b111;
                                r_Color <= 1;
                            end
                            1:
                            begin
                                o_Tx_Byte <= i_Result_Mem_Dout[1];
                                r_Tx_DV <= r_Tx_DV+1;
                                r_Tx_Delay <= 8'b111;
                                r_Color <= 2;
                            end
                            2:
                            begin
                                o_Tx_Byte <= i_Result_Mem_Dout[2];
                                r_Tx_DV <= r_Tx_DV+1;
                                r_Tx_Delay <= 8'b111;
                                r_Color <= 0;

                                if (r_Mem_Counter == 139) r_SM_Main = s_IDLE;
                                r_Mem_Counter <= r_Mem_Counter+1;
                                o_Result_Mem_Addr <= o_Result_Mem_Addr+1;
                            end
                        endcase
                    end
            end
    endcase
end

endmodule
