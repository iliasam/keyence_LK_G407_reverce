`timescale 1ns / 1ps
module mux1(bus_in1, bus_in2,result, sel);

input sel;
input [8:0] bus_in1,bus_in2;
output [8:0] result;

assign result = sel ? bus_in2 : bus_in1;

endmodule
