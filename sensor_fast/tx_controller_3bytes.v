`timescale 1ns / 1ps

module tx_controller_3bytes(
    input clk,
    input tx_start,
    input [15:0] data_in,
	 output UART_TxD,
    output tx_done
    );
	 

reg start_byte_tx_reg = 1'd0;//управление модулем s_uart_tx
wire local_uart_busy;//состояние модуля s_uart_tx
assign local_uart_ready = ~local_uart_busy;

reg [7:0] tx_byte_reg = 'd0;//байт для передачи в s_uart_tx

reg [15:0] data_in_latch = 'd0;

reg tx_done_reg = 1'd1;//не дает передаче начаться при включении
assign tx_done = tx_done_reg;
	 
s_uart_tx #(10000000, 500000) local_uart(.clk(clk), .TxD_start(start_byte_tx_reg), .TxD_data(tx_byte_reg), .TxD(UART_TxD) , .TxD_busy(local_uart_busy));

reg [2:0] phase_cnt = 'd0;
reg lock_flag = 'd0;

reg [1:0] trig = 'd0;
always@(posedge clk)
begin
	trig <= {trig[0],tx_start};
end
assign tx_start_front = (trig == 2'b01) ? 1'b1 : 1'b0; //детектор фронта


always@(posedge clk)
begin
	if (tx_start_front == 1'd1) 
	begin
		phase_cnt<= 'd0;
		tx_done_reg<= 1'd0;
		data_in_latch<= data_in;
	end
	else if ((local_uart_ready == 1'd1) && (tx_done_reg == 1'd0) && (lock_flag == 1'd0))//можно начинать передачу
	begin
		case (phase_cnt)
			'd0: phase_cnt<= phase_cnt + 'd1;
			'd1:
				begin
					tx_byte_reg<= 'd0;//передается 0
					start_byte_tx_reg<=1'd1;//запуск передачи 1 байта
					phase_cnt<= phase_cnt + 'd1;
					lock_flag<=1'd1;
				end
			'd2:
				begin
					tx_byte_reg<= data_in_latch[15:8];//передается 1 часть
					start_byte_tx_reg<=1'd1;//запуск передачи 2 байта
					phase_cnt<= phase_cnt + 'd1;
					lock_flag<=1'd1;
				end
			'd3:
				begin
					tx_byte_reg<= data_in_latch[7:0];//передается 2 часть
					start_byte_tx_reg<=1'd1;//запуск передачи 3 байта
					phase_cnt<= phase_cnt + 'd1;
					lock_flag<=1'd1;
				end
			'd4:
				begin
					tx_done_reg<= 1'd1;
					phase_cnt<= phase_cnt + 'd1;
				end
		endcase
	end
	else 
	begin
		start_byte_tx_reg<= 1'd0;
		lock_flag<=1'd0;
	end
end

endmodule
