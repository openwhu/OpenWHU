module tx_interface
(
    input CLK,
	 input RSTn,
	 
	 input Write_Req_Sig,
	 input [7:0]FIFO_Write_Data,
	 output Full_Sig,
	 
	 output TX_Pin_Out
);

    /************************************/
	 
	 wire [7:0]FIFO_Read_Data;
	 wire Empty_Sig;
	 
	 tx_fifo_module U1
	 (
	     .clock( CLK ),
		  .wrreq( Write_Req_Sig ),  // input - from top
		  .data( FIFO_Write_Data ), // input - from top 
		  .full( Full_Sig ),        // output - to top
		  .rdreq( Read_Req_Sig ),   // input - from U2
		  .q( FIFO_Read_Data ),     // output - to U2
		  .empty( Empty_Sig )       // output - to U2
	 );
	 
	 /************************************/
	 
	 wire Read_Req_Sig;
	 wire [7:0]TX_Data;
	 wire TX_En_Sig;
	 
	 tx_top_control_module U2
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .Empty_Sig( Empty_Sig ),            // input - from U1
		  .FIFO_Read_Data( FIFO_Read_Data ),  // input - from U1
		  .Read_Req_Sig( Read_Req_Sig ),      // output - to U1
		  .TX_Done_Sig( TX_Done_Sig ),        // input - from U3
		  .TX_Data( TX_Data ),                // output - to U3
		  .TX_En_Sig( TX_En_Sig )             // output - to U3
	 );
	 
	 /************************************/
	 
	 wire TX_Done_Sig;
	 
	 tx_module U3
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .TX_Data( TX_Data ),          // input - from U2
		  .TX_En_Sig( TX_En_Sig ),      // input - from U2
		  .TX_Done_Sig( TX_Done_Sig ),  // output - to U2
		  .TX_Pin_Out( TX_Pin_Out )     // output - to top
	 );
	 
	 /************************************/
	 


endmodule
