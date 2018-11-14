`timescale 1ns / 1ps
`include "xdefs.vh"

module xdisp (
			input			clk, // System clock
			input			sel, // Module selection input
			input			rst, // Module reset input
			input	 [11:0]	data_in, // Number input with Overflow bit
			output [11:0]	data_out // 7 segment display control signals
	      );
			
endmodule
