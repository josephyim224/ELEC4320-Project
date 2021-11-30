`timescale 1ns / 1ns

module top(clk, btnC, led, RsRx, RsTx);

input clk;
input btnC; // as reset button
input RsRx;
output RsTx;
output [0:15] led;

wire clk_100MHz;

reg r_Tx_DV = 0;
reg [7:0] r_Tx_Byte = 0;
wire w_Tx_Done;

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
    .o_Tx_Active(),
    .o_Tx_Serial(RsTx),
    .o_Tx_Done()
);

breathing_led BREATHING_LED(
    .clk_100MHz(clk_100MHz),
    .led(led[0])
);

// controller
parameter s_IDLE = 3'b000;
parameter s_SET_SCALE_FACTOR = 3'b001;
parameter s_SET_WRITE_ROW_NUMBER = 3'b010;
parameter s_SET_WRITE_ROW = 3'b011;
parameter s_PROCESS = 3'b100;
parameter s_SET_SEND_ROW_NUMBER = 3'b101;
parameter s_SEND_ROW  = 3'b110;

reg [0:2] r_SM_Main = 0;
reg [0:1] r_Scale_Factor = 0;
reg [0:7] r_Write_Y = 0;
reg [0:7] r_Read_Y = 0;

assign led[3] = r_SM_Main == s_IDLE;
assign led[4] = r_SM_Main == s_SET_SCALE_FACTOR;
assign led[5] = r_SM_Main == s_SET_WRITE_ROW_NUMBER;
assign led[6] = r_SM_Main == s_SET_WRITE_ROW;
assign led[7] = r_SM_Main == s_PROCESS;
assign led[8] = r_SM_Main == s_SET_SEND_ROW_NUMBER;
assign led[9] = r_SM_Main == s_SEND_ROW;

always @(posedge clk_100MHz) begin
    case (r_SM_Main)
        s_IDLE:
            begin
                if (w_Rx_Dv)
                    case (w_Rx_Byte)
                        8'd1: r_SM_Main <= s_SET_SCALE_FACTOR;
                        8'd2: r_SM_Main <= s_SET_WRITE_ROW_NUMBER;
                        8'd3: r_SM_Main <= s_PROCESS;
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
                        r_Write_Y <= w_Rx_Byte;
                        r_SM_Main <= s_SET_WRITE_ROW;
                    end
            end
    //    s_SET_WRITE_ROW:
    //         begin
    //         end
    //    s_PROCESS:
    //         begin
    //         end
        s_SET_SEND_ROW_NUMBER:
            begin
                if (w_Rx_Dv)
                    begin
                        r_Read_Y <= w_Rx_Byte;
                        r_SM_Main <= s_SEND_ROW;
                    end
            end
        // s_SEND_ROW:
        //     begin
        //     end
    endcase
end

endmodule
