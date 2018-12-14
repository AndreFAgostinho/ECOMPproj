`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:25:21 12/14/2018 
// Design Name: 
// Module Name:    booths_multiplier_tb 
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
module booth_tb;

reg [11:0] x;
reg [11:0] y;
wire [23:0] p;

booth_mult uut (
	      .x(x),
         .y(y),
	      
   	     // calculator interface

			.p(p)
	      );



parameter clk_period = 1000;

initial begin

x = 0;
y = 0;


#clk_period;

x = 56;
y = -12;

#clk_period;

x = 12;
y = 56;

#clk_period;

x = -33;
y = -30;

end

endmodule
