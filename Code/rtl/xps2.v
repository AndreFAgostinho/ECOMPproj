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
	
always@(negedge ps2_clk) begin

	scan_code[10:0] <= {ps2_data, scan_code[10:1]};
	new_scan_code <= 0;
	if (count < 11)
		count <= count + 1;
	else if (count == 11) begin
		new_scan_code <= 1;
		count <= 0;
	end
	
end

always@(posedge clk) begin

	if (rst) data_out <= 9'b000000000;

	else if (new_scan_code) begin
		data_out[7:0] <= scan_code[9:2];
		data_out[8] <= new_scan_code;
		
	end
	
end


endmodule
