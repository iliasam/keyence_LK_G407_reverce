`timescale 1ns / 1ps

module fifo_logic(
    input clk,
    input full,
    input data_valid,
    output read_en
    );
	 
reg full_latch = 'd0;

assign read_en = (full_latch & data_valid);

always @(posedge clk)
begin
	if (full == 1'd1) full_latch <= 'd1;
end

endmodule
