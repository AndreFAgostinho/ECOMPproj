module booth_mult(prod,ready,multiplicand,multiplier,start,clk);

   input [11:0]  multiplicand, multiplier;
   input         start, clk;
   output        prod;
   output        ready;

   reg [24:0]    product = 0;
   wire [23:0]   prod = product[23:0];


   reg [4:0]     bit = 0; 
   wire          ready = !bit;
   reg           lostbit = 0;
   
   initial bit = 0;

   wire [12:0]   multsx = {multiplicand[11],multiplicand}; // signal extended multiplicand

   always @( posedge clk )

     if( ready && start ) begin

        bit     = 6;
        product = { 13'd0, multiplier };
        lostbit = 0;
        
     end else if( bit ) begin

        case ( {product[1:0],lostbit} )
          3'b001: product[24:12] = product[24:12] + multsx;
          3'b010: product[24:12] = product[24:12] + multsx;
          3'b011: product[24:12] = product[24:12] + 2 * multiplicand;
          3'b100: product[24:12] = product[24:12] - 2 * multiplicand;
          3'b101: product[24:12] = product[24:12] - multsx;
          3'b110: product[24:12] = product[24:12] - multsx;
        endcase

        lostbit = product[1];
        product = { product[24], product[24], product[24:2] };
        bit     = bit - 1;

     end

endmodule
