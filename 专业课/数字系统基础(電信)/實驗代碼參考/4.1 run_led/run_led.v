module run_led
(
    CLK, RSTn, LED_Out
);

    input CLK;		// Clock
	 input RSTn;	// Reset
	 output [7:0]LED_Out;

	led8_module U1
	(
		.CLK( CLK ) ,	// input  
		.RSTn( RSTn ) ,	// input   
		.LED_Out( LED_Out ) 	// output [7:0] - to top
	);	


endmodule