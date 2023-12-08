module adder
(
	SW_In, LED_Out
);

	 input [2:0]SW_In;
	 output [1:0]LED_Out;
	 
	Adder_module U1
	(
		.a( SW_In[1] ) ,	// input - from top
		.b( SW_In[0] ) ,	// input - from top
		.c_in( SW_In[2] ) ,	// input - from top
		.s( LED_Out[0] ) ,	// output - to top
		.c_out( LED_Out[1] ) 	// output - to top
	);

endmodule 