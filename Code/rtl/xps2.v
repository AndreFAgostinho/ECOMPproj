`timescale 1ns / 1ps


module xps2 (
			input			clk, // System clock
			input			sel, // Module selection input
			input			rst, // Module reset input
			input			ps2_clk, // Clock pin form keyboard
			input			ps2_data, //Data pin form keyboard
			output reg[8:0]	data_out // Keypress data output and valid bit
	      );

reg [10:0] scan_code = 11'b0;
reg new_scan_code = 1'b0;
reg [3:0] count = 4'b0;
reg previous_state;			
reg trigger;
reg trig_arr;
reg [7:0] downcounter= 8'b0;	
	
	
always @(posedge clk) begin	
				
		if (rst) begin
		data_out <= 9'b0;
		scan_code <= 11'b0;
		count <= 4'b0;
		trig_arr <= 1'b0;
		trigger <= 1'b0;
		downcounter <= 8'b0;
		previous_state <= 1'b0;
		end
		if (downcounter< 249) begin			 
			downcounter <= downcounter + 1;
			trigger <= 1'b0;
		end
		else begin
			downcounter <= 1'b0;
			trigger <= 1'b1;
		end
		
		if (trigger) begin						
			if (ps2_clk != previous_state) begin			
				if (!ps2_clk) begin				
					count <= count + 1;
					scan_code[10:0] <= {ps2_data, scan_code[10:1]};					
				end
			end
		
			else if (count == 11) begin				
				trig_arr <= 1'b1;	
				count <=1'b0;
			end	
		else						
			trig_arr <= 1'b0;								
			previous_state <= ps2_clk;					

		end
		
		if (trigger) begin					
			if (trig_arr) begin
				data_out[7:0] <= scan_code[8:1];	
				data_out[8] <= 1'b1; 
			end				
		end					
	

end
	
	
endmodule

