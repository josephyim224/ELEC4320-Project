// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Tue Dec 14 00:48:35 2021
// Host        : T480s running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/josep/GitHub/ELEC4320-Project/hw/hw.gen/sources_1/ip/mem_result_image/mem_result_image_stub.v
// Design      : mem_result_image
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *)
module mem_result_image(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[14:0],dina[7:0],douta[7:0]" */;
  input clka;
  input [0:0]wea;
  input [14:0]addra;
  input [7:0]dina;
  output [7:0]douta;
endmodule
