`timescale 1ns / 1ps

module front_detector(
    input clk,
    input sig_in,
    output sig_out
    );
	 
reg [2:0] delay = 'd7;

assign sig_out = (delay == 'd6)? 1'd1: 1'd0;
	 
reg [1:0] trig = 'd0;
always@(posedge clk)
begin
	trig <= {trig[0],sig_in};
end
//assign sig_out = (trig == 2'b01) ? 1'b1 : 1'b0; //детектор фронта
wire start = (trig == 2'b01) ? 1'b1 : 1'b0; //детектор фронта

always@(posedge clk)
begin
	if (start == 1'd1) delay<= 'd0;
	if (delay < 'd7) delay <= delay + 'd1;
end

endmodule
