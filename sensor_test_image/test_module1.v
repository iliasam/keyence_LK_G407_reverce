`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:14:46 11/01/2015
// Design Name:   max_finder
// Module Name:   D:/MYPROGS/FPGA/XILINX/PROJECTS/test3/test_module1.v
// Project Name:  test2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: max_finder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_module1;

	// Inputs
	reg clk_in;
	reg start;
	reg data_valid;
	reg [7:0] data_in;
	reg [8:0] data_pos;

	// Outputs
	wire [8:0] max_pos;
	wire [7:0] max_value;

	// Instantiate the Unit Under Test (UUT)
	max_finder uut (
		.clk_in(clk_in), 
		.start(start), 
		.data_valid(data_valid), 
		.data_in(data_in), 
		.data_pos(data_pos), 
		.max_pos(max_pos), 
		.max_value(max_value)
	);
	
	always
    #10 clk_in = ~clk_in;

	initial begin
		// Initialize Inputs
		clk_in = 0;
		start = 0;
		data_valid = 0;
		data_in = 0;
		data_pos = 0;

		// Wait 100 ns for global reset to finish
		#100;
		start = 1;
		#60;
		start = 0;
		#60;
		data_valid = 1;
		#300;
			data_in = 'd100;
			data_pos = 'd123;
		#60;
        	data_in = 'd110;
			data_pos = 'd130;
		#60;
        	data_in = 'd90;
			data_pos = 'd140;

	end
      
endmodule

