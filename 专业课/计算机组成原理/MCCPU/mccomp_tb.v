
// testbench for simulation
module mccomp_tb();
    
   reg  clk, rstn;
   reg  [4:0] reg_sel;
   wire [31:0] reg_data;
    
// instantiation of sccomp    
   mccomp U_MCCOMP(
      .clk(clk), .rstn(rstn), .reg_sel(reg_sel), .reg_data(reg_data) 
   );
   
   initial begin
      $readmemh( "mipstest_extloop.dat" , U_MCCOMP.U_DM.dmem); // load instructions into instruction memory
//      $monitor("PC = 0x%8X, instr = 0x%8X", U_MCCOMP.PC, U_MCCOMP.instr); // used for debug
      clk = 1;
      rstn = 1;
      #5 ;
      rstn = 0;
      #20 ;
      rstn = 1;
      #1000 ;
      reg_sel = 7;
   end
   
   always begin
    #(50) clk = ~clk;
   end //end always
   
endmodule
