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
			output reg [10:0] data_out,//result to be displayed
			output reg	[7:0] led = 0
			

    );
	 
	 

reg[10:0] operand1 = 11'b0;
reg[10:0] operand2 = 11'b0;
reg negative1;
reg negative2; 
reg [3:0] counter = 4'b0;
reg[1:0] operator = 2'b0;
reg [31:0] temp = 32'b0;
reg [31:0] temp1 = 32'b0;

reg [11:0] x_mult = 0;
reg [11:0] y_mult = 0;
wire [23:0] p_mult;

reg mult_flag = 0;



booth_mult mult (
	      .x(x_mult),
         .y(y_mult),
			.p(p_mult)
	      );


always @(posedge(clk)) begin

	if (rst) begin //reset if you want to do a new operation
			operand1 = 11'b0;
			operand2 = 11'b0;
			negative1 <= 1'b0;
			negative2 <= 1'b0;
			counter = 4'b0;
			operator <= 2'b0;
			temp = 32'b0;
			temp1 = 32'b0;
			led = 0;
		end // if

	else if (sel) begin
	
			if (data_in == 14 && counter < 4) counter = 4; // 14 is enter. Go to operator after enter during first operation
			else if (data_in == 14 && counter > 6 && counter < 9) counter = 9; // 14 is enter. Go to operation after enter during second operand
			
			case(counter)
				0: begin 
				if (data_in == 10) negative1 <= 0; // 11 is a plus
				else if (data_in == 11) negative1 <= 1; // 12 is a minus
				end
				
				1: operand1 = data_in;
				
				2: begin
					temp = (operand1 * 10);
					operand1 = temp[10:0] + data_in; //tens	
				end

				3: begin
					temp1 = (operand1 * 10);
					operand1 = temp1[10:0] + data_in;
				end
				
				4: begin 
					case (data_in)
						10: operator <= 0; //add
						11: operator <= 1; //sub
						12: operator <= 2; //mult
					endcase
				end
				
				5: begin
					if (data_in == 10) negative2 <= 1'b0;
					else if (data_in == 11) negative2 <= 1'b1;
				end
				
				6: operand2 = data_in; 
				
				7: begin
					temp=(operand2 * 10);
					operand2 = temp[10:0] + data_in; 
				end	
				
				8: begin 
					temp1=(operand2 * 10);
					operand2 = temp1[10:0] + data_in;
				end
				
				9: begin 
					if (negative2 == 1'b1) operand2 = -operand2;
					if (negative1 == 1'b1) operand1 = -operand1;
					case (operator)
						0 : begin 
						if ((operand1+operand2) > 999 || (operand1+operand2) <-999) begin
								data_out <= 0;
								led=8'hFF;
						end
						else
								data_out <= operand1 + operand2;
						end
						1 : begin 
						if ((operand1-operand2) > 999 || (operand1-operand2) < -999) begin
								data_out <= 0;
								led=8'hFF;
							end
						else
								data_out <= operand1 - operand2;
						end
						
						2 : begin
							x_mult <= operand1;
							y_mult <= operand2;
							mult_flag <= 1;
							end
					
					endcase // operator
				end // 9
			endcase // counter
		
			if (data_in != 14) counter = counter+1;
	
		end // else if (sel)
	
	else if (mult_flag) begin
			if (p_mult >999 || p_mult <-999) begin
					data_out <= 0;
					led=8'hFF;
				end
			else 	data_out <= p_mult[10:0];
			mult_flag <= 0;
			
		end

	
		
end // always @(posedge(clk))

endmodule
