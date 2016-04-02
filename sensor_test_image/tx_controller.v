`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module tx_controller(
	input clk,
	input tx_start,
	input [7:0] rd_data,
	output [8:0] rd_adress,
	output UART_TxD,
	output tx_busy,
	output tx_complete
);

parameter adr_max = 9'd511;

wire start_byte_tx;
wire local_uart_busy;
wire local_uart_ready;
wire tx_allowed;

reg [8:0] adress_cnt = adr_max;//адрес, по которому читаются данные
reg [18:0] delay_cnt  = 19'd10;//счетчик задержки //10 - дает импульс tx_complete при старте
reg start_byte_reg = 1'd0;

assign local_uart_ready = ~local_uart_busy;
//assign start_byte_tx = tx_allowed & local_uart_ready;
assign start_byte_tx = start_byte_reg;
assign rd_adress[8:0] = adress_cnt[8:0];

assign tx_allowed = (adress_cnt < adr_max);


s_uart_tx #(10000000, 500000) local_uart(.clk(clk), .TxD_start(start_byte_tx), .TxD_data(rd_data), .TxD(UART_TxD) , .TxD_busy(local_uart_busy));

reg [1:0] trig;
always@(posedge clk)
begin
	trig <= {trig[0],local_uart_ready};
end
wire uart_ready_front = (trig == 2'b01) ? 1'b1 : 1'b0; //детектор фронта uart_ready


always @(posedge clk)
begin
	if ((tx_start == 1'd1) && (~tx_allowed))
	begin
		adress_cnt <= 9'd0;
		start_byte_reg <= 1'd1;//начать передачу при смене сетчика
	end
	else if (tx_allowed & uart_ready_front) 
	begin
		adress_cnt <= adress_cnt + 9'd1;//счетчик++ как только байт передан
		start_byte_reg <= 1'd1;//начать передачу при смене сетчика
	end
	else start_byte_reg <= 1'd0;
end

assign tx_busy = (delay_cnt > 19'd0);

reg [1:0] trig2;
always@(posedge clk)
begin
	trig2 <= {trig2[0],~tx_busy};
end
assign tx_complete = (trig2 == 2'b01) ? 1'b1 : 1'b0; //детектор заднего фронта tx_busy

always @(posedge clk)
begin
	if ((tx_start == 1'd1) || (start_byte_reg == 1'd1)) delay_cnt  <= 19'd200000;
	else if (delay_cnt > 19'd0) delay_cnt <= delay_cnt - 19'd1;
end

endmodule
