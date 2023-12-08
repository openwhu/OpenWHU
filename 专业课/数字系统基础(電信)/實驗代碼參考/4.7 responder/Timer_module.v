module Timer_module
(	
	RSTn, CLK, Timer_Start, TimerH, TimerL, Buzzer_TimeOver, LED_OverTime
);
	 input RSTn;
	 input CLK; 
	 input Timer_Start;
	 output reg [3:0]TimerH;
	 output reg [3:0]TimerL;
	 output reg Buzzer_TimeOver;
	 output reg LED_OverTime;
	 

	 reg count1=0;
	 reg CLK1; 
	 reg [24:0]Count;
	 parameter T1S = 25'd25_000_000;		

	always @ ( posedge CLK or negedge Timer_Start )
		begin 
			if( !Timer_Start )
				Count <= 0;				
			else if( Count == T1S - 25'b1 )
				begin
					Count <= 0;
					CLK1 <= ~CLK1;		
				end
			else
				Count <= Count + 1;
		end

	always @ ( posedge CLK1 or negedge RSTn )
		begin
			if( !RSTn )  		
				begin
					TimerH <= 4'd3;
					TimerL <= 4'd0;
				end
			else if( Timer_Start == 1 )		
				begin
					if( TimerL == 4'd0 ) 
						begin
							if( TimerH == 4'd0 )		
								begin
									TimerH <= TimerH;
									TimerL <= TimerL;
								end
							else 
								begin
									TimerH <= TimerH - 1'b1;
									TimerL <= 4'd9;
								end
						end
					else 
						TimerL <= TimerL - 1'b1;
				end
		end
	
	always @ ( posedge CLK1 )
		begin
			if( TimerH == 'd0 && TimerL == 'd1 ) 	
				begin
					if( count1 == 1'b1 )
						begin
							Buzzer_TimeOver <= 0;
							LED_OverTime <= 0;
							count1 <= 0;
						end
					else 
						begin
							Buzzer_TimeOver <= 1;		
							LED_OverTime <= 1;			
							count1 <= count1 + 1'b1;
						end
				end
			else
				begin
					Buzzer_TimeOver <= 0;
					LED_OverTime <= 0;
					count1 <= 0;			
				end
		end	
		
endmodule

	
	