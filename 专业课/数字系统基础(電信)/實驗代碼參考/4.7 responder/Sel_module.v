module Sel_module
(
	RSTn, CLK, Start, K1, K2, K3, K4, LED_Out, Player_Number, Buzzer_Answer, Timer_Start
); 
	 input CLK;
	 input RSTn;
	 input Start;
	 input K1, K2, K3, K4; 
	 output reg [3:0]LED_Out;
	 output reg [3:0]Player_Number;
	 output reg Buzzer_Answer;
	 output reg Timer_Start;
	 	 
	 reg Block; 	
	 reg [24:0]Count='d0;

	always @ ( posedge CLK or negedge RSTn ) 
		begin 	
			if( !RSTn ) 
				begin 
					LED_Out <= 4'b0;
					Block <= 0; 
					Timer_Start <= 0; 
					Buzzer_Answer <= 0;				
					Count <= 'd0;	
					Player_Number <= 4'd0;						
				end
			else if( Start == 1 )		
				begin 
					if( Timer_Start ) 	
						begin
							if( Count == 25'd24_999_999 )
								begin
									Buzzer_Answer <= 0;							
									Count <= Count;
								end
							else 
								begin
									Buzzer_Answer <= 1;	
									Count <= Count + 25'b1;
								end
						end			
					else if( !K1 && !Block ) 	
						begin 
							LED_Out <= 4'b0001; 	
							Block <= 1; 
							Timer_Start <= 1;	
							Player_Number <= 4'd1; 
						end 
					else if( !K2 && !Block ) 
						begin 
							LED_Out <= 4'b0010;
							Block <= 1;
							Timer_Start <= 1;
							Player_Number <= 4'd2;	
						end 		
					else if( !K3 && !Block ) 
						begin 
							LED_Out <= 4'b0100;
							Block <= 1;
							Timer_Start <= 1; 
							Player_Number <= 4'd3;
						end 	 
					else if( !K4 && !Block ) 
						begin 
							LED_Out <= 4'b1000;
							Block <= 1;
							Timer_Start <= 1;
							Player_Number <= 4'd4;	
						end 
				end
		end 

endmodule
