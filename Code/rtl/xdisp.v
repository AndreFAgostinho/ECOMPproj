`timescale 1ns / 1ps


module xdisp (
			input			clk, // System clock
			input			sel, // Module selection input
			input			rst, // Module reset input
			input	 [10:0]	data_in, // Number input with Overflow bit
			output reg[11:0]	data_out // 7 segment display control signals
	      );

reg [1:0]AN = 2'b0;
reg [3:0]CAT = 4'b0;
reg [10:0]disp = 4'b0;
reg sign = 1;
reg [3:0] hundreds = 0;
reg[3:0] tens = 0;
reg [3:0] ones = 0;
integer i;
reg [19:0] refresh_disp = 20'b0;

	
		
always @(posedge clk)
begin	
	if (rst)
		begin
			disp = 11'b0;
			sign <= 1;
			ones = 0;
			tens = 0;
			hundreds = 0;
		end
	
	else if (sel) 
		begin
			if(data_in[10]== 1'b1) // check for input sign
				begin
				disp = -data_in;
				sign <= 0; // "-" in A4
				end
			else 
				begin
				disp = data_in;
				sign <= 1; //nothing in the A4
				end
		
			hundreds = 4'd0;
			tens = 4'd0;
			ones = 4'd0;
			
			for(i=10; i>=0;i=i-1)
				begin
					if (hundreds >= 5) hundreds = hundreds + 3;
					if (tens >= 5) tens = tens + 3;
					if(ones >=5) ones = ones + 3;

				//shift left one
					hundreds = hundreds << 1;
					hundreds[0] = tens [3];
					tens = tens << 1;
					tens[0] = ones[3];
					ones = ones << 1;
					ones[0]= disp[i];
				end // for
		
			refresh_disp=20'b0;
		end // else if (sel)
		
	refresh_disp = refresh_disp + 1;
	AN = refresh_disp[19:18]; 
		
end // always @(posedge clk)


always @(*)
begin		
	case(AN)
		2'b00: begin 
			data_out[11:8] <= 4'b1110; // "A1"
			CAT = ones;
			end
		2'b01: begin
			data_out[11:8] <= 4'b1101; // "A2"
			CAT = tens;		
			end
		2'b10: begin
			data_out[11:8] <= 4'b1011; // "A3"
			CAT = hundreds;
			end
		2'b11: begin
			data_out[11:8] <= 4'b0111; // "A4"
			CAT = {1'b1,1'b0,1'b1,sign};		
			end
	endcase
end // always @(*)

always @(*)
begin
	case(CAT)
		4'b0000: data_out[7:0] <= 8'b00000011; // "0"     
	   4'b0001: data_out[7:0] <= 8'b10011111; // "1" 
	   4'b0010: data_out[7:0] <= 8'b00100101; // "2" 
	   4'b0011: data_out[7:0] <= 8'b00001101; // "3" 
	   4'b0100: data_out[7:0] <= 8'b10011001; // "4" 
	   4'b0101: data_out[7:0] <= 8'b01001001; // "5" 
	   4'b0110: data_out[7:0] <= 8'b01000001; // "6" 
	   4'b0111: data_out[7:0] <= 8'b00011111; // "7" 
	   4'b1000: data_out[7:0] <= 8'b00000001; // "8"     
	   4'b1001: data_out[7:0] <= 8'b00001001; // "9" 
	   4'b1010: data_out[7:0] <= 8'b11111101; // "-"
	   default: data_out[7:0] <= 8'b11111111; // "none"
	endcase
end // always @(*)

endmodule

