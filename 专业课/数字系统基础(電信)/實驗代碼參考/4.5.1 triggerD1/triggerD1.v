module triggerD1
(
	CLK, Setn, Clrn, Sw_In, LED_Out
);
	
    input CLK;
	 input Setn;
	 input Clrn;
	 input Sw_In;
	 output LED_Out;

	trigger_module U1
	(
		.CLK( CLK ) ,	// input  
		.Setn( Setn ) ,	// input - from top
		.Clrn( Clrn ) ,	// input - from top
		.D( Sw_In ) ,	// input - from top
		.Q( LED_Out ) 	// output - to top
	);	
	
endmodule 