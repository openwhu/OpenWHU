module PWM_Generate_module
(
	CLK, RSTn, Duty, Count_P, PWM_Out, Count_D 
);
	 input CLK;
	 input RSTn;
	 input [7:0]Duty; 
	 input [23:0]Count_P; 	//period = Count_P/50_000_000 
	 output reg PWM_Out;
	 output [23:0]Count_D;
	 
	 reg [23:0]Cnt1;

	 
	 assign Count_D = (Duty * Count_P) / 'd100;
	 
	always @ ( posedge CLK or negedge RSTn )
		begin
			if( RSTn == 0 )
				Cnt1 <= 0;
			else if( Cnt1 == Count_P - 1'b1 )
				Cnt1 <= 0;
			else
				Cnt1 <= Cnt1 + 1'b1;
		end
		
	always @( * )
		begin
			if( Cnt1 <= Count_D )
				PWM_Out <= 1'b1;
			else
				PWM_Out <= 0;
		end
		
endmodule