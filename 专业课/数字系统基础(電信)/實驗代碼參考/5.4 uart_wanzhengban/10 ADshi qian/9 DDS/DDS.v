module DDS
(
	CLK, RSTn, KW_Add_In, KW_Sub_In, SW_Sin_In, SW_Square_In, SW_Sawtooth_In, DA_CLK, DA_Data
);

	 input CLK;
	 input RSTn;			//SW0
	 input KW_Add_In;		//KEY0
	 input KW_Sub_In;		//KEY1
	 input SW_Sin_In;		//SW1
	 input SW_Square_In;		//SW2
	 input SW_Sawtooth_In;	//SW3
	 
	 output DA_CLK;
	 output [7:0]DA_Data;
	
	 wire [11:0]KW;
	 wire [7:0]Wave_Data;
	 
	frequency_adjust_module U1
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.KW_Add_In( KW_Add_In ) ,	// input - from top
		.KW_Sub_In( KW_Sub_In ) ,	// input - from top
		.KW_Out( KW ) 	// output - to U2
	);

	choose_wave_module U2
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,
		.SW_Sin_In( SW_Sin_In ) ,	// input - from top
		.SW_Square_In( SW_Square_In ) ,	// input - from top
		.SW_Sawtooth_In( SW_Sawtooth_In ) ,	// input - from top
		.KW_In( KW ) ,	// input - from U1
		.Wave_Data( Wave_Data ) 	// output - to U3
	);

	dac_module U3
	(
		.CLK( CLK ) ,	
		.Wave_Data( Wave_Data ) ,	// input - from U2
		.DA_CLK( DA_CLK ) ,	// output - to top
		.DA_Data_Out( DA_Data ) 	// output - to top
	);


endmodule