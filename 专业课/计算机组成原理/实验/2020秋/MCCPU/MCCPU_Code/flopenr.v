module flopenr #(parameter WIDTH = 8)
              (clk, rst, en, d, q);

   input              clk;
   input              rst;
   input              en;
   input  [WIDTH-1:0] d;
   output reg [WIDTH-1:0] q;

 
   always @(posedge clk, posedge rst)
      if (rst)
         q <= 0;
      else if (en)
         q <= d;

endmodule
