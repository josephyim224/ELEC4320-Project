`timescale 1ns / 1ns

module testbench();
reg clock = 0;
reg d_x = 1;
reg d_y = 1;
wire val_;
interpolate interpolate(.clk(clock), .dx(d_x), .dy(d_y), .val(val_));

initial $display("startt\n");

always #1 clock = ~clock;
endmodule