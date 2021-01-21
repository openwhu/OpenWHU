
// data memory
module dm(clk, DMWr, addr, din, dout);
   input          clk;
   input          DMWr;
   input  [8:2]   addr;
   input  [31:0]  din;
   output [31:0]  dout;
     
   reg [31:0] dmem[127:0];
   wire [31:0] addrByte;

   assign addrByte = addr<<2;
      
   assign dout = dmem[addrByte[8:2]];
   
   always @(posedge clk)
      if (DMWr) begin
        dmem[addrByte[8:2]] <= din;
        $display("dmem[0x%8X] = 0x%8X,", addrByte, din); 
      end
   
endmodule    
