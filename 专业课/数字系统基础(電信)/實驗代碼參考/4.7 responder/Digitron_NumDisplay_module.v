module Digitron_NumDisplay_module
(
	CLK, Player_Number, TimerH, TimerL, Digitron_Out, DigitronCS_Out
);
	 input CLK;
	 input [3:0]Player_Number;
	 input [3:0]TimerH;
	 input [3:0]TimerL;
	 output [7:0]Digitron_Out; 
	 output [5:0]DigitronCS_Out;

    parameter T250K = 16'd200;
	 reg [7:0]Count;
	 reg [3:0]SingleNum;
	 reg [7:0]W_Digitron_Out;
	 reg [7:0]W_DigitronCS_Out;
	 parameter _0 = 8'b0011_1111, _1 = 8'b0000_0110, _2 = 8'b0101_1011,
			 	 _3 = 8'b0100_1111, _4 = 8'b0110_0110, _5 = 8'b0110_1101,
			 	 _6 = 8'b0111_1101, _7 = 8'b0000_0111, _8 = 8'b0111_1111,
				 _9 = 8'b0110_1111;
		
	always @ ( posedge CLK )
		begin	
			 if( Count == T250K )
				begin
					Count <= 7'd0;
					W_DigitronCS_Out = {3'b111,W_DigitronCS_Out[0],W_DigitronCS_Out[2:1]};
					
					if(W_DigitronCS_Out == 6'b11_1000) 
						W_DigitronCS_Out = 6'b11_1110;

					case(W_DigitronCS_Out)
						6'b11_1110: SingleNum = TimerL;		//Display TimerL
						6'b11_1101: SingleNum = TimerH;			//Display TimerH
						6'b11_1011: SingleNum = Player_Number;		//Display Player_Number				
					endcase

					case(SingleNum)
						0:  W_Digitron_Out = _0;
						1:  W_Digitron_Out = _1;
						2:  W_Digitron_Out = _2;
						3:  W_Digitron_Out = _3;
						4:  W_Digitron_Out = _4;
						5:  W_Digitron_Out = _5;
						6:  W_Digitron_Out = _6;
						7:  W_Digitron_Out = _7;
						8:  W_Digitron_Out = _8;
						9:  W_Digitron_Out = _9;
					endcase
				end
			else
				Count <= Count + 1'b1;
	end
 
	 assign Digitron_Out = W_Digitron_Out;
	 assign DigitronCS_Out = W_DigitronCS_Out;
	
endmodule