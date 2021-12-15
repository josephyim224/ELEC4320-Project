`ifndef _fsm_header_vh_
`define _fsm_header_vh_

    parameter s_IDLE = 3'b000;
    parameter s_SET_SCALE_FACTOR = 3'b001;
    parameter s_SET_WRITE_ROW_NUMBER = 3'b010;
    parameter s_SET_WRITE_ROW = 3'b011;
    parameter s_PROCESS = 3'b100;
    parameter s_SET_SEND_ROW_NUMBER = 3'b101;
    parameter s_SEND_ROW = 3'b110;
    parameter s_CLEAR_RESULT = 3'b111;

    parameter c_SET_SCALE_FACTOR = 8'd1;
    parameter c_SET_WRITE_ROW_NUMBER = 8'd2;
    parameter c_PROCESS = 8'd3;
    parameter c_SET_SEND_ROW_NUMBER = 8'd4;
    parameter c_CLEAR_RESULT = 8'd5;

`endif