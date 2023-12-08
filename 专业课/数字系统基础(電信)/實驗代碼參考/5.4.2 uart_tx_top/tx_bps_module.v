module tx_bps_module
(
    CLK, RSTn, Count_Sig,  BPS_CLK
);

    input CLK;
	 input RSTn;
	 input Count_Sig;
	 output BPS_CLK;
	 
	 /***************************/
	 
	 reg [12:0]Count_BPS;
	 parameter BPS_T = 13'd5208;					// 50MHZ/9600 = 13'd5208
	 
	 always @ ( posedge CLK or negedge RSTn )
	   if( !RSTn )
		    Count_BPS <= 13'd0;
		else if( Count_BPS == BPS_T - 1 ) 
		    Count_BPS <= 13'd0;
		else if( Count_Sig )							//While Count_Sig = 1, Start Count BPS
		    Count_BPS <= Count_BPS + 1'b1;
		else
		    Count_BPS <= 13'd0;
			  
	 /********************************/
    
    assign BPS_CLK = ( Count_BPS == 12'd2604 ) ? 1'b1 : 1'b0;

    /*********************************/

endmodule