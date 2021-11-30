`timescale 1ns / 1ns

module testbench();
    
reg clk;
reg [9:0] IOs;
wire beep;

top TOP(.clk(clk), .btnC(), .led(), .RsRx(), .RsTx());

always 
begin
    clk= 1; #1; 
    clk= 0; #1;
end

endmodule

