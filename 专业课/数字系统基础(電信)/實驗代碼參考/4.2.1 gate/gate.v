module gate
(
	SW_In, LED_Out
);

	 input [1:0]SW_In;
	 output [5:0]LED_Out;

	Gate_module U1
	(
		.Gate_In( SW_In ) ,	// input [1:0] - from top
		.Gate_Out( LED_Out ) 	// output [5:0] - to top
	);

	 
endmodule 