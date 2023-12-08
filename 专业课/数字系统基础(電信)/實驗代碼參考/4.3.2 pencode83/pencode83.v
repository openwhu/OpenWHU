module pencode83
(
	CLK, Sw_In, LED_Out, Valid
);
	 input CLK;
	 input wire [7:0]Sw_In;
	 output wire [2:0]LED_Out;
	 output wire Valid;		

	pencode_module U1
	(
		.CLK( CLK ) ,	// input  
		.x( Sw_In ) ,	// input [7:0] - from top
		.y( LED_Out ) ,	// output [2:0] - to top
		.Valid( Valid ) 	// output - to top
	);
	
endmodule 