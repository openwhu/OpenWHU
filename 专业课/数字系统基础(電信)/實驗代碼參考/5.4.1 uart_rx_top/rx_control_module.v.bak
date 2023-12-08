module rx_control_module
(
    CLK, RSTn,
	 H2L_Sig, RX_Pin_In, BPS_CLK, RX_En_Sig,
    Count_Sig, RX_Data, RX_Done_Sig
	 
);

    input CLK;
	 input RSTn;
	 
	 input H2L_Sig;
	 input RX_En_Sig;
	 input RX_Pin_In;
	 input BPS_CLK;
	 
	 output Count_Sig;
	 output [7:0]RX_Data;
	 output RX_Done_Sig;
	 
	 
	 /********************************************************/

	 reg [3:0]i;
	 reg [7:0]rData;
	 reg isCount;
	 reg isDone;
	
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin 
		          i <= 4'd0;
					 rData <= 8'd0;
					 isCount <= 1'b0;
					 isDone <= 1'b0;	 
				end
		  else if( RX_En_Sig )
		      case ( i )
				
			       4'd0 :
					 if( H2L_Sig ) begin i <= i + 1'b1; isCount <= 1'b1; end
					 
					 4'd1 : 
					 if( BPS_CLK ) begin i <= i + 1'b1; end
					 
					 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9 :
					 if( BPS_CLK ) begin i <= i + 1'b1; rData[ i - 2 ] <= RX_Pin_In; end
					 
					 4'd10 :
					 if( BPS_CLK ) begin i <= i + 1'b1; end
					 
					 4'd11 :
					 if( BPS_CLK ) begin i <= i + 1'b1; end
					 
					 4'd12 :
					 begin i <= i + 1'b1; isDone <= 1'b1; isCount <= 1'b0; end
					 
					 4'd13 :
					 begin i <= 1'b0; isDone <= 1'b0; end
				 
				endcase
				
    /********************************************************/
	 
	 assign Count_Sig = isCount;
	 assign RX_Data = rData;
	 assign RX_Done_Sig = isDone;
	 
	 
	 /*********************************************************/
	 
endmodule

