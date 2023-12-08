module mux81
(
	CSn, Sw_In, Key_In0, Key_In1, Key_In2, Key_In3, Key_In4, Key_In5,Key_In6, Key_In7, LED_Out
);
	 input CSn;
	 input [2:0]Sw_In;
	 input [width-1:0]Key_In0, Key_In1, Key_In2, Key_In3, Key_In4, Key_In5,Key_In6, Key_In7;	 
	 output [width-1:0]LED_Out;

	 parameter width = 1 ;
	 
	mux81_module U1
	(
		.CSn( CSn ) ,	// input  CSn_sig
		.A( Sw_In ) ,	// input [2:0] - from top
		.D0( Key_In0 ) ,	// input [width-1:0] - from top
		.D1( Key_In1 ) ,	// input [width-1:0] - from top
		.D2( Key_In2 ) ,	// input [width-1:0] - from top
		.D3( Key_In3 ) ,	// input [width-1:0] - from top
		.D4( Key_In4 ) ,	// input [width-1:0] - from top
		.D5( Key_In5 ) ,	// input [width-1:0] - from top
		.D6( Key_In6 ) ,	// input [width-1:0] - from top
		.D7( Key_In7 ) ,	// input [width-1:0] - from top
		.Y( LED_Out ) 	// output [width-1:0] - to top
	);	 

endmodule 
				