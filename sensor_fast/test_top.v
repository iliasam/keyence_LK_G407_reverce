// Verilog test fixture created from schematic D:\MYPROGS\FPGA\XILINX\PROJECTS\test_centroid1\top.sch - Sun Nov 15 12:36:53 2015

`timescale 10ns / 10ps

module top_top_sch_tb();

// Inputs
   reg CLK_IN;
   reg [9:0] DATA_BUS;
   reg RX_PIN;

// Output
   wire [2:0] L_PWR;
   wire SENS_CLK;
   wire ADC_CLK;
   wire EXPOSURE;
   wire LASER;
   wire TX_PIN;
   wire [3:0] GAIN_BUS;
   wire ADC_CLAMP;

// Bidirs

// Instantiate the UUT
   top UUT (
		.L_PWR(L_PWR), 
		.CLK_IN(CLK_IN), 
		.SENS_CLK(SENS_CLK), 
		.ADC_CLK(ADC_CLK), 
		.EXPOSURE(EXPOSURE), 
		.LASER(LASER), 
		.DATA_BUS(DATA_BUS), 
		.TX_PIN(TX_PIN), 
		.GAIN_BUS(GAIN_BUS), 
		.RX_PIN(RX_PIN), 
		.ADC_CLAMP(ADC_CLAMP)
   );
// Initialize Inputs

	always
   #5 CLK_IN = ~CLK_IN;
	
	reg [8:0] adress;
	reg [8:0] shift_val = 'd0;
	
	reg switch_flag = 1'd0;


  initial begin
		CLK_IN = 0;
		DATA_BUS = 0;
		RX_PIN = 0;
		#100;
	end
	
	
	always @(posedge ADC_CLK) 
   #0
    begin
		if (ADC_CLAMP == 1'd1)//ADC_CLAMP = data_valid
		begin
			adress = adress + 'd1;
			case (adress)
				(shift_val+1): DATA_BUS<='d500;
				(shift_val+2): DATA_BUS<='d800;
				(shift_val+3): DATA_BUS<='d500;
				default: DATA_BUS<='d0;
			endcase
		end
		else adress = 'd0;
    end
	 
	 
	always @(posedge EXPOSURE)
	begin
		if (switch_flag == 'd0)
			shift_val <= 'd100;
		else
			shift_val <= 'd200;
		switch_flag = ~switch_flag;
	end

endmodule
