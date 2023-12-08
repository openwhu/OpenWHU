module tx_control_module
(
    CLK, RSTn, TX_En_Sig, BPS_CLK, TX_Data, TX_Done_Sig, TX_Pin_Out
	 
);

    input CLK;
	 input RSTn;
	 
	 input TX_En_Sig;
	 input BPS_CLK;
	 input [7:0]TX_Data;
	 
	 output TX_Done_Sig;
	 output TX_Pin_Out;
	 
	 /********************************************************/

	 reg [3:0]State;
	 reg rTX;		//"r" means register			
	 reg isDone;
	
	 always @ ( posedge CLK or negedge RSTn )
		begin
	     if( !RSTn )
		      begin
		          State <= 4'd0;
					 rTX <= 1'b1;
					 isDone 	<= 1'b0;
				end
		  else if( TX_En_Sig )		//While TX_En_Sig = 1, Transmit is Allowed 
		      case ( State )
				
			       4'd0 :
						if( BPS_CLK ) 
							begin 
								State <= State + 1'b1; 
								rTX <= 1'b0;
							end
					 
					 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8 :
						if( BPS_CLK ) 
							begin 
								State <= State + 1'b1;
								rTX <= TX_Data[ State - 1 ];			//Transmit TX_Data[0] - TX_Data[7]
							end
					 
					 4'd9 :
						 if( BPS_CLK ) 
							 begin 
								 State <= State + 1'b1;
								 rTX <= 1'b1;
							 end
					 			 
					 4'd10 :
						 if( BPS_CLK ) 
							 begin 
								 State <= State + 1'b1; 
								 rTX <= 1'b1;
							 end
					 
					 4'd11 :
						 if( BPS_CLK ) 
							 begin 
								 State <= State + 1'b1; 
								 isDone <= 1'b1; 
							 end
					 
					 4'd12 :
						begin 
							State <= 1'b0; 
							isDone <= 1'b0; 
						end
						
				endcase
		  else
				rTX <= rTX;
		end
    /********************************************************/
	 
	 assign TX_Pin_Out = rTX;
	 assign TX_Done_Sig = isDone;
	 
	 /*********************************************************/
	 
endmodule