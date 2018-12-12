`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:10:00 12/06/2018 
// Design Name: 
// Module Name:    oper 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module xoper(

			input			clk, // System clock
			input			sel, // Module selection input
			input			rst, // Module reset input
			input [10:0] data_in, // scan code converted in decimal from 0 to 14
			output reg[10:0] data_out //result to be displayed
			

    );
	 
	 

reg [1:0]n_enter = 2'b0;
reg[10:0] operand1 = 11'b0;
reg[10:0] operand2 = 11'b0;
reg negative1;
reg negative2; 
reg [3:0] counter = 4'b0;
reg[1:0] operator = 2'b0;
reg [31:0] temp ;

reg [31:0] temp1 =32'b0;



always @(negedge(sel))
	begin
	if (data_in == 11'b1110 && counter <4'b0100) counter = 4'b0100;
	else if (data_in == 11'b1110 && counter >11'b0110 && counter < 11'b1001) counter = 4'b1001;
	case(counter)
	4'b0000: begin 
	if (data_in == 11'b1010) negative1 <= 1'b0;
	else if (data_in == 11'b1011) negative1 <= 1'b1;
	end
	4'b0001: operand1 = data_in;
	4'b0010: begin
	temp = (operand1*11'b00000001010);
	operand1 = temp[10:0]+data_in; //tens	
	end
	4'b0011: begin
		temp1 =(operand1*11'b00000001010);
		operand1= temp1[10:0]+data_in;
		end
	4'b0100:
		begin 
		
		case (data_in)
			11'b1010 : operator <= 2'b00; //add
			11'b1011: operator <= 2'b01; //sub
			11'b1100: operator <= 2'b10; //mult
			11'b1101: operator <= 2'b11; //div
		endcase
		end
	4'b0101:
		begin
		if (data_in == 11'b1010) negative2 <= 1'b0;
		else if (data_in == 11'b1011) negative2 <= 1'b1;
		end
	4'b0110: operand2 = data_in; 
	4'b0111:
		begin
		temp=(operand2*11'b00000001010);
		operand2 = temp[10:0]+data_in; 
		end	
	4'b1000:
		begin 
		temp1=(operand2*11'b00000001010);
		operand2 = temp1[10:0]+data_in;
		end
	 4'b1001:
		begin 
			begin
			if (negative2 == 1'b1) operand2 =-operand2;
			if (negative1 == 1'b1) operand1 =-operand1;
			case (operator)
				2'b00 : data_out <= operand1 + operand2;
				2'b01 : data_out <= operand1 - operand2;	
					//mult here
					//div here
			endcase
		end
	end
	endcase
	
	if (counter == 9) 
	begin
	counter = 0;
	temp =0;
	temp1 =0;
	operand1 =0;
	operand2 =0;
	end
	
	if (data_in!=11'b1110) counter = counter+1;
		
	end // always @(negedge(sel))
	
	
endmodule
