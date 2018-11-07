`timescale 1ns / 1ps

`include "xdefs.vh"
`include "xctrldefs.vh"
`include "xprogdefs.vh"
`include "xregfdefs.vh"


module xtop (
	    
	     //MANDATORY INTERFACE SIGNALS
	     input 		      clk,
	     input 		      rst,
		  
		  // PS2 signals
		  input				ps2_data,
		  input				ps2_clk,
		  
		  // Push button signals
		  input				push_AC,
		  input				push_C,
		  
		  // 7 segment display control signals
		  output	[11:0]	disp_ctrl
		  
	     );

   //
   //
   // CONNECTION WIRES
   //
   //
   
   // PROGRAM MEMORY/CONTROLLER INTERFACE
   wire [`INSTR_W-1:0] 		  instruction;
   wire [`PROG_ADDR_W-1:0] 	  pc;

   // DATA BUS
   wire 			  data_sel;
   wire 			  data_we;
   wire [`ADDR_W-1:0] 		  data_addr;
   reg [`DATA_W-1:0] 		  data_to_rd;
   wire [`DATA_W-1:0] 		  data_to_wr;

   // MODULE SELECTION SIGNALS
   reg 				  prog_sel;
   wire [`DATA_W-1:0] 		  prog_data_to_rd;
   
   reg 				  regf_sel;
   wire [`DATA_W-1:0] 		  regf_data_to_rd;

`ifdef DEBUG
   reg 				  cprt_sel;
`endif

	reg					ps2_sel;
	wire [8:0]			ps2_data_to_rd;
	reg					pushs_sel;
	wire [1:0]			pushs_data_to_rd;
	reg					disp_sel;

   //
   //
   // FIXED SUBMODULES
   //
   //
   
   //
   // CONTROLLER MODULE
   //
   xctrl controller (
		     .clk(clk), 
		     .rst(rst),
		     
		     // Program memory interface
		     .pc(pc),
		     .instruction(instruction),
		     
		     // Data bus
		     .data_sel(data_sel),
		     .data_we (data_we), 
		     .data_addr(data_addr),
		     .data_to_rd(data_to_rd), 
		     .data_to_wr(data_to_wr)
		     );

   // PROGRAM MEMORY MODULE
   xprog prog (
	       .clk(clk),

	       //data interface 
	       .data_sel(prog_sel),
	       .data_we(data_we),
	       .data_addr(data_addr[`PROG_RAM_ADDR_W-1:0]),
	       .data_in(data_to_wr),
	       .data_out(prog_data_to_rd),

	       //DMA interface 
`ifdef DMA_USE
	       .dma_req(dma_prog_req),	       
	       .dma_rnw(dma_rnw),
	       .dma_addr(dma_addr[`PROG_ADDR_W-1:0]),
	       .dma_data_in(dma_data_from),
	       .dma_data_out(dma_data_from_prog),
`endif	       

	       // instruction interface
	       .pc(pc),
       	       .instruction(instruction)      
	       );


   // ADDRESS DECODER
   always @ * begin
      prog_sel = 1'b0;
      regf_sel = 1'b0;
`ifdef DEBUG
      cprt_sel = 1'b0;
`endif
      data_to_rd = `DATA_W'd0;
      
      if (`REGF_BASE == (data_addr & ({`ADDR_W{1'b1}}<<`REGF_ADDR_W))) begin
	 regf_sel = data_sel;
         data_to_rd = regf_data_to_rd;
      end
`ifdef DEBUG
      else if (`CPRT_BASE == data_addr)
	 cprt_sel = data_sel;
 `endif
     else if (`PROG_BASE == (data_addr & ({`ADDR_W{1'b1}}<<`PROG_ADDR_W))) begin
         prog_sel = 1'b1;
         data_to_rd = prog_data_to_rd;
     end
`ifdef DEBUG	
     else if(data_sel === 1'b1)
       $display("Warning: unmapped controller issued data address %x at time %f", data_addr, $time);
`endif
   end // always @ *

   //
   //
   // USER MODULES INSERTED BELOW
   //
   //
   
   // HOST-CONTROLLER SHARED REGISTER FILE
   xregf regf (
	       .clk(clk),
	       
	       //host interface (external)
	       .ext_we(par_we),
	       .ext_addr(par_addr),
	       .ext_data_in(par_in),
	       .ext_data_out(par_out),
			
	       //versat interface (internal)
	       .int_sel(regf_sel),
	       .int_we(data_we),
	       .int_addr(data_addr[`REGF_ADDR_W-1:0]),
	       .int_data_in(data_to_wr),
	       .int_data_out(regf_data_to_rd)
	       );

`ifdef DEBUG
   xcprint cprint (
		   .clk(clk),
		   .sel(cprt_sel),
		   .data_in(data_to_wr[7:0])
		   );
`endif
   
	xpushs pushs (
			.clk(clk),
			.sel(pushs_sel),
			.rst(rst),
			.push_C(push_C),
			.push_AC(push_AC),
			.data_out(pushs_data_to_rd)
			);

	xps2 ps2 (
			.clk(clk),
			.sel(ps2_sel),
			.rst(rst),
			.ps2_clk(ps2_clk),
			.ps2_data(ps2_data),
			.data_out(ps2_data_to_rd)
			);
			
	xdisp disp (
			.clk(clk),
			.sel(disp_sel),
			.rst(rst),
			.data_in(data_to_wr[11:0]),
			.data_out(disp_ctrl)
			);
			
endmodule
