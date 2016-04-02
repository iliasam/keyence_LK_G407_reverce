`timescale 1ns / 1ps

module max_latch(
    input clk,
    input latch,
    input [8:0] max_pos,
    input [9:0] max_val,
    output [8:0] max_pos_out,
    output [9:0] max_val_out
    );
	 
reg [8:0] max_pos_reg = 'd0;
reg [9:0] max_val_reg = 'd0;
assign max_pos_out = max_pos_reg;
assign max_val_out = max_val_reg;

always@(posedge clk)
begin
	if (latch == 1'd1)
	begin
		max_pos_reg <= max_pos;
		max_val_reg <= max_val;
	end
end


endmodule
