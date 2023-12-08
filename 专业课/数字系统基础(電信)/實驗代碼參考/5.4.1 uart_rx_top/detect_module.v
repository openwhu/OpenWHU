module detect_module 
(
   CLK, RSTn, RX_Pin_In, neg_sig
);
    input CLK;
	 input RSTn;
	 input RX_Pin_In;
	 output neg_sig; 
	 
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
				    neg1 <= RX_Pin_In;
					 neg2 <= neg1;
				end
				
	/***************************************/
	
	assign neg_sig = ( neg2 & !neg1 ) ? 1'b1 : 1'b0;			//While RX_Pin_In from 1 to 0, neg_sig = 1
	
	/***************************************/
	
endmodule


	 