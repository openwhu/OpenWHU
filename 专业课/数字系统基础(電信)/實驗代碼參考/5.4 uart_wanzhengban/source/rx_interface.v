module rx_interface
(
    input CLK,
	 input RSTn,
	 
	 input RX_Pin_In,
	 
	 input Read_Req_Sig,
	 output [7:0]FIFO_Read_Data,
	 output Empty_Sig
);

    /************************************/
	 
	 wire [7:0]RX_Data;
	 wire RX_Done_Sig;
	 
	 rx_module U1
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .RX_Pin_In( RX_Pin_In ),    // input - from top
		  .RX_En_Sig( RX_En_Sig ),    // input - from U2
		  .RX_Data( RX_Data ),        // output - to U2
		  .RX_Done_Sig( RX_Done_Sig ) // output - to U2
	 );
	 
	 /************************************/
	 
	 wire RX_En_Sig;
	 wire Write_Req_Sig;
	 wire [7:0]FIFO_Write_Data;
	 
	 rx_top_control_module U2
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .RX_Done_Sig( RX_Done_Sig ),        // input - from U1
		  .RX_Data( RX_Data ),                // input - from U1
		  .RX_En_Sig( RX_En_Sig ),            // output - to U1
		  .Full_Sig( Full_Sig ),              // input - from U3
		  .Write_Req_Sig( Write_Req_Sig ),    // output - to U3
		  .FIFO_Write_Data( FIFO_Write_Data ) // output - to U3
	 );
	 
	 /************************************/
	 
	 wire Full_Sig;
	 
	 rx_fifo_module U3
	 (
	     .clock( CLK ),
		  .wrreq( Write_Req_Sig ),   // input - from U2
		  .data( FIFO_Write_Data ),  // input - from U2
		  .full( Full_Sig ),         // output - to U2
		  .rdreq( Read_Req_Sig ),    // input - from top
		  .q( FIFO_Read_Data ),      // output - to top
		  .empty( Empty_Sig )        // output - to top
	 );
	 
	 /************************************/

endmodule
