`timescale 1ns / 1ns

module top(clk, led, RsRx, RsTx);

input clk;
input RsRx;
output RsTx;
output [15:0] led;

// --------------------------------------------------------------------------------------

wire clk_50MHz;

clk_wiz_0 CLKGEN(
    .clk_out1(clk_50MHz),
    .reset(),
    .locked(),
    .clk_in1(clk)
);

// --------------------------------------------------------------------------------------

wire w_Tx_DV;
wire [7:0] w_Tx_Byte;
wire w_Tx_Active;

wire w_Rx_Dv;
wire [7:0] w_Rx_Byte;

assign led[1] = RsTx != 1;
assign led[2] = RsRx != 1;

uart_rx UART_RX_INST(
    .i_Clock(clk_50MHz),
    .i_Rx_Serial(RsRx),
    .o_Rx_DV(w_Rx_Dv),
    .o_Rx_Byte(w_Rx_Byte)
);

uart_tx UART_TX_INST(
    .i_Clock(clk_50MHz),
    .i_Tx_DV(w_Tx_DV),
    .i_Tx_Byte(w_Tx_Byte),
    .o_Tx_Active(w_Tx_Active),
    .o_Tx_Serial(RsTx),
    .o_Tx_Done()
);

// --------------------------------------------------------------------------------------

breathing_led BREATHING_LED(
    .clk_100MHz(clk_50MHz),
    .led(led[0])
);

// --------------------------------------------------------------------------------------

// [channel][color][bits]
wire [3:0][13:0] w_Source_Mem_Addr;
wire [3:0][2:0][7:0] w_Source_Mem_Din;
wire [3:0][2:0][0:0] w_Source_Mem_We;
wire [3:0][2:0][7:0] w_Source_Mem_Dout;

//source_mem SOURCE_MEM_A(
//    .i_clk(clk_50MHz),
//    .i_Addr(w_Source_Mem_Addr[1:0]),
//    .i_Din(w_Source_Mem_Din[1:0]),
//    .i_We(w_Source_Mem_We[1:0]),
//    .o_Dout(w_Source_Mem_Dout[1:0])
//);

//source_mem SOURCE_MEM_B(
//    .i_clk(clk_50MHz),
//    .i_Addr(w_Source_Mem_Addr[3:2]),
//    .i_Din(w_Source_Mem_Din[3:2]),
//    .i_We(w_Source_Mem_We[3:2]),
//    .o_Dout(w_Source_Mem_Dout[3:2])
//);

source_mem SOURCE_MEM_B(
    .i_clk(clk_50MHz),
    .i_Addr(w_Source_Mem_Addr),
    .i_Din(w_Source_Mem_Din),
    .i_We(w_Source_Mem_We),
    .o_Dout(w_Source_Mem_Dout)
);

wire [15:0] w_Result_Mem_Addr;
wire [2:0][7:0] w_Result_Mem_Din;
wire [2:0][0:0] w_Result_Mem_We;
wire [2:0][7:0] w_Result_Mem_Dout;

result_mem RESULT_MEM(
    .i_clk(clk_50MHz),
    .i_Addr(w_Result_Mem_Addr),
    .i_Din(w_Result_Mem_Din),
    .i_We(w_Result_Mem_We),
    .o_Dout(w_Result_Mem_Dout)
);

// --------------------------------------------------------------------------------------

fsm FSM(
    .i_clk(clk_50MHz),
    .o_led(led),
    
    .o_Source_Mem_Addr(w_Source_Mem_Addr),
    .o_Source_Mem_Din(w_Source_Mem_Din),
    .o_Source_Mem_We(w_Source_Mem_We),
    .i_Source_Mem_Dout(w_Source_Mem_Dout),

    .o_Result_Mem_Addr(w_Result_Mem_Addr),
    .o_Result_Mem_Din(w_Result_Mem_Din),
    .o_Result_Mem_We(w_Result_Mem_We),
    .i_Result_Mem_Dout(w_Result_Mem_Dout),

    .o_Tx_DV(w_Tx_DV),
    .o_Tx_Byte(w_Tx_Byte),
    .i_Tx_Active(w_Tx_Active),

    .i_Rx_Dv(w_Rx_Dv),
    .i_Rx_Byte(w_Rx_Byte)
);

endmodule
