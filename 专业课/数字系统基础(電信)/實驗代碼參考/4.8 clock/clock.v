module clock
(
	CLK, RSTn, DispWeek_n, AdjtWeek, AdjtHour, AdjtMin,
	Buzzer_Out, Digitron_Out, DigitronCS_Out
	
);
	 input CLK;
	 input RSTn;	//KEY0
	 input DispWeek_n;	//KEY1
	 input AdjtWeek;	//SW0	
	 input AdjtHour;	//SW2	
	 input AdjtMin;	//SW1
	 output Buzzer_Out; 
	 output [7:0]Digitron_Out; 
	 output [5:0]DigitronCS_Out;

	 wire [3:0]SecL;		
	 wire [3:0]SecH;
	 wire [3:0]MinL;		
	 wire [3:0]MinH;
	 wire [3:0]HourL;		
	 wire [3:0]HourH;
	 wire [3:0]Week;	

	TimeKeeper_module U1
	(
		.CLK( CLK ) ,
		.RSTn( RSTn ) ,	
		.AdjtWeek( AdjtWeek ) ,		// input - from top 
		.AdjtHour( AdjtHour ) ,		// input - from top 	
		.AdjtMin( AdjtMin ) ,		// input - from top 	
		.SecL( SecL ) ,	// output [3:0] - to U2, U3
		.SecH( SecH ) ,	// output [3:0] - to U2, U3	
		.MinL( MinL ) ,	// output [3:0] - to U2, U3	
		.MinH( MinH ) ,	// output [3:0] - to U2, U3	
		.HourL( HourL ) ,   // output [3:0] - to U2	
		.HourH( HourH ) ,	 // output [3:0] - to U2		 
		.Week( Week )	 // output [3:0] - to U2	 	
	);
	
	Digitron_TimeDisplay_module U2
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.DispWeek_n( DispWeek_n ) ,	// input - from top	
		.AdjtWeek( AdjtWeek ) ,	  // input - from top	
		.Digitron_Out( Digitron_Out ) ,		// output [7:0] - to top
		.DigitronCS_Out( DigitronCS_Out ) ,		// output [5:0] - to top
		.SecL( SecL ) ,	// input [3:0] - from U1
		.SecH( SecH ) ,	// input [3:0] - from U1	
		.MinL( MinL ) ,	// input [3:0] - from U1	
		.MinH( MinH ) ,	// input [3:0] - from U1	
		.HourL( HourL ) ,   // input [3:0] - from U1	
		.HourH( HourH ) ,	  // input [3:0] - from U1	
		.Week( Week ) 		// input [3:0] - from U1
	);

	Buzzer_module U3
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.SecL( SecL ) ,	// input [3:0] - from U1	
		.SecH( SecH ) ,	// input [3:0] - from U1	
		.MinL( MinL ) ,	// input [3:0] - from U1	
		.MinH( MinH ) ,	// input [3:0] - from U1	
		.Buzzer_Out( Buzzer_Out )	// output - to top 	
	);
	
endmodule
