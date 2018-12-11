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
integer scan_counter =0;
integer n_enter = 0;
reg[10:0] operand1 = 11'b0;
reg[10:0] operand2 = 11'b0;
reg negative1;
reg negative2; 
reg[1:0] operator = 2'b0;
reg [31:0] temp =32'b0;

always @(negedge(sel))
	begin

	if (n_enter==0 && data_in == 11'b1110)
		begin
		scan_counter = 4; // jumps to the operator
		n_enter = n_enter+1;
		end
	else if (n_enter ==1 && data_in == 11'b1110)
		begin 
		scan_counter=5; // jumps to the second operand
		n_enter = n_enter +1;
		end
	else if (n_enter ==2 && data_in == 11'b1110)
		begin 
		scan_counter=9; //jumps to the operation
		n_enter = n_enter +1;
		end

	if (scan_counter == 0) 
		begin 
		if (data_in == 11'b1010) negative1 = 1'b0;
		else if (data_in == 11'b1011) negative1 = 1'b1;
		end

	else if (scan_counter == 1) operand1 = data_in; //units	

	else if (scan_counter == 2)
		begin
		temp = (operand1*11'b00000001010);
		operand1 = temp[10:0]+data_in; //tens	
		end	

	else if (scan_counter == 3) 
		begin 
		if (negative1 ==1'b1) //ones
			begin
			temp=(operand1*11'b00000001010);
			operand1=-(temp[10:0]+data_in); 
			end
		else operand1= temp[10:0]+data_in;
		end

	else if (scan_counter  == 4) //operator
		begin 
		case (data_in)
			11'b1010 : operator = 2'b00; //add
			11'b1011: operator = 2'b01; //sub
			11'b1100: operator = 2'b10; //mult
			11'b1101: operator = 2'b11; //div
		endcase
		end

	else if (scan_counter == 5)
		begin
		if (data_in == 11'b1010) negative2 = 1'b0;
		else if (data_in == 11'b1011) negative2 = 1'b1;
		end
	
	else if (scan_counter == 6) operand2 = data_in; //units
	
	else if (scan_counter == 7) 
		begin
		temp=(operand2*11'b00000001010);
		operand2 = temp[10:0]+data_in; //tens	
		end	
	
	else if (scan_counter == 8) //ones
		begin 
		if (negative2 ==1'b1)
			begin
			temp= (operand2*11'b00000001010);
			operand2=-(temp[10:0]+data_in); 
			end
		else operand2 = temp[10:0]+data_in;
		end
	
	else if (scan_counter == 9)
		begin 
		if (data_in == 11'b1110)
			begin
			case (operator)
				2'b00 : data_out <= operand1 + operand2;
				2'b01 : data_out <= operand1 - operand2;	
					//mult here
					//div here
			endcase
		end
	end
	
	if (scan_counter < 9) scan_counter = scan_counter + 1;
	else 
		begin
		scan_counter = 0;
		n_enter = 0;
		end

	end // always @(negedge(sel))

endmodule
