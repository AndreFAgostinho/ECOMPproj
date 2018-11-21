`timescale 1ns / 1ps

module xpushs (
			input			clk, // System clock
			input			sel, // Module selection input
			input			rst, // Module reset input
			input			push_C, // Push button for C
			input			push_AC, // Push button for AC
			output reg [1:0]	data_out // data output
	      );
			
always @(posedge clk)
	
   if(rst)
     data_out= 2'b00;
	else
		if (push_AC && push_C)
			data_out = 2'b11;
		else if (push_AC)
			data_out = 2'b01;
		else if (push_C)
			data_out =2'b10;
		else data_out=2'b00;
	
endmodule
