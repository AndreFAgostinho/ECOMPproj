`timescale 1ns / 1ps


module xps2 (
			input			clk, // System clock
			input			sel, // Module selection input
			input			rst, // Module reset input
			input			ps2_clk, // Clock pin form keyboard
			input			ps2_data, //Data pin form keyboard
			output [8:0]	data_out // Keypress data output and valid bit
	      );

endmodule
