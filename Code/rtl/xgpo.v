`timescale 1ns / 1 ps
`include "xdefs.vh"

module xgpo (
	input		clk,
	input		sel,
	input		rst,
	input	[7:0]	data_in,
	output reg	[7:0]	data_out
);

always @(posedge clk)

    if (rst)
	data_out <= 8'b0;
    else if (sel)
	data_out <= data_in;

endmodule
