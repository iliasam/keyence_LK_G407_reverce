`timescale 1ns / 1ps

module centroid_finder(
    input clk,
    input start,
	 input data_valid,
	 input [8:0] max_pos,//координаты максимума с точностью до пикселя
	 input [9:0] max_value,//уровень максимума
    input [8:0] adress,
    input [9:0] value,
	 output done,
    output [15:0] result
    );
	 
reg [8:0] start_pos_reg = 'd0;
reg [8:0] stop_pos_reg = 'd0;
reg [9:0] threshold_value_reg = 'd0;//при превышении этого уровня начинается анализ

reg [31:0] counter1 = 'd0;//64 points max
reg [15:0] counter2 = 'd0;

reg [15:0] result_reg = 'd0;
assign result = result_reg;

wire rfd;
wire [31:0] quotient;
wire [15:0] fractional;

reg end_flag = 1'd0;
reg division_flag = 1'd0;
reg [6:0] div_delay = 'd0;

reg done_reg = 1'd0;
assign done = done_reg;

always@(posedge clk)
begin
	if (start == 1'd1)
	begin
		counter1 <= 'd0;
		counter2 <= 'd0;
		end_flag <= 'd0;
		if (max_pos > 'd30)
			start_pos_reg<= max_pos - 'd30;
		else
			start_pos_reg<= 'd0;
		if (max_pos < 'd482)
			stop_pos_reg<= max_pos + 'd30;
		else
			stop_pos_reg<= 'd511;
		if (max_value > 'd150)
			threshold_value_reg <= max_value>>4;
		else
			threshold_value_reg <= 'd0;
	end
	else
	begin
		if ((data_valid == 1'd1) && (adress >= start_pos_reg) && (adress < stop_pos_reg) && (value > threshold_value_reg))
		begin
			counter1 <= counter1 + ((adress*value)<<7);//2^7 = 128
			counter2 <= counter2 + value;
		end
		else if (adress == 'd511) end_flag <= 1'd1;
		begin

		end
	end
end


//управляет процесом деления
always@(posedge clk)
begin
	if (start == 1'd1) 
	begin
		done_reg <= 'd0;
		division_flag <= 'd0;
		//result_reg <= 'd0;
	end
	else if ((end_flag == 1'd1) && (rfd == 1'd1) && (div_delay == 'd0) && (division_flag == 'd0)) 
	begin
		div_delay <= 'd36;//divider latency
		division_flag <= 1'd1;//начат процес деления
	end
	else if ((div_delay == 'd0) && (division_flag == 'd1))//деление закончилось
	begin
			if (counter2 > 'd0) 
				result_reg <= quotient;
			else	
				result_reg <= 'd0;
			done_reg <= 1'd1;
	end
	if (div_delay > 'd0) div_delay<= div_delay - 'd1;
end



div_gen_v3_0 local_div(.rfd(rfd), .clk(clk), .dividend(counter1), .quotient(quotient), .divisor(counter2), .fractional(fractional));


endmodule
