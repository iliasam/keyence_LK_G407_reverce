`timescale 1ns / 1ps

module max_finder(
input clk_in,
input start,
input data_valid,
input [9:0] data_in, //������
input [8:0] data_pos, //�����-���������
output [8:0] max_pos, //��������� ���������
output [9:0] max_value //��������� ��������
);

reg [8:0] max_pos_reg = 'd0;
reg [9:0] max_value_reg = 'd0;

assign max_pos = max_pos_reg;
assign max_value = max_value_reg;

always @ (posedge clk_in)
begin
	if (start == 'd1)
	begin
		max_pos_reg <= 'd0;
		max_value_reg <= 'd0;
	end
	else if ((data_valid == 'd1) && (data_in > max_value) && (data_pos > 'd7))
	begin
		max_value_reg <= data_in;//������ ������
		max_pos_reg <= data_pos;//������ ���������
	end
		
end


endmodule
