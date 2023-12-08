module Digitron_NumDisplay_module
(
	CLK, RSTn, Count_D_Display, Count_P_Display, Count_D, Count_P, Duty, Digitron_Out, DigitronCS_Out
);
	input CLK;
	input RSTn;
	input Count_D_Display;
	input Count_P_Display;
	input [23:0]Count_D;	
	input [23:0]Count_P;
	input [7:0]Duty;
	output [7:0]Digitron_Out; 
	output [5:0]DigitronCS_Out;

   parameter T100MS = 16'd200;
	reg [7:0]Cnt;
	reg [4:0]SingleNum;
	reg [7:0]W_Digitron_Out;
	reg [7:0]W_DigitronCS_Out;
	parameter _0 = 8'b0011_1111, _1 = 8'b0000_0110, _2 = 8'b0101_1011,
			 	 _3 = 8'b0100_1111, _4 = 8'b0110_0110, _5 = 8'b0110_1101,
			 	 _6 = 8'b0111_1101, _7 = 8'b0000_0111, _8 = 8'b0111_1111,
				 _9 = 8'b0110_1111, _A = 8'b0111_0111, _B = 8'b0111_1100,
				 _C = 8'b0011_1001, _D = 8'b0101_1110, _E = 8'b0111_1001,
				 _F = 8'b0111_0001, _Wu = 8'b0100_0000;
				 
	
	always @ ( posedge CLK or negedge RSTn )
		begin
			if( !RSTn )
				begin
					Cnt <= 23'd0;
					W_DigitronCS_Out <= 6'b11_1111;	
				end
			else if( Cnt == T100MS )
				begin
					Cnt <= 23'd0;
					W_DigitronCS_Out = {W_DigitronCS_Out[0],W_DigitronCS_Out[5:1]};
					
					if(W_DigitronCS_Out == 6'b11_1111) 
						W_DigitronCS_Out = 6'b11_1110;
					
					else if( Count_D_Display == 1'b1 )					//Digitron Display Count_D				
						begin
								case(W_DigitronCS_Out)
									6'b11_1110: SingleNum = {1'b0,Count_D[3:0]};
									6'b11_1101: SingleNum = {1'b0,Count_D[7:4]};
									6'b11_1011: SingleNum = {1'b0,Count_D[11:8]};
									6'b11_0111: SingleNum = {1'b0,Count_D[15:12]};
									6'b10_1111: SingleNum = {1'b0,Count_D[19:16]};
									6'b01_1111: SingleNum = {1'b0,Count_D[23:20]};
								endcase
						end
			      else if( Count_P_Display == 1'b1 )			//Digitron Display Count_P	
							begin
								case(W_DigitronCS_Out)
									6'b11_1110: SingleNum = {1'b0,Count_P[3:0]};
									6'b11_1101: SingleNum = {1'b0,Count_P[7:4]};
									6'b11_1011: SingleNum = {1'b0,Count_P[11:8]};
									6'b11_0111: SingleNum = {1'b0,Count_P[15:12]};
									6'b10_1111: SingleNum = {1'b0,Count_P[19:16]};
									6'b01_1111: SingleNum = {1'b0,Count_P[23:20]};
								endcase
							end
					else 												//Digitron Display Duty		
							begin
								case(W_DigitronCS_Out)
									6'b11_1110: SingleNum = {1'b0,Duty[3:0]};
									6'b11_1101: SingleNum = {1'b0,Duty[7:4]};
									default: SingleNum = 5'b11111;								
								endcase
							end				

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
						10: W_Digitron_Out = _A;
						11: W_Digitron_Out = _B;
						12: W_Digitron_Out = _C;
						13: W_Digitron_Out = _D;
						14: W_Digitron_Out = _E;
						15: W_Digitron_Out = _F;
						default:  W_Digitron_Out = _Wu;
					endcase
				end
			else
				Cnt <= Cnt + 1'b1;
	end
		
	assign Digitron_Out = W_Digitron_Out;
	assign DigitronCS_Out = W_DigitronCS_Out;
endmodule