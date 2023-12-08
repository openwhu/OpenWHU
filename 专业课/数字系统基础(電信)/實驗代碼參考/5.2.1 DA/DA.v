module DA
(
	CLK, RSTn, DA_CLK, DA_Data
);

   input CLK;
   input RSTn;	
   output DA_CLK; 
   output reg [7:0]DA_Data; 

   reg [7:0]Count;  

   assign DA_CLK = CLK ;		

   always @( posedge CLK or negedge RSTn )
			if( !RSTn )
				Count <= 0;
			else if ( Count == 'd255 )
				begin
					Count <= 0; 
					DA_Data <= Count[7:0] ;  
				end 
			else
				begin
					Count <= Count + 1'b1;
					DA_Data <= Count[7:0] ;  
				end

endmodule