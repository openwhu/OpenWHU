module dac_module
(
	CLK, Wave_Data, DA_CLK, DA_Data_Out
);

   input CLK;
	input [7:0]Wave_Data;
   output DA_CLK; 
   output [7:0]DA_Data_Out; 

   assign DA_CLK = CLK;		
	assign DA_Data_Out = Wave_Data;

	
	
endmodule