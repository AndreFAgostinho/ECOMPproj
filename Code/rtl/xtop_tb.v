`timescale 1ns / 1ps

`include "xdefs.vh"
`include "xregfdefs.vh"

module xtop_tb;
   
   //parameters 
   parameter clk_period = 20;
	parameter ps2_clk_period = 50000;

   //
   // Interface signals
   //
   reg clk;
   reg rst;

   // calculator interface

   reg ps2_data;
   reg ps2_clk;

   wire push_AC;
   wire push_C;

   wire[11:0]  disp_ctrl;
	
	wire [7:0]   gpo_out;
   

   //iterator and timer
   integer 		   k, start_time;

   // Testbench data memory
   reg [`DATA_W-1:0] data [2**`REGF_ADDR_W-1:0];
	
	// PS2 input data
	reg [10:0] ps2_input_data [29:0];
	reg [3:0] ps2_bit_index;
	reg [4:0] ps2_byte_index;
   
   // Instantiate the Unit Under Test (UUT)
   xtop uut (
	      .clk(clk),
         .rst(rst),
	      
   	     // calculator interface
         
          .ps2_data(ps2_data),
          .ps2_clk(ps2_clk),
          .push_AC(push_AC),
          .push_C(push_C),
          .disp_ctrl(disp_ctrl),
			 .gpo_out(gpo_out)
    
	      );
   
   initial begin
      
`ifdef DEBUG
      $dumpfile("xtop.vcd");
      $dumpvars();
`endif
        
      // Initialize Inputs
      clk = 1;
      rst = 0;
		ps2_clk = 1;
		ps2_data = 1;
		
		ps2_byte_index = 0;
		ps2_bit_index = 0;
		
		for (k = 0; k < 30; k=k+1) begin
	   ps2_input_data[k][0] = 0;
		ps2_input_data[k][9] = 1;
		ps2_input_data[k][10] = 1;
		end
		
		// +
		ps2_input_data[0][8:1] = 8'h79;
		ps2_input_data[1][8:1] = 8'hF0;
		ps2_input_data[2][8:1] = 8'h79;
		
		// 1
		ps2_input_data[3][8:1] = 8'h69;
		ps2_input_data[4][8:1] = 8'hF0;
		ps2_input_data[5][8:1] = 8'h69;
		
		// 6
		ps2_input_data[6][8:1] = 8'h74;
		ps2_input_data[7][8:1] = 8'hF0;
		ps2_input_data[8][8:1] = 8'h74;
		
		// <-
		ps2_input_data[9][8:1] = 8'h5A;
		ps2_input_data[10][8:1] = 8'hF0;
		ps2_input_data[11][8:1] = 8'h5A;
		
		// -
		ps2_input_data[12][8:1] = 8'h7B;
		ps2_input_data[13][8:1] = 8'hF0;
		ps2_input_data[14][8:1] = 8'h7B;
		
		// <-
		ps2_input_data[15][8:1] = 8'h5A;
		ps2_input_data[16][8:1] = 8'hF0;
		ps2_input_data[17][8:1] = 8'h5A;
		
		// -
		ps2_input_data[18][8:1] = 8'h7B;
		ps2_input_data[19][8:1] = 8'hF0;
		ps2_input_data[20][8:1] = 8'h7B;
		
		// 8
		ps2_input_data[21][8:1] = 8'h75;
		ps2_input_data[22][8:1] = 8'hF0;
		ps2_input_data[23][8:1] = 8'h75;
		
		// 9
		ps2_input_data[24][8:1] = 8'h7D;
		ps2_input_data[25][8:1] = 8'hF0;
		ps2_input_data[26][8:1] = 8'h7D;
		

		// <-
		ps2_input_data[30][8:1] = 8'h5A;
		ps2_input_data[31][8:1] = 8'hF0;
		ps2_input_data[32][8:1] = 8'h5A;		
		

     // assert reset for 1 clock cycle
      #(clk_period+1)
      rst = 1;
      #clk_period
      rst = 0;

		
      
      //
      // Run picoVersat
      //

      start_time = $time;
		
      while(1'b1) #clk_period;

      $display("Execution time in clock cycles: %0d",($time-start_time)/clk_period);

      //
      // Dump reg file data to outfile
      //
  
      //$writememh("data_out.hex", data, 0, 2**`REGF_ADDR_W - 1);

      //
      // End/pause simulation
      //
      #clk_period $finish;
      // #clk_period $stop;

   end // initial begin

   
   always
     #(clk_period/2) clk = ~clk;
	  
	always
	  #(ps2_clk_period/2) ps2_clk = ~ps2_clk;
	  
	always @(posedge(ps2_clk))
		begin
		if (ps2_byte_index < 30)
			ps2_data = ps2_input_data[ps2_byte_index][ps2_bit_index];
		else ps2_data = 1;
		
		if (ps2_bit_index == 10) begin
			ps2_bit_index <= 0;
			ps2_byte_index <= ps2_byte_index + 1;
		end
		else ps2_bit_index <= ps2_bit_index + 1;
	end

   // show registers
   wire [`DATA_W-1:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;

   assign r0 = uut.regf.reg_1[0];
   assign r1 = uut.regf.reg_1[1];
   assign r2 = uut.regf.reg_1[2];
   assign r3 = uut.regf.reg_1[3];
   assign r4 = uut.regf.reg_1[4];
   assign r5 = uut.regf.reg_1[5];
   assign r6 = uut.regf.reg_1[6];
   assign r7 = uut.regf.reg_1[7];
   assign r8 = uut.regf.reg_1[8];
   assign r9 = uut.regf.reg_1[9];
   assign r10 = uut.regf.reg_1[10];
   assign r11 = uut.regf.reg_1[11];
   assign r12 = uut.regf.reg_1[12];
   assign r13 = uut.regf.reg_1[13];
   assign r14 = uut.regf.reg_1[14];
   assign r15 = uut.regf.reg_1[15];  

endmodule

