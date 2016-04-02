module counter(
    clk_in,
    zero,
	 half
    );
	 
input clk_in;
output zero;
output half;


parameter cnt_length = 16;
parameter cnt_period = 5000;

reg [cnt_length-1:0] counter;


assign zero = (counter == 'd0) ? 1 : 0;
assign half = (counter > (cnt_period/2)) ? 1 : 0;

always @ (posedge clk_in)
begin
	if (counter < cnt_period)
		counter <= counter + 'd1;// increment counter
	else
		counter <= 'd0;
end


endmodule
