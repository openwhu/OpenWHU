module decode38
(
	Sw_In, LED_Out
);
	
	 input wire [2:0]Sw_In;
	 output wire [7:0]LED_Out;

	decode_module U1
	(
		.a2( Sw_In[2] ) ,	// input - from top
		.a1( Sw_In[1] ) ,	// input - from top
		.a0( Sw_In[0] ) ,	// input - from top
		.y7( LED_Out[7] ) ,	// output - to top
		.y6( LED_Out[6] ) ,	// output - to top
		.y5( LED_Out[5] ) ,	// output - to top
		.y4( LED_Out[4] ) ,	// output - to top
		.y3( LED_Out[3] ) ,	// output - to top
		.y2( LED_Out[2] ) ,	// output - to top
		.y1( LED_Out[1] ) ,	// output - to top
		.y0( LED_Out[0] ) 	// output - to top
	);
endmodule