module tx_top_control_module
(
    input CLK,
	 input RSTn,
	 
	 input Empty_Sig,
    input [7:0]FIFO_Read_Data,
	 output Read_Req_Sig,
	 
	 input TX_Done_Sig,
	 output [7:0]TX_Data,
	 output TX_En_Sig
);

    /*************************************/
	 
	 reg [1:0]i;
	 reg isRead;
	 reg isTX;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin
		          i <= 2'd0;
				    isRead <= 1'b0;
					 isTX <= 1'b0;
				end
		  else 
		      case( i )
				
				    0:
					 if( !Empty_Sig ) i <= i + 1'b1; 
					 
					 1:
					 begin isRead <= 1'b1; i <= i + 1'b1; end
					 
				    2:
					 begin isRead <= 1'b0; i <=i + 1'b1; end
					 
					 3:
					 if( TX_Done_Sig ) begin isTX <= 1'b0; i <= 2'd0; end
					 else isTX <= 1'b1;  
					 
				
				endcase
				
    /*************************************/
	 
	 assign Read_Req_Sig = isRead;
	 assign TX_En_Sig = isTX;
	 assign TX_Data = FIFO_Read_Data;
	 
	 /*************************************/
	 

endmodule
