`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////
// 12 x 12 bit booth radix-4 multiplier for signed integers
// Pulse start to start multiplying (hold start high for less than 6 cycles)
// When the multiplication is done (always after 6 cycles) 
// the ready output goes high
/////////////////////////////////////////////////////////////////////////////
module booth_mult(prod,ready,multiplicand,multiplier,start,clk);

	input [11:0]  multiplicand, multiplier;
    input         start, clk;
    output [23:0] prod;
    output        ready;

    reg [24:0]    product = 0;
    
    assign prod = product[23:0];

    reg [4:0]     bit_index = 0; 
    wire          ready = !bit_index;
    reg           lostbit = 0;
   

    wire [12:0]   multsx = {multiplicand[11],multiplicand}; // signal extended multiplicand

	always @( posedge clk )

		if( ready && start ) begin

        bit_index = 6; // iterate 6 groups of two bits
        product = { 13'b0, multiplier };
        lostbit = 0;
        
		end 
		else if( bit_index ) begin

			case ( {product[1:0],lostbit} )
				// 3'b000: do nothing
				3'b001: product[24:12] = product[24:12] + multsx; // +M
				3'b010: product[24:12] = product[24:12] + multsx; // +M
				3'b011: product[24:12] = product[24:12] + (multiplicand << 1); // +2M
				3'b100: product[24:12] = product[24:12] - (multiplicand << 1); // -2M
				3'b101: product[24:12] = product[24:12] - multsx; // -M
				3'b110: product[24:12] = product[24:12] - multsx; // -M
				// 3'b111: do nothing
			endcase

			  lostbit = product[1];
			  product = { product[24], product[24], product[24:2] };
			  bit_index = bit_index - 1;

     end

endmodule
