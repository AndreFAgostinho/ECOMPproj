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
		  output	[11:0]	disp_ctrl,
          
          // LED ouput
          output [7:0]	      gpo_out
		  
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

   // MODULE SELECTION AND RESET SIGNALS
   reg 				  prog_sel;
   wire [`DATA_W-1:0] 		  prog_data_to_rd;
   
   reg 				  regf_sel;
   wire [`DATA_W-1:0] 		  regf_data_to_rd;

`ifdef DEBUG
   reg 				  cprt_sel;
`endif

	reg					ps2_sel;
    reg                 ps2_rst;
	wire [8:0]			ps2_data_to_rd;
	reg					pushs_sel;
    reg                 pushs_rst;
	wire [1:0]			pushs_data_to_rd;
	reg					disp_sel;
    reg                 disp_rst;
    reg                 gpo_sel;
    reg                 gpo_rst;


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
		pushs_sel = 1'b0;
        pushs_rst = 1'b0;
		ps2_sel = 1'b0;
        ps2_rst = 1'b0;
		disp_sel = 1'b0;
        disp_rst = 1'b0;
        gpo_sel = 1'b0;
        gpo_rst = 1'b0;
		
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

	    else if (`PUSH_BASE == data_addr) begin
	        pushs_sel = 1'b1;
			  data_to_rd = pushs_data_to_rd;
	    end
	    else if(`PS2_BASE == data_addr) begin
	        ps2_sel =1'b1;
			  data_to_rd = ps2_data_to_rd;
		 end
	    else if(`DISP_BASE == data_addr)
	        disp_sel =1'b1;
        else if (`GPO_BASE == data_addr)
	        gpo_sel = 1'b1;
	  
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
	       .ext_we(1'b1),
	       .ext_addr(4'b0),
	       .ext_data_in(32'b1),
	       .ext_data_out(),
			
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

   xps2 ps2 (
			.clk(clk),
			.sel(ps2_sel),
			.rst(rst),
			.ps2_clk(ps2_clk),
			.ps2_data(ps2_data),
			.data_out(ps2_data_to_rd)
			);
			
	xpushs pushs (
			.clk(clk),
			.sel(pushs_sel),
			.rst(rst),
			.push_C(push_C),
			.push_AC(push_AC),
			.data_out(pushs_data_to_rd)
			);


			
	xdisp disp (
			.clk(clk),
			.sel(disp_sel),
			.rst(rst),
			.data_in(data_to_wr[11:0]),
			.data_out(disp_ctrl)
			);

    xgpo gpo (
	    .clk(clk),
        .sel(gpo_sel),
	    .rst(gpo_rst),
	    .data_in(data_to_wr[7:0]),
	    .data_out(gpo_out)
    );
			
endmodule
