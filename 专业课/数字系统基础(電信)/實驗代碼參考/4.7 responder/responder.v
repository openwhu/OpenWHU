module responder
(
	RSTn, CLK, Start, Key_In, LED_Out, Buzzer_Out, LED_OverTime_Out, Digitron_Out, DigitronCS_Out
);
	 input RSTn;	//SW0
	 input CLK; 
	 input Start;		//SW1
	 input [3:0]Key_In; 
	 output [3:0]LED_Out;
	 output Buzzer_Out;
	 output LED_OverTime_Out;		//LED4
	 output [7:0]Digitron_Out; 
	 output [5:0]DigitronCS_Out;
	 
	 wire [3:0]Player_Number;
	 wire [3:0]TimerH;
	 wire [3:0]TimerL;
	 wire Buzzer_Answer;
	 wire Buzzer_TimeOver;
	 wire Timer_Start;

	Sel_module U1
	(
		.RSTn( RSTn ) ,
		.CLK( CLK ) ,	
		.Start( Start ) ,		// input - from top
		.K1( Key_In[0] ) ,	// input - from top	
		.K2( Key_In[1] ) ,	// input - from top
		.K3( Key_In[2] ) ,	// input - from top
		.K4( Key_In[3] ) ,	// input - from top	       
		.LED_Out( LED_Out ) ,	// output [3:0] - to top	
		.Player_Number( Player_Number ) ,	// output [3:0] - to U4	
		.Buzzer_Answer( Buzzer_Answer ) ,	// output - to U3
		.Timer_Start( Timer_Start ) 	// output - to U2
	);

	Timer_module U2
	(
		.RSTn( RSTn ) ,	
		.CLK( CLK ) ,	
		.Timer_Start( Timer_Start ) ,		// input - from top	
		.TimerH( TimerH ) ,	// output [3:0] - to U4	
		.TimerL( TimerL ) ,	// output [3:0] - to U4	
		.Buzzer_TimeOver( Buzzer_TimeOver ) ,	// output - to U3	
		.LED_OverTime( LED_OverTime_Out )	// output - to top 	
	);

	Buzzer_module U3
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.Buzzer_Answer( Buzzer_Answer ) ,	// input - from U1
		.Buzzer_TimeOver( Buzzer_TimeOver ) ,	// input - from U2
		.Buzzer_Out( Buzzer_Out ) 		// output - to top
	);

	Digitron_NumDisplay_module U4
	(
		.CLK( CLK ) ,
		.Player_Number( Player_Number ) ,	// input [3:0] - from U1
		.TimerH( TimerH ) ,	// input [3:0] - from U2
		.TimerL( TimerL ) ,	// input [3:0] - from U2
		.Digitron_Out( Digitron_Out ) ,	// output - to top	
		.DigitronCS_Out( DigitronCS_Out ) 	// output - to top	
	);

endmodule 