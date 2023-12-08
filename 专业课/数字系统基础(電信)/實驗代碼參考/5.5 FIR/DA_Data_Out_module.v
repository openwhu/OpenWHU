module DA_Data_Out_module
(
	CLK, RSTn, DA_Data_In, DA_CLK, DA_Data
);

   input CLK;
   input RSTn;
	input [7:0]DA_Data_In;
	
   output DA_CLK; 
   output reg[7:0]DA_Data;  

   assign DA_CLK = CLK ;		

   always @( posedge CLK or negedge RSTn )
		begin
			if( !RSTn )
				DA_Data <= 0;
			else 
				DA_Data <= DA_Data_In;  
		end

endmodule