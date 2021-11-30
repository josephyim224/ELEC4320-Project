`timescale 1ns / 1ns

module top(clk, btnC, led, RsRx, RsTx);

input clk;
input btnC; // as reset button
input RsRx;
output RsTx;
output[0:15] led;

reg r_Tx_DV = 0;
wire w_Tx_Done;
reg [7:0] r_Tx_Byte = 0;
wire clk_100MHz;

assign led[1] = RsTx;

clk_wiz_0 CLKGEN(
    .clk_out1(clk_100MHz),
    .reset(),
    .locked(),
    .clk_in1(clk)
);

uart_rx UART_RX_INST(
    .i_Clock(clk_100MHz),
    .i_Rx_Serial(RsRx),
    .o_Rx_DV(),
    .o_Rx_Byte()
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

reg[0:23] counter = 0;
always @(posedge clk_100MHz) begin
    counter <= counter+1;
    if (counter == 10) r_Tx_Byte <= 0'b1010_1010;
    else if (counter == 11)r_Tx_DV <= 1'b1;
    else r_Tx_DV <= 1'b0;
end

endmodule
