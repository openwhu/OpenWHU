module Buzzer_module
(
	CLK, RSTn, SecL, SecH, MinL, MinH, Buzzer_Out
);	
	 input CLK;
	 input RSTn;
	 input [3:0]SecL;		
	 input [3:0]SecH;
	 input [3:0]MinL;		
	 input [3:0]MinH;
	 output Buzzer_Out;
	 
	 parameter Di = 16'd50_000;		//frequency is 500HZ, "di"
	 parameter Da = 15'd25_000; 		//frequency is 1KHZ, "da"
    reg [22:0]Count;
    reg [22:0]Pulse_x;
	 reg W_buzzer;
	
	always @( posedge CLK )
		begin
			if( MinH == 'd5 && MinL == 'd9 && SecH == 'd5 )		//While Time = 59'50"
				begin
					if( (SecL % 2) == 0)		
						Pulse_x <= Di;		//Di
					else
						Pulse_x <= 20000;
				end
			else if( MinH == 0 && MinL == 0 && SecH == 0 && SecL == 0 )		//While Time = 00'00"
				Pulse_x <= Da;		//Da
			else
				Pulse_x <= 20000;
		end
	
   always @ ( posedge CLK )
		begin
			if( (Pulse_x == Di) | (Pulse_x == Da) )
				begin
					if( Count == Pulse_x )
						begin
							Count <= 23'd0;
							W_buzzer <= ~W_buzzer;
						end
					else 
						Count <= Count + 1'b1;
				end
			else 
				begin
					W_buzzer <= 1'b1;
					Count <= 23'd0;
				end				
		end	
		
	 assign Buzzer_Out = W_buzzer;
	
endmodule