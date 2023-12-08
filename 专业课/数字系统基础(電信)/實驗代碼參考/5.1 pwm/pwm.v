module pwm
(
	CLK, RSTn, AddDuty_In, SubDuty_In, AddPeriod_In, SubPeriod_In,
	Count_D_Display, Count_P_Display, Digitron_Out, DigitronCS_Out, PWM_LED_Out, PWM_EPI_Out
);
	 input CLK;
	 input RSTn;			//SW0
	 input AddDuty_In;  	//KEY3
	 input SubDuty_In;	//KEY2
	 input AddPeriod_In;		//KEY1
	 input SubPeriod_In;		//KEY0
	 input Count_D_Display;		//SW1
	 input Count_P_Display;	//SW2
	 
	 output [7:0]Digitron_Out; 
	 output [5:0]DigitronCS_Out;
	 output PWM_LED_Out;		//LED0
	 output PWM_EPI_Out;		//A6
	 
	   assign PWM_EPI_Out = PWM_LED_Out;
		
	 wire [7:0]Duty; 
	 wire [23:0]Count_P;
	 wire [23:0]Count_D;

	Duty_Period_Adjust_module U1
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.AddDuty_In( AddDuty_In ) ,	// input - from top
		.SubDuty_In( SubDuty_In ) ,	// input - from top	
		.AddPeriod_In( AddPeriod_In ) ,	// input - from top	
		.SubPeriod_In( SubPeriod_In ) ,	// input - from top	
		.Duty( Duty ) ,	// output [7:0] - to U2, U3	
		.Count_P( Count_P )  	// output [23:0] - to U2, U3
	);

	PWM_Generate_module U2
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.Duty( Duty ) ,	// input [7:0] - from U1	
		.Count_P( Count_P ) ,	// input [23:0] - from U1	
		.PWM_Out( PWM_LED_Out ),	// output - to top 
		.Count_D( Count_D ) 	// output [23:0] - to U3 	
	);

	Digitron_NumDisplay_module U3
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,
		.Count_D_Display( Count_D_Display ) ,	// input - from top
		.Count_P_Display( Count_P_Display ) ,	// input - from top
		.Count_D( Count_D ) ,		// input [23:0] - from U2 
		.Count_P( Count_P ) ,	// input [23:0] - from U1 
		.Duty( Duty ) ,	// input [7:0] - from U1
		.Digitron_Out( Digitron_Out ) ,		// output [7:0] - to top 
		.DigitronCS_Out( DigitronCS_Out ) 	// output [5:0] - to top  	
	);	
	 
endmodule