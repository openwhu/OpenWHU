module TimeKeeper_module
(
	CLK, RSTn, AdjtWeek, AdjtHour, AdjtMin,
	SecL, SecH, MinL, MinH, HourL, HourH, Week
);
	 input CLK;
	 input RSTn;
	 input AdjtWeek;		//Adjust Week
	 input AdjtHour;	//Adjust Hour
	 input AdjtMin;		//Adjust Minute
	 output reg [3:0]SecL;		//Second
	 output reg [3:0]SecH;
	 output reg [3:0]MinL;		//Minute
	 output reg [3:0]MinH;
	 output reg [3:0]HourL;		//Hour
	 output reg [3:0]HourH;
	 output reg [3:0]Week;		//Week

	 reg CLK_1HZ=0;
	 reg [24:0]Count;
	 parameter T1HZ = 25'd25_000_000;	//frequency is 1HZ, Period is 1S

	always @ ( posedge CLK )
		begin 
			if( Count == T1HZ - 25'b1 )
				begin
					Count <= 0;
					CLK_1HZ <= ~CLK_1HZ;
				end
			else
				Count <= Count + 1;
		end
		
	always @ ( posedge CLK_1HZ or negedge RSTn )
		begin
			if( !RSTn )
				begin 
					SecL <= 0;
					SecH <= 0;
					MinL <= 0;
					MinH <= 0;
					HourL <= 0;
					HourH <= 0;
					Week <= 1;
				end
			else
				begin
					if( AdjtWeek == 1 )		//While AdjtWeek = 1, Adjust Week
						begin  
							if( Week == 'd7 )
								Week <= 1;
							else
								Week <= Week + 1;
						end
					else if( AdjtHour == 1 )		//Adjust Hour
						begin 
							if( HourL == 'd9 )
								begin
									HourL <= 0;
									HourH <= HourH + 1;
								end
							else
								begin
									if( HourH == 'd2 && HourL == 'd3 )
										begin
											HourL <= 0;
											HourH <= 0;
										end
									else
										HourL <= HourL + 1;
								end
						end
					else if( AdjtMin == 1 ) 		//Adjust Minute
						begin
							if( MinL == 'd9)
								begin
									MinL <= 0;
									if(MinH == 'd5)
										MinH <= 0;
									else
										MinH <= MinH + 1;
								end					
							else 
								MinL <= MinL + 1;	
						end
					else if( SecL == 'd9 )		//Clock is Working
						begin 
							SecL <= 0;
							if( SecH == 'd5 )
								begin
									SecH <= 0;
									if( MinL == 'd9 )
										begin
											MinL <= 0;
											if( MinH == 'd5 )
												begin
													MinH <= 0;
													if( HourL == 'd9 )
														begin
															HourL <= 0;
															HourH <= HourH + 1;
														end
													else if( HourH == 'd2 && HourL == 'd3 )
														begin
															HourL <= 0;
															HourH <= 0;
															if( Week == 7 )													
																Week <= 1;
															else
																Week <= Week + 1;															
														end
													else
														HourL <= HourL + 1;
												end
											else
												MinH <= MinH + 1;
										end
									else
										MinL <= MinL + 1;
								end
							else
								SecH <= SecH + 1;
						end
					else
						SecL <= SecL + 1;
				end
		end

endmodule