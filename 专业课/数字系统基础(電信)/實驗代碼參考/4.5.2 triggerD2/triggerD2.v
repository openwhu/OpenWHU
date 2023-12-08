module triggerD2
(
	CLK, Setn, Clrn, Sw_In, LED_Out
);
	 input wire CLK;
	 input wire Setn;
	 input wire Clrn;
	 input wire [7:0]Sw_In;
	 output wire [7:0]LED_Out;

	trigger_module U1
	(
		.CLK( CLK ) ,	
		.Setn( Setn ) ,	
		.Clrn( Clrn ) ,	
		.D( Sw_In ) ,	
		.Q( LED_Out ) 	
	);
	
endmodule 