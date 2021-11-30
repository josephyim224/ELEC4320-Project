`timescale 1ns / 1ps

module breathing_led(
    input clk_100MHz,
    output led
);

reg[0:23] counter = 0;

always @(posedge clk_100MHz)
    counter <= counter+1;

assign led = counter > 24'b0111_1111_1111_1111_1111_1111;

endmodule
