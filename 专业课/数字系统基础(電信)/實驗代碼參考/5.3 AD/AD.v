module AD
(
	CLK, RSTn, AD_EOC, AD_DigData_In, AD_CSn, AD_Clk, AD_Address, 
	Data_Out, CS_Valid_Sig, Digitron_Out, DigitronCS_Out
);

	 input CLK;
	 input RSTn;		//SW0
	 
	 input AD_EOC;
	 input AD_DigData_In;	 
	 output AD_CSn;
	 output AD_Clk;
	 output AD_Address;
	 
	 output [9:0]Data_Out;			 	 	 
	 output CS_Valid_Sig;
	 output [7:0]Digitron_Out; 
	 output [5:0]DigitronCS_Out;
	
	
	 
	AD_Data U1
	(
		.CLK( CLK ) ,	// input 
		.RSTn( RSTn ) ,	// input 
		.AD_DigData_In( AD_DigData_In ) ,	// input - from top
		.AD_CSn( AD_CSn ) ,	// output - to rop
		.AD_Clk( AD_Clk ) ,	// output - to rop
		.AD_Address( AD_Address ) ,	// output - to top
		.Data_Out( Data_Out ) ,	// output [9:0] - to U2, top
		.CS_Valid_Sig( CS_Valid_Sig ) 	// output - to rop
	);
	

	Digitron_NumDisplay U2
	(
		.CLK( CLK ) ,	 
		.Data( Data_Out ) ,	// input [9:0] - from U1
		.Digitron_Out( Digitron_Out ) ,	// output [7:0] - to top
		.DigitronCS_Out( DigitronCS_Out ) 	// output [5:0] - to top
	);

/************************************/ 		 	 	
	 wire Clk_100K;

	pll_100K	U3 
	(
		.inclk0 ( CLK ),
		.c0 ( Clk_100K )
	);
	
/****	
	 wire Clk_10M;
	 
	PLL2	PLL2_inst
	(
		.inclk0 ( CLK ),
		.c0 ( Clk_10M )
	);
***********************************/	
 
endmodule


	