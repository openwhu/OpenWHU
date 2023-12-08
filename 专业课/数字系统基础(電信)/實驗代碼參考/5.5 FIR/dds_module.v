module dds_module
(
	CLK, RSTn, Sin6K_Out , Sin24K_Out
);

	 input CLK;
	 input RSTn;			
	 
	 output [6:0]Sin6K_Out;
	 output [6:0]Sin24K_Out;

/***************************************/	 
	 reg [12:0]Cnt1;
	 wire [12:0]addr6k;
	 wire [12:0]KW1 = 'b1; 
	 
	always @ ( posedge CLK or negedge RSTn )
		begin
			if( !RSTn ) 
				Cnt1 <= 13'd0;
			else if( Cnt1 == 13'd8191 )
				Cnt1 <= 13'd0;	
			else	
				Cnt1 <= Cnt1 + KW1;
		end
		
	 assign addr6k = Cnt1;
	 
/********************************/		 
	 reg [10:0]Cnt2;
	 wire [10:0]addr24k;
	 wire [10:0]KW2 = 'b1; 
	 
	always @ ( posedge CLK or negedge RSTn )
		begin
			if( !RSTn ) 
				Cnt2 <= 11'd0;
			else if( Cnt2 == 11'd2047 )
				Cnt2 <= 11'd0;	
			else	
				Cnt2 <= Cnt2 + KW2;
		end
		
	 assign addr24k = Cnt2;
	 

/*****************************************/	 
	sin6k_rom	U1
	(
		.address ( addr6k ),		//input - from top
		.clock ( CLK ),			//input - from top
		.q ( Sin6K_Out )			//output - to top
	);

	sin24k_rom	U2
	(
		.address ( addr24k ),	//input - from top
		.clock ( CLK ),			//input - from top
		.q ( Sin24K_Out )			//output - to top
	);
	
/************************************/	 
	 
endmodule