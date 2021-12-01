`timescale 1ns / 1ns

module top(clk, btnC, led, RsRx, RsTx);

input clk;
input btnC; // as reset button
input RsRx;
output RsTx;
output [15:0] led;

wire clk_100MHz;

reg r_Tx_DV = 0;
reg [7:0] r_Tx_Byte = 0;
wire w_Tx_Active;

wire w_Rx_Dv;
wire [7:0] w_Rx_Byte;

assign led[1] = RsTx != 1;
assign led[2] = RsRx != 1;

clk_wiz_0 CLKGEN(
    .clk_out1(clk_100MHz),
    .reset(),
    .locked(),
    .clk_in1(clk)
);

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

initial begin
    r_Tx_Byte <= 8'd0;
    r_Tx_DV <= 1'b1;
end

breathing_led BREATHING_LED(
    .clk_100MHz(clk_100MHz),
    .led(led[0])
);

reg [13:0] r_Source_Image_Addr_A = 0;
reg [13:0] r_Source_Image_Addr_B = 0;

wire [7:0] w_Source_Image_Dout_A_R;
wire [7:0] w_Source_Image_Dout_B_R;
reg [7:0] r_Source_Image_Din_A_R = 0;
reg [7:0] r_Source_Image_Din_B_R = 0;
reg [0:0] r_Source_Image_We_A_R = 0;
reg [0:0] r_Source_Image_We_B_R = 0;

wire [7:0] w_Source_Image_Dout_A_G;
wire [7:0] w_Source_Image_Dout_B_G;
reg [7:0] r_Source_Image_Din_A_G = 0;
reg [7:0] r_Source_Image_Din_B_G = 0;
reg [0:0] r_Source_Image_We_A_G = 0;
reg [0:0] r_Source_Image_We_B_G = 0;

wire [7:0] w_Source_Image_Dout_A_B;
wire [7:0] w_Source_Image_Dout_B_B;
reg [7:0] r_Source_Image_Din_A_B = 0;
reg [7:0] r_Source_Image_Din_B_B = 0;
reg [0:0] r_Source_Image_We_A_B = 0;
reg [0:0] r_Source_Image_We_B_B = 0;

mem_source_image SOURCE_IMAGE_R(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Source_Image_Addr_A),
    .douta(w_Source_Image_Dout_A_R),
    .dina(r_Source_Image_Din_A_R),
    .wea(r_Source_Image_We_A_R),

    .addrb(r_Source_Image_Addr_B),
    .doutb(w_Source_Image_Dout_B_R),
    .dinb(r_Source_Image_Din_B_R),
    .web(r_Source_Image_We_B_R)
);

mem_source_image SOURCE_IMAGE_G(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Source_Image_Addr_A),
    .douta(w_Source_Image_Dout_A_G),
    .dina(r_Source_Image_Din_A_G),
    .wea(r_Source_Image_We_A_G),

    .addrb(r_Source_Image_Addr_B),
    .doutb(w_Source_Image_Dout_B_G),
    .dinb(r_Source_Image_Din_B_G),
    .web(r_Source_Image_We_B_G)
);

mem_source_image SOURCE_IMAGE_B(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Source_Image_Addr_A),
    .douta(w_Source_Image_Dout_A_B),
    .dina(r_Source_Image_Din_A_B),
    .wea(r_Source_Image_We_A_B),

    .addrb(r_Source_Image_Addr_B),
    .doutb(w_Source_Image_Dout_B_B),
    .dinb(r_Source_Image_Din_B_B),
    .web(r_Source_Image_We_B_B)
);

reg [15:0] r_Result_Image_Addr_A = 0;
reg [15:0] r_Result_Image_Addr_B = 0;

wire [7:0] w_Result_Image_Dout_A_R;
wire [7:0] w_Result_Image_Dout_B_R;
reg [7:0] r_Result_Image_Din_A_R = 0;
reg [7:0] r_Result_Image_Din_B_R = 0;
reg [0:0] r_Result_Image_We_A_R = 0;
reg [0:0] r_Result_Image_We_B_R = 0;

wire [7:0] w_Result_Image_Dout_A_G;
wire [7:0] w_Result_Image_Dout_B_G;
reg [7:0] r_Result_Image_Din_A_G = 0;
reg [7:0] r_Result_Image_Din_B_G = 0;
reg [0:0] r_Result_Image_We_A_G = 0;
reg [0:0] r_Result_Image_We_B_G = 0;

wire [7:0] w_Result_Image_Dout_A_B;
wire [7:0] w_Result_Image_Dout_B_B;
reg [7:0] r_Result_Image_Din_A_B = 0;
reg [7:0] r_Result_Image_Din_B_B = 0;
reg [0:0] r_Result_Image_We_A_B = 0;
reg [0:0] r_Result_Image_We_B_B = 0;

mem_result_image RESULT_IMAGE_R(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Result_Image_Addr_A),
    .douta(w_Result_Image_Dout_A_R),
    .dina(r_Result_Image_Din_A_R),
    .wea(r_Result_Image_We_A_R),

    .addrb(r_Result_Image_Addr_B),
    .doutb(w_Result_Image_Dout_B_R),
    .dinb(r_Result_Image_Din_B_R),
    .web(r_Result_Image_We_B_R)
);

mem_result_image RESULT_IMAGE_G(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Result_Image_Addr_A),
    .douta(w_Result_Image_Dout_A_G),
    .dina(r_Result_Image_Din_A_G),
    .wea(r_Result_Image_We_A_G),

    .addrb(r_Result_Image_Addr_B),
    .doutb(w_Result_Image_Dout_B_G),
    .dinb(r_Result_Image_Din_B_G),
    .web(r_Result_Image_We_B_G)
);

mem_result_image RESULT_IMAGE_B(
    .clka(clk_100MHz),
    .clkb(clk_100MHz),

    .addra(r_Result_Image_Addr_A),
    .douta(w_Result_Image_Dout_A_B),
    .dina(r_Result_Image_Din_A_B),
    .wea(r_Result_Image_We_A_B),

    .addrb(r_Result_Image_Addr_B),
    .doutb(w_Result_Image_Dout_B_B),
    .dinb(r_Result_Image_Din_B_B),
    .web(r_Result_Image_We_B_B)
);

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

    if (r_Source_Image_We_A_R) r_Source_Image_We_A_R <= 1'b0;
    if (r_Source_Image_We_A_G) r_Source_Image_We_A_G <= 1'b0;
    if (r_Source_Image_We_A_B) r_Source_Image_We_A_B <= 1'b0;
    if (r_Source_Image_We_B_R) r_Source_Image_We_B_R <= 1'b0;
    if (r_Source_Image_We_B_G) r_Source_Image_We_B_G <= 1'b0;
    if (r_Source_Image_We_B_B) r_Source_Image_We_B_B <= 1'b0;

    if (r_Tx_Delay != 0) r_Tx_Delay <= r_Tx_Delay-1;

    if (r_SM_Main != s_PROCESS)
    begin
        if (r_Result_Image_We_A_R) r_Result_Image_We_A_R <= 1'b0;
        if (r_Result_Image_We_A_G) r_Result_Image_We_A_G <= 1'b0;
        if (r_Result_Image_We_A_B) r_Result_Image_We_A_B <= 1'b0;
        if (r_Result_Image_We_B_R) r_Result_Image_We_B_R <= 1'b0;
        if (r_Result_Image_We_B_G) r_Result_Image_We_B_G <= 1'b0;
        if (r_Result_Image_We_B_B) r_Result_Image_We_B_B <= 1'b0;
    end

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
                            r_Source_Image_Addr_A <= 0;
                            r_Source_Image_Addr_B <= 0;
                            r_Result_Image_Addr_A <= 0;
                            r_Result_Image_Addr_B <= 0;

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
                        r_Source_Image_Addr_A <= 100 * w_Rx_Byte;
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
                                r_Source_Image_We_A_R <= 1'b1;
                                r_Source_Image_Din_A_R <= w_Rx_Byte | 8'b0;
                                r_Color <= 1;
                            end
                            1:
                            begin
                                r_Source_Image_We_A_G <= 1'b1;
                                r_Source_Image_Din_A_G <= w_Rx_Byte | 8'b0;
                                r_Color <= 2;
                            end
                            2:
                            begin
                                r_Source_Image_We_A_B <= 1'b1;
                                r_Source_Image_Din_A_B <= w_Rx_Byte | 8'b0;;
                                r_Color <= 0;

                                if (r_Mem_Counter == 99) r_SM_Main = s_IDLE;
                                r_Mem_Counter <= r_Mem_Counter+1;
                                r_Source_Image_Addr_A <= r_Source_Image_Addr_A+1;
                            end
                        endcase
                    end
            end
       s_PROCESS:
            begin
                r_Result_Image_Din_A_R <= w_Source_Image_Dout_A_R;
                r_Result_Image_Din_A_G <= w_Source_Image_Dout_A_G;
                r_Result_Image_Din_A_B <= w_Source_Image_Dout_A_B;

                r_Result_Image_We_A_R <= 1'b1;
                r_Result_Image_We_A_G <= 1'b1;
                r_Result_Image_We_A_B <= 1'b1;

                r_Source_Image_Addr_A <= r_Source_Image_Addr_A + 1;

                if (r_Source_Image_Addr_A == 10000) 
                begin
                    r_SM_Main = s_IDLE;

                    r_Tx_Byte <= 8'd4;
                    r_Tx_DV <= 1'b1;
                end

                if (r_Mem_Counter == 99)
                    begin
                        r_Mem_Counter <= 0;
                        r_Result_Image_Addr_A <= r_Result_Image_Addr_A + 1 + 40;
                    end
                else
                    begin
                        r_Mem_Counter <= r_Mem_Counter+1;
                        r_Result_Image_Addr_A <= r_Result_Image_Addr_A + 1;
                    end
            end
        s_SET_SEND_ROW_NUMBER:
            begin
                if (w_Rx_Dv)
                    begin
                        r_Result_Image_Addr_A <= 140 * w_Rx_Byte;
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
                                r_Tx_Byte <= w_Result_Image_Dout_A_R;
                                r_Tx_DV <= 1'b1;
                                r_Tx_Delay <= 8'b111;
                                r_Color <= 1;
                            end
                            1:
                            begin
                                r_Tx_Byte <= w_Result_Image_Dout_A_G;
                                r_Tx_DV <= 1'b1;
                                r_Tx_Delay <= 8'b111;
                                r_Color <= 2;
                            end
                            2:
                            begin
                                r_Tx_Byte <= w_Result_Image_Dout_A_B;
                                r_Tx_DV <= 1'b1;
                                r_Tx_Delay <= 8'b111;
                                r_Color <= 0;

                                if (r_Mem_Counter == 139) r_SM_Main = s_IDLE;
                                r_Mem_Counter <= r_Mem_Counter+1;
                                r_Result_Image_Addr_A <= r_Result_Image_Addr_A+1;
                            end
                        endcase
                    end
            end
    endcase
end

endmodule
