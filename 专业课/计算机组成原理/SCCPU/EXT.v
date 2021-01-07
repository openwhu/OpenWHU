
module EXT( Imm16, EXTOp, Imm32 );
    
   input  [15:0] Imm16;
   input         EXTOp;
   output [31:0] Imm32;
   
   assign Imm32 = (EXTOp) ? {{16{Imm16[15]}}, Imm16} : {16'b0, Imm16}; // signed-extension or zero extension
       
endmodule
