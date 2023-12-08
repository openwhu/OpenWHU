module triggerJK1
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
		.Setn( Setn ) ,	// input - from top
		.Clrn( Clrn ) ,	// input - from top	
		.J( Sw_In[7:4] ) ,	// input [4:0] - from top	
		.K( Sw_In[3:0] ) ,	// input [4:0] - from top	
		.Q( LED_Out[7:4] ) ,	// output [4:0] - to top	
		.Q_n( LED_Out[3:0] )	// output [4:0] - to top	 	
	);
			
endmodule 