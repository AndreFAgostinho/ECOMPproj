`timescale 1ns / 1ps


module xdisp (
			input			clk, // System clock
			input			sel, // Module selection input
			input			rst, // Module reset input
			input	 [10:0]	data_in, // Number input with Overflow bit
			output reg[11:0]	data_out // 7 segment display control signals
	      );
reg [1:0]AN=4'b0;
reg [3:0]CAT=4'b0;
reg [10:0]disp=4'b0;
reg [3:0]sign=4'b0;
reg previous_state;



	
		
always @(posedge clk) begin
	
	if (rst) data_out <= 12'b0;
	if (AN==4) AN<=2'b00;
	
	if (sel==previous_state) AN <= AN+1;
		
		  else begin
	
		           if(data_in[10]== 1'b1) begin
			         
			          disp <= -data_in;
			          sign<=4'b1010; // "-" in A4
		           end
		           else begin
			          sign<= 4'b1011; //nothing in the A4
			          disp <= data_in;
					 end	   
		
		AN <= 2'b00; 
		
		previous_state <= sel;
		end
		

		case(AN)
		2'b00: begin 
		data_out[11:8] <= 4'b0001; // "A1"
		CAT<=   (((disp) % 100)%10)/1;
		
		end
		2'b01: begin
		data_out[11:8] <= 4'b0010; // "A2"
		CAT<= (disp % 100)/10;
		end
		2'b10: begin
		data_out[11:8] <= 4'b0100; // "A3"
		CAT <= disp/100;
		end
		2'b11: begin
		data_out[11:8] <= 4'b1000; // "A4"
		CAT<=sign;
		end
		endcase
		
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
		end
    

endmodule

