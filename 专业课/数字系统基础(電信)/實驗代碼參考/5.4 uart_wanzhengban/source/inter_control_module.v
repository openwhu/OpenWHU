module inter_control_module
(
    input CLK,
	 input RSTn,
	 
	 input Empty_Sig,
	 input [7:0]FIFO_Read_Data,
	 output Read_Req_Sig,
	 
	 input Full_Sig,
	 output [7:0]FIFO_Write_Data,
	 output Write_Req_Sig
);

    /********************************/
	 
	 reg [2:0]i;
	 reg isRead;
	 reg isWrite;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin
				    i <= 3'd0;
					 isRead <= 1'b0;
					 isWrite <= 1'b0;
				end
		  else 
		      case( i )
				
				    0:
					 if( !Empty_Sig ) i <= i + 1'b1;
					 
					 1:
					 begin isRead <= 1'b1; i <= i + 1'b1; end
					 
					 2:
					 begin isRead <= 1'b0; i <= i + 1'b1; end
					 
					 3:
					 if( !Full_Sig ) i <= i + 1'b1;
					 
					 4:
					 begin isWrite <= 1'b1; i <= i + 1'b1; end
					 
					 5:
					 begin isWrite <= 1'b0; i <= 3'd0; end
					 
				
				endcase 
				
    /********************************/
	 
	 assign Read_Req_Sig = isRead;
	 assign Write_Req_Sig = isWrite;
	 assign FIFO_Write_Data = FIFO_Read_Data;
	 
	 /********************************/
	 
endmodule
