module Digitron_TimeDisplay_module
(
	CLK, RSTn, DispWeek_n, AdjtWeek, Digitron_Out, DigitronCS_Out,
	SecL, SecH, MinL, MinH, HourL, HourH, Week
);
	 input CLK;
	 input RSTn;
	 input DispWeek_n;		//While DispWeek_n = 0, Display Week
	 input AdjtWeek;
	 input [3:0]SecL;		
	 input [3:0]SecH;
	 input [3:0]MinL;		
	 input [3:0]MinH;
	 input [3:0]HourL;		
	 input [3:0]HourH;
	 input [3:0]Week;
	 output [7:0]Digitron_Out; 
	 output [5:0]DigitronCS_Out;

    parameter T100MS = 16'd200;
	 reg [7:0]Count;
	 reg [3:0]SingleNum;
	 reg [7:0]W_Digitron_Out;
	 reg [7:0]W_DigitronCS_Out;
    parameter _0 = 8'b0011_1111, _1 = 8'b0000_0110, _2 = 8'b0101_1011,
			 	  _3 = 8'b0100_1111, _4 = 8'b0110_0110, _5 = 8'b0110_1101,
			 	  _6 = 8'b0111_1101, _7 = 8'b0000_0111, _8 = 8'b0111_1111,
				  _9 = 8'b0110_1111, _Ri= 8'b0111_1111;
				 	
	always @ ( posedge CLK )
		begin
			if( (DispWeek_n == 0) || (AdjtWeek == 1) )		//Digitron Display Week				
				begin
					W_DigitronCS_Out = 6'b11_1110;
					SingleNum = Week;
					
					case(SingleNum)
						'd0:  W_Digitron_Out = _0;
						'd1:  W_Digitron_Out = _1;
						'd2:  W_Digitron_Out = _2;
						'd3:  W_Digitron_Out = _3;
						'd4:  W_Digitron_Out = _4;
						'd5:  W_Digitron_Out = _5;
						'd6:  W_Digitron_Out = _6;
						'd7:  W_Digitron_Out = _Ri;
					endcase
				end
			else if( Count == T100MS )
				begin
					Count <= 23'd0;
					W_DigitronCS_Out = {W_DigitronCS_Out[0],W_DigitronCS_Out[5:1]};
					if(W_DigitronCS_Out == 6'd0) 
						W_DigitronCS_Out = 6'b11_1110;
 
					case(W_DigitronCS_Out)
						6'b11_1110: SingleNum = SecL;
						6'b11_1101: SingleNum = SecH;
						6'b11_1011: SingleNum = MinL;
						6'b11_0111: SingleNum = MinH;
						6'b10_1111: SingleNum = HourL;
						6'b01_1111: SingleNum = HourH;
					endcase
 
					case(SingleNum)
						'd0:  W_Digitron_Out = _0;
						'd1:  W_Digitron_Out = _1;
						'd2:  W_Digitron_Out = _2;
						'd3:  W_Digitron_Out = _3;
						'd4:  W_Digitron_Out = _4;
						'd5:  W_Digitron_Out = _5;
						'd6:  W_Digitron_Out = _6;
						'd7:  W_Digitron_Out = _7;
						'd8:  W_Digitron_Out = _8;
						'd9:  W_Digitron_Out = _9;
					endcase
				end
			else
				Count <= Count + 1'b1;
	end
		
	 assign Digitron_Out = W_Digitron_Out;
	 assign DigitronCS_Out = W_DigitronCS_Out;
	 
endmodule