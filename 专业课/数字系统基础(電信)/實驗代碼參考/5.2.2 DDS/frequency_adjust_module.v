module frequency_adjust_module
(
	CLK, RSTn, KW_Add_In, KW_Sub_In, KW
);
	 input CLK;
	 input RSTn;
	 input KW_Add_In;
	 input KW_Sub_In;
	 output [11:0]KW;		// frequency control words
	 
	 wire KW_Add_Sig;
	 wire KW_Sub_Sig;
	 reg [11:0]KWr;
	 
	Jitter_Elimination_module U1
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.Button_In( KW_Add_In ) ,	// input - from top
		.Button_Out( KW_Add_Sig ) 	// output - to top
	);
	 
 	Jitter_Elimination_module U2
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.Button_In( KW_Sub_In ) ,	// input - from top
		.Button_Out( KW_Sub_Sig ) 	// output - to top
	);
	
	always @ ( posedge CLK or negedge RSTn )
		begin
			if( !RSTn ) 
				KWr <= 12'd5;
			else if( KW_Add_Sig == 1 ) 
				if ( KWr == 'd10 )
					KWr <= 12'd1;
				else 
					KWr <= KWr + 'd1;
			else if( KW_Sub_Sig == 1 ) 
				if ( KWr == 'd1 )
					KWr <= 12'd10;
				else 
					KWr <= KWr - 'd1;
		end
		
	assign KW = KWr;
	
endmodule
		
		
		
		
		
		
		