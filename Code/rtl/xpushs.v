`timescale 1ns / 1ps

module xpush (
			input wire push_C, // Push button for C
			input wire push_CE, // Push button for CE
			output reg [8:0] data_out // data output
	      );