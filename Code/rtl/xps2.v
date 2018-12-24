`timescale 1ns / 1ps


module xps2 (
			input			clk, // System clock
			input			sel, // Module selection input
			input			rst, // Module reset input
			input			ps2_clk, // Clock pin form keyboard
			input			ps2_data, //Data pin form keyboard
			output reg[8:0]	data_out // {new_bit, scan_code} Keypress data output and new bit
	      );

reg [9:0] scan_code = 10'b0; // {stop_bit, parity_bit, scan_code_byte} start bit is ignored

reg [3:0] count = 4'b0;
reg previous_state;			
reg trigger;
reg trig_arr;
reg [7:0] downcounter= 8'b0;	
reg previous_sel;
reg  key_released;

always @(posedge clk) begin	
					
	if (rst) begin
		data_out <= 9'b0;
		scan_code = 10'b0;
		count <= 4'b0;
		trig_arr <= 1'b0;
		trigger <= 1'b0;
		downcounter <= 8'b0;
		previous_state <= 1'b0;
		previous_sel <=1'b0;
	end
	
	// sample the ps2 clk at a frequency lower than the system clock
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
				scan_code[9:0] = {ps2_data, scan_code[9:1]}; // shift the bits in
			end
		end
		else if (count == 11) begin // byte transfer finished
			trig_arr <= 1'b1;	
			count <=1'b0;
		end	
		else						
			trig_arr <= 1'b0;
			
		previous_state <= ps2_clk;					

	end
	
	if (trigger) begin					
		if (trig_arr) begin
			if (scan_code [7:0] == 8'hF0) key_released <= 1'b1;
			if (key_released == 1 && scan_code[7:0]!= 8'hF0) data_out[8] <= 1'b1; // set 'new' bit
			data_out[7:0] <= scan_code[7:0];
		end				
	end
	
	// when 'sel' is driven low reset the 'new' bit
	if (sel == 1 && previous_sel ==0 && data_out[8]==1) begin
		data_out[8] <= 1'b0;
		key_released <= 0;
	end
	previous_sel <= sel;
			
end
	
	
endmodule

