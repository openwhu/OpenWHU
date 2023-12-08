module Jitter_Elimination_module
(
	CLK, RSTn, Button_In, Button_Out
); 		

	 input CLK;
	 input RSTn;
	 input Button_In; 
	 output Button_Out;		
	 
	 reg neg1;
	 reg neg2;
	 
	always @ ( posedge CLK or negedge RSTn )
		if( !RSTn )
			begin
				neg1 <= 1'b1;
				neg2 <= 1'b1;			
			end
		else 
			begin
				neg1 <= Button_In;
				neg2 <= neg1;			
			end

	 assign Button_Out =( neg2 & (!neg1) ) ? 1'b1 : 1'b0;	//While Button_In from 1 to 0, Button_Out = 1
	
endmodule