`timescale 1ns / 1ps

module xpushs (
			input			clk, // System clock
			input			sel, // Module selection input
			input			rst, // Module reset input
			input			push_C, // Push button for C
			input			push_AC, // Push button for AC
			output [1:0]	data_out // data output
	      );
			
			
			

 always @(posedge clk)
   if(sel)
     $write("%c", push_C);


endmodule