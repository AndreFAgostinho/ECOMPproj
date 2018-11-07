`timescale 1ns / 1ps

module xps2 (
			input wire clk, // Clock pin form keyboard
			input wire data, //Data pin form keyboard
			output reg [8:0] data_out // Keypress data output and valid bit
	      );