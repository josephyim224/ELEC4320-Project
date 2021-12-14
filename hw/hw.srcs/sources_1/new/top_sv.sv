`timescale 1ns / 1ns

integer color, channel;
`define LOOP_COLOR for (color=0;color<3;color=color+1)
`define LOOP_CHANNEL for (channel=0;channel<4;channel=channel+1)

module top(clk, led, RsRx, RsTx);

input clk;
input RsRx;
output RsTx;
output [15:0] led;

// --------------------------------------------------------------------------------------

wire clk_100MHz;

clk_wiz_0 CLKGEN(
    .clk_out1(clk_100MHz),
    .reset(),
    .locked(),
    .clk_in1(clk)
);

// --------------------------------------------------------------------------------------

reg r_Tx_DV = 0;
reg [7:0] r_Tx_Byte = 0;
wire w_Tx_Active;

wire w_Rx_Dv;
wire [7:0] w_Rx_Byte;

initial begin
    r_Tx_Byte <= 8'd0;
    r_Tx_DV <= 1'b1;
end

assign led[1] = RsTx != 1;
assign led[2] = RsRx != 1;

uart_rx UART_RX_INST(
    .i_Clock(clk_100MHz),
    .i_Rx_Serial(RsRx),
    .o_Rx_DV(w_Rx_Dv),
    .o_Rx_Byte(w_Rx_Byte)
);

uart_tx UART_TX_INST(
    .i_Clock(clk_100MHz),
    .i_Tx_DV(r_Tx_DV),
    .i_Tx_Byte(r_Tx_Byte),
    .o_Tx_Active(w_Tx_Active),
    .o_Tx_Serial(RsTx),
    .o_Tx_Done()
);

// --------------------------------------------------------------------------------------

breathing_led BREATHING_LED(
    .clk_100MHz(clk_100MHz),
    .led(led[0])
);

// --------------------------------------------------------------------------------------

// [channel][color][bits]
reg [1:0][13:0] r_Source_Mem_Addr = 0;
reg [1:0][1:0][7:0] r_Source_Mem_Din = 0;
reg [1:0][1:0][0:0] r_Source_Mem_We = 0;
wire [1:0][1:0][7:0] w_Source_Mem_Dout;

mem_source_image SOURCE_IMAGE_A_R(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Source_Mem_Addr[0]),
    .douta(w_Source_Mem_Dout[0][0]),
    .dina(r_Source_Mem_Din[0][0]),
    .wea(r_Source_Mem_We[0][0]),

    .addrb(r_Source_Mem_Addr[1]),
    .doutb(w_Source_Mem_Dout[1][0]),
    .dinb(r_Source_Mem_Din[1][0]),
    .web(r_Source_Mem_We[1][0])
);

mem_source_image SOURCE_IMAGE_B_R(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Source_Mem_Addr[2]),
    .douta(w_Source_Mem_Dout[2][0]),
    .dina(r_Source_Mem_Din[2][0]),
    .wea(r_Source_Mem_We[2][0]),

    .addrb(r_Source_Mem_Addr[3]),
    .doutb(w_Source_Mem_Dout[3][0]),
    .dinb(r_Source_Mem_Din[3][0]),
    .web(r_Source_Mem_We[3][0])
);

mem_source_image SOURCE_IMAGE_A_G(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Source_Mem_Addr[0]),
    .douta(w_Source_Mem_Dout[0][1]),
    .dina(r_Source_Mem_Din[0][1]),
    .wea(r_Source_Mem_We[0][1]),

    .addrb(r_Source_Mem_Addr[1]),
    .doutb(w_Source_Mem_Dout[1][1]),
    .dinb(r_Source_Mem_Din[1][1]),
    .web(r_Source_Mem_We[1][1])
);

mem_source_image SOURCE_IMAGE_B_G(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Source_Mem_Addr[2]),
    .douta(w_Source_Mem_Dout[2][1]),
    .dina(r_Source_Mem_Din[2][1]),
    .wea(r_Source_Mem_We[2][1]),

    .addrb(r_Source_Mem_Addr[3]),
    .doutb(w_Source_Mem_Dout[3][1]),
    .dinb(r_Source_Mem_Din[3][1]),
    .web(r_Source_Mem_We[3][1])
);

mem_source_image SOURCE_IMAGE_A_B(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Source_Mem_Addr[0]),
    .douta(w_Source_Mem_Dout[0][2]),
    .dina(r_Source_Mem_Din[0][2]),
    .wea(r_Source_Mem_We[0][2]),

    .addrb(r_Source_Mem_Addr[1]),
    .doutb(w_Source_Mem_Dout[1][2]),
    .dinb(r_Source_Mem_Din[1][2]),
    .web(r_Source_Mem_We[1][2])
);

mem_source_image SOURCE_IMAGE_B_B(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Source_Mem_Addr[2]),
    .douta(w_Source_Mem_Dout[2][2]),
    .dina(r_Source_Mem_Din[2][2]),
    .wea(r_Source_Mem_We[2][2]),

    .addrb(r_Source_Mem_Addr[3]),
    .doutb(w_Source_Mem_Dout[3][2]),
    .dinb(r_Source_Mem_Din[3][2]),
    .web(r_Source_Mem_We[3][2])
);

//source_mem SOURCE_MEM(
//    .i_clk_100MHz(clk_100MHz),
//    .i_Addr(r_Source_Mem_Addr),
//    .i_Din(r_Source_Mem_Din),
//    .i_We(r_Source_Mem_We),
//    .o_Dout(w_Source_Mem_Dout)
//);

reg [15:0] r_Result_Mem_Addr = 0;
reg [1:0][7:0] r_Result_Mem_Din = 0;
reg [1:0][0:0] r_Result_Mem_We = 0;
wire [1:0][7:0] w_Result_Mem_Dout;

result_mem RESULT_MEM(
    .i_clk_100MHz(clk_100MHz),
    .i_Addr(r_Result_Mem_Addr),
    .i_Din(r_Result_Mem_Din),
    .i_We(r_Result_Mem_We),
    .o_Dout(w_Result_Mem_Dout)
);

// --------------------------------------------------------------------------------------

// controller
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

assign led[3] = r_SM_Main == s_IDLE;
assign led[4] = r_SM_Main == s_SET_SCALE_FACTOR;
assign led[5] = r_SM_Main == s_SET_WRITE_ROW_NUMBER;
assign led[6] = r_SM_Main == s_SET_WRITE_ROW;
assign led[7] = r_SM_Main == s_PROCESS;
assign led[8] = r_SM_Main == s_SET_SEND_ROW_NUMBER;
assign led[9] = r_SM_Main == s_SEND_ROW;

always @(posedge clk_100MHz) begin
    if (r_Tx_DV) r_Tx_DV <= 1'b0;

    `LOOP_COLOR `LOOP_CHANNEL
        if (r_Source_Mem_We[channel][color]) r_Source_Mem_We[channel][color] <= 1'b0;

    if (r_Tx_Delay != 0) r_Tx_Delay <= r_Tx_Delay-1;

    if (r_SM_Main != s_PROCESS)
        `LOOP_COLOR r_Result_Mem_We[color] <= 1'b0;

    case (r_SM_Main)
        s_IDLE:
            begin
                if (w_Rx_Dv)
                    case (w_Rx_Byte)
                        8'd0:
                        begin
                            r_Tx_Byte <= 8'd0;
                            r_Tx_DV <= 1'b1;
                        end
                        8'd1:
                        begin
                            r_SM_Main <= s_SET_SCALE_FACTOR;
                            r_Tx_Byte <= 8'd1;
                            r_Tx_DV <= 1'b1;
                        end
                        8'd2: 
                        begin
                            r_SM_Main <= s_SET_WRITE_ROW_NUMBER;
                            r_Tx_Byte <= 8'd2;
                            r_Tx_DV <= 1'b1;
                        end
                        8'd3:
                        begin
                            r_SM_Main <= s_PROCESS;

                            r_Mem_Counter <= 0;
                            r_Source_Mem_Addr[0] <= 0;
                            r_Source_Mem_Addr[1] <= 0;
                            r_Result_Mem_Addr <= 0;

                            r_Tx_Byte <= 8'd3;
                            r_Tx_DV <= 1'b1;
                        end
                        8'd4: r_SM_Main <= s_SET_SEND_ROW_NUMBER;
                    endcase
             end
        s_SET_SCALE_FACTOR:
            begin
                if (w_Rx_Dv)
                    begin
                        r_Scale_Factor <= w_Rx_Byte[1:0];
                        r_SM_Main <= s_IDLE;
                    end
            end
        s_SET_WRITE_ROW_NUMBER:
            begin
                if (w_Rx_Dv)
                    begin
                        r_Source_Mem_Addr[0] <= 100 * w_Rx_Byte;
                        r_Color <= 0;
                        r_Mem_Counter <= 0;
                        r_SM_Main <= s_SET_WRITE_ROW;
                    end
            end
       s_SET_WRITE_ROW:
            begin
                if (w_Rx_Dv)
                    begin
                        case (r_Color)
                            0:
                            begin
                                r_Source_Mem_We[0][0] <= 1'b1;
                                r_Source_Mem_Din[0][0] <= w_Rx_Byte | 8'b0;
                                r_Color <= 1;
                            end
                            1:
                            begin
                                r_Source_Mem_We[0][1] <= 1'b1;
                                r_Source_Mem_Din[0][1] <= w_Rx_Byte | 8'b0;
                                r_Color <= 2;
                            end
                            2:
                            begin
                                r_Source_Mem_We[0][2] <= 1'b1;
                                r_Source_Mem_Din[0][2] <= w_Rx_Byte | 8'b0;;
                                r_Color <= 0;

                                if (r_Mem_Counter == 99) r_SM_Main = s_IDLE;
                                r_Mem_Counter <= r_Mem_Counter+1;
                                r_Source_Mem_Addr[0] <= r_Source_Mem_Addr[0]+1;
                            end
                        endcase
                    end
            end
       s_PROCESS:
            begin
                r_Result_Mem_Din[0] <= w_Source_Mem_Dout[0][0];
                r_Result_Mem_Din[1] <= w_Source_Mem_Dout[0][1];
                r_Result_Mem_Din[2] <= w_Source_Mem_Dout[0][2];

                `LOOP_COLOR r_Result_Mem_We[color] <= 1'b1;

                r_Source_Mem_Addr[0] <= r_Source_Mem_Addr[0] + 1;

                if (r_Source_Mem_Addr[0] == 10000) 
                begin
                    r_SM_Main = s_IDLE;

                    r_Tx_Byte <= 8'd4;
                    r_Tx_DV <= 1'b1;
                end

                if (r_Mem_Counter == 99)
                    begin
                        r_Mem_Counter <= 0;
                        r_Result_Mem_Addr <= r_Result_Mem_Addr + 1 + 40;
                    end
                else
                    begin
                        r_Mem_Counter <= r_Mem_Counter+1;
                        r_Result_Mem_Addr <= r_Result_Mem_Addr + 1;
                    end
            end
        s_SET_SEND_ROW_NUMBER:
            begin
                if (w_Rx_Dv)
                    begin
                        r_Result_Mem_Addr <= 140 * w_Rx_Byte;
                        r_SM_Main <= s_SEND_ROW;
                        r_Color <= 0;
                        r_Mem_Counter <= 0;
                    end
            end
        s_SEND_ROW:
            begin
                if (!w_Tx_Active && r_Tx_Delay == 0)
                    begin
                        case (r_Color)
                            0:
                            begin
                                r_Tx_Byte <= w_Result_Mem_Dout[0];
                                r_Tx_DV <= 1'b1;
                                r_Tx_Delay <= 8'b111;
                                r_Color <= 1;
                            end
                            1:
                            begin
                                r_Tx_Byte <= w_Result_Mem_Dout[1];
                                r_Tx_DV <= 1'b1;
                                r_Tx_Delay <= 8'b111;
                                r_Color <= 2;
                            end
                            2:
                            begin
                                r_Tx_Byte <= w_Result_Mem_Dout[2];
                                r_Tx_DV <= 1'b1;
                                r_Tx_Delay <= 8'b111;
                                r_Color <= 0;

                                if (r_Mem_Counter == 139) r_SM_Main = s_IDLE;
                                r_Mem_Counter <= r_Mem_Counter+1;
                                r_Result_Mem_Addr <= r_Result_Mem_Addr+1;
                            end
                        endcase
                    end
            end
    endcase
end

endmodule
