module tx_top
(
    CLK, RSTn, TX_Pin_Out
);
 
     input CLK;
	  input RSTn;//SW0
	  
	  output TX_Pin_Out;//F14
	  
	  wire TX_En_Sig; 
	  wire TX_Done_Sig;	  
	  wire BPS_CLK;
	  wire [7:0]TX_Data;
	  
	data_control_module U1
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.TX_Done_Sig( TX_Done_Sig ) ,	// input - from U3
		.TX_En_Sig( TX_En_Sig ) ,	// output - to U2, U3
		.TX_Data( TX_Data ) 	// output - to U3
	);
	  
   tx_bps_module U2
	(
	   .CLK( CLK ),
		.RSTn( RSTn ),
		.Count_Sig( TX_En_Sig ),    // input - from U1
		.BPS_CLK( BPS_CLK )         // output - to U3
	);
	  
	tx_control_module U3
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.TX_En_Sig( TX_En_Sig ) ,	// input - from U1
		.BPS_CLK( BPS_CLK ) ,	// input - from U2
		.TX_Data( TX_Data ) ,	// input - from U1
		.TX_Done_Sig( TX_Done_Sig ) ,	// output - to U1
		.TX_Pin_Out( TX_Pin_Out ) 	// output - to top 
	);

endmodule
