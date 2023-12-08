module Digitron_NumDisplay_module
(
	CLK, Result, Digitron_Out, DigitronCS_Out
);
	 input CLK;
	 input [7:0]Result; 
	 output [7:0]Digitron_Out;
	 output [5:0]DigitronCS_Out;	 

    parameter Timex = 8'd200;	
	 reg [7:0]Count;
	 reg [3:0]SingleNum;
	 reg [7:0]W_Digitron_Out;
	 reg [5:0]W_DigitronCS_Out;
	 parameter _0 = 8'b0011_1111, _1 = 8'b0000_0110, _2 = 8'b0101_1011,
			 	  _3 = 8'b0100_1111, _4 = 8'b0110_0110, _5 = 8'b0110_1101,
			 	  _6 = 8'b0111_1101, _7 = 8'b0000_0111, _8 = 8'b0111_1111,
				  _9 = 8'b0110_1111;
	
	always @ ( posedge CLK )
		begin
			if( Count == Timex )
				begin
					Count <= 8'd0;
					W_DigitronCS_Out = {W_DigitronCS_Out[5:2],W_DigitronCS_Out[0],W_DigitronCS_Out[1]};
					if(W_DigitronCS_Out == 6'b11_1100) 
						W_DigitronCS_Out = 6'b11_1110;
						
					case(W_DigitronCS_Out)		
						6'b11_1110: SingleNum = Result[3:0];	//Display ResultL
						6'b11_1101: SingleNum = Result[7:4];	//Display ResultH		
					endcase
					
					case(SingleNum)					
						4'd0:  W_Digitron_Out = _0;
						4'd1:  W_Digitron_Out = _1;
						4'd2:  W_Digitron_Out = _2;
						4'd3:  W_Digitron_Out = _3;
						4'd4:  W_Digitron_Out = _4;
						4'd5:  W_Digitron_Out = _5;
						4'd6:  W_Digitron_Out = _6;
						4'd7:  W_Digitron_Out = _7;
						4'd8:  W_Digitron_Out = _8;
						4'd9:  W_Digitron_Out = _9;
						default: W_Digitron_Out = 8'b1111_1111;	
					endcase
				end
			else
				Count <= Count + 1'b1;
		end
	
	 assign Digitron_Out = W_Digitron_Out;
	 assign DigitronCS_Out = W_DigitronCS_Out;	
	
endmodule 