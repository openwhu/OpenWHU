module counter24
(
	CLK, RSTn, Digitron_Out, DigitronCS_Out
);
	 input CLK;
	 input RSTn;	 //SW0
	 output [7:0]Digitron_Out;
	 output [5:0]DigitronCS_Out;

	 wire [7:0]Result;
	 
	Accumulator_module U1
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	 
		.Result( Result )		// output [7:0] - to U2	 	
	);	 
	
	Digitron_NumDisplay_module U2
	(
		.CLK( CLK ) ,	 // input 
		.Result( Result ) ,	 // input [7:0] - from U1	
		.Digitron_Out( Digitron_Out ) ,	 // output [7:0] - to top	
		.DigitronCS_Out( DigitronCS_Out )  	// output [5:0] - to top	
	);

endmodule 
	