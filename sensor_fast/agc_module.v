`timescale 1ns / 1ps
module agc_module(
input clk_in,
input update,//только одиночный импульс
input [9:0] data_in, //величина максимального значения
output [3:0] gain
);
	 
reg [3:0] gain_reg = 'd0;
assign gain = gain_reg;

always @ (posedge clk_in)
begin
	if (update == 'd1)
	begin
		if ((data_in < 'd700) && (gain_reg < 'd15)) gain_reg<= gain_reg + 'd1;
		else if ((data_in > 'd1000) && (gain_reg > 'd0)) gain_reg<= gain_reg - 'd1;
	end
end

endmodule
