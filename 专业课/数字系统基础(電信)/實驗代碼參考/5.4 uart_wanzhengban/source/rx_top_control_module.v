module rx_top_control_module
(
    input CLK, 
	 input RSTn,
	 
	 input RX_Done_Sig,
	 input [7:0]RX_Data,
	 output RX_En_Sig,
	 
	 input Full_Sig,
	 output Write_Req_Sig,
	 output [7:0]FIFO_Write_Data
);

    /*************************************/
	 
	 reg [1:0]i;
	 reg isWrite;
	 reg isRX;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin
				    i <= 2'd0;
					 isWrite <= 1'b0;
					 isRX <= 1'b0;
			   end
		  else
		      case( i )
				
				    0:
					 if( RX_Done_Sig ) begin isRX <= 1'b0; i <= i + 1'b1; end
					 else isRX <= 1'b1;
					 
					 1:
					 if( !Full_Sig ) i <= i + 1'b1;
					 
					 2:
					 begin isWrite <= 1'b1; i <= i + 1'b1; end
					 
					 3:
					 begin isWrite <= 1'b0; i <= 2'd0; end
				
				endcase
				
    /*************************************/
	 
	 assign RX_En_Sig = isRX;
	 assign Write_Req_Sig = isWrite;
	 assign FIFO_Write_Data = RX_Data;
	 
	 /*************************************/

endmodule
