`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2021 19:48:26
// Design Name: 
// Module Name: fsm_tb
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

module fsm_tb();

    parameter s_IDLE = 3'b000;
    parameter s_SET_SCALE_FACTOR = 3'b001;
    parameter s_SET_WRITE_ROW_NUMBER = 3'b010;
    parameter s_SET_WRITE_ROW = 3'b011;
    parameter s_PROCESS = 3'b100;
    parameter s_SET_SEND_ROW_NUMBER = 3'b101;
    parameter s_SEND_ROW  = 3'b110;

    parameter c_SET_SCALE_FACTOR = 8'd1;
    parameter c_SET_WRITE_ROW_NUMBER = 8'd2;
    parameter c_PROCESS = 8'd3;
    parameter c_SET_SEND_ROW_NUMBER = 8'd4;

`define FSM_ASSERT_STATE(EXPECTED) if (w_SM_Main != EXPECTED) begin $display("Expecting %d but got %d instead", EXPECTED, w_SM_Main); $finish(); end
`define WAIT_CLK #1 clk = 1; #1 clk = 0;
`define TX_AND_WAIT_CLK(VALUE) r_Rx_Dv = 1; r_Rx_Byte = VALUE; `WAIT_CLK r_Rx_Dv = 0;

wire [2:0] w_SM_Main;

reg clk;
reg r_Rx_Dv;
reg [7:0] r_Rx_Byte;
wire w_Tx_Active = 0;

integer fsm_i;

fsm FSM(
    .i_clk_100MHz(clk),
    .i_Rx_Dv(r_Rx_Dv),
    .i_Rx_Byte(r_Rx_Byte),
    .i_Tx_Active(0),
    .o_SM_Main(w_SM_Main),
    .i_Source_Mem_Dout({{200,200,200},{200,200,200},{200,200,200},{250,250,250}})
);

initial begin
    $display("start");

    #1 clk = 1;
    #1 clk = 0;

    // initial state is idle
    $display("check init state");
    `FSM_ASSERT_STATE(s_IDLE)
    
    // set scale factor
    $display("check set scale factor");
    `TX_AND_WAIT_CLK(c_SET_SCALE_FACTOR)
    `FSM_ASSERT_STATE(s_SET_SCALE_FACTOR)
    `TX_AND_WAIT_CLK(1'd1)
    `FSM_ASSERT_STATE(s_IDLE)
    
    // check set row data
    $display("check set write row number");
    `TX_AND_WAIT_CLK(c_SET_WRITE_ROW_NUMBER)
    `FSM_ASSERT_STATE(s_SET_WRITE_ROW_NUMBER)
    `TX_AND_WAIT_CLK(8'd1)
    `FSM_ASSERT_STATE(s_SET_WRITE_ROW);

    for (fsm_i=0; fsm_i<100*3-1;fsm_i=fsm_i+1) begin
        `TX_AND_WAIT_CLK(8'd1)
        `FSM_ASSERT_STATE(s_SET_WRITE_ROW);
    end
    
    `TX_AND_WAIT_CLK(8'd1)
    `FSM_ASSERT_STATE(s_IDLE);

    // check process
    $display("check process");
    `TX_AND_WAIT_CLK(c_PROCESS)
    `FSM_ASSERT_STATE(s_PROCESS)
    for (fsm_i=0; fsm_i<140*50;fsm_i=fsm_i+1) begin
        `WAIT_CLK
    end
    `FSM_ASSERT_STATE(s_IDLE)

    // check process
    $display("check set send row number");
    `TX_AND_WAIT_CLK(c_SET_SEND_ROW_NUMBER)
    `FSM_ASSERT_STATE(s_SET_SEND_ROW_NUMBER)
    `TX_AND_WAIT_CLK(8'd1)
    `FSM_ASSERT_STATE(s_SEND_ROW);

    for (fsm_i=0; fsm_i<140*40;fsm_i=fsm_i+1) begin
        `WAIT_CLK
    end
    
    `FSM_ASSERT_STATE(s_IDLE);

    $display("done");
    $finish();
end

endmodule
