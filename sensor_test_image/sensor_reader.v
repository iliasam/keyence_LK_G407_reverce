`timescale 1ns / 1ps
`define CYCLE_LENGTH 577//50+15+512 - exposure + delay + data + delay

module sensor_reader(
input clk_in,
input start_capture,
output sensor_expos,
output data_valid,
output capture_complete,
output [8:0] data_adress
);



reg [9:0] counter;
reg capture_enabled = 1'd0;

assign sensor_expos = (counter < 50)? 1'd1:1'd0;
assign data_valid = ((counter > 50+14) && capture_enabled)? 1'd1:1'd0;
assign data_adress = (data_valid)? (counter - (50+15)):9'd0;

reg [1:0] trig;
always@(posedge clk_in)
begin
	trig <= {trig[0],~capture_enabled};
end
assign capture_complete = (trig == 2'b01) ? 1'b1 : 1'b0; //детектор заднего фронта capture_enabled

always @ (posedge clk_in)
begin
	if (start_capture) 
	begin
		counter <= 'd0;
		capture_enabled <= 1'd1;
	end
	else if (counter < (`CYCLE_LENGTH -1))
		counter <= counter + 'd1;// increment counter
	else capture_enabled <= 1'd0;//захват завершаетс€
end


endmodule
