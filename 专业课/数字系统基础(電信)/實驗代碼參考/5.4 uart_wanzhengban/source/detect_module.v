module detect_module 
(
    CLK, RSTn,
	 RX_Pin_In,
	 H2L_Sig
);
    input CLK;
	 input RSTn;
	 input RX_Pin_In;
	 output H2L_Sig;
	 
	 /******************************/
	 
	 reg H2L_F1;
	 reg H2L_F2;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin
				    H2L_F1 <= 1'b1;
					 H2L_F2 <= 1'b1;
				end
		  else
		      begin
				    H2L_F1 <= RX_Pin_In;
					 H2L_F2 <= H2L_F1;
				end
				
	/***************************************/
	
	assign H2L_Sig = H2L_F2 & !H2L_F1;
	
	/***************************************/
	
endmodule


	 