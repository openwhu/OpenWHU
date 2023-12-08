module trigger_module
(	
	CLK, Setn, Clrn, J, K, Q, Q_n
);
    input wire CLK;
	 input wire Setn;
	 input wire Clrn;
	 input wire [3:0]J;
	 input wire [3:0]K;
	 output reg [3:0]Q;
	 output reg [3:0]Q_n;

	 reg CLK1 = 0;
	 reg [20:0]Count;
	 parameter Timex = 21'd200_000;

	always @ ( posedge CLK )
		begin
			if( Count == Timex - 1'b1 ) 
				begin
					Count <= 0;
					CLK1 <= ~CLK1;
				end
			else 
				Count <= Count + 21'b1;
		end

	always @ ( posedge CLK1 )
		begin
			Q[0] <= ( ( (J[0] & Q_n[0]) | (~K[0] & Q[0]) ) & Setn & Clrn ) | ~Setn;
			Q[1] <= ( ( (J[1] & Q_n[1]) | (~K[1] & Q[1]) ) & Setn & Clrn ) | ~Setn;
			Q[2] <= ( ( (J[2] & Q_n[2]) | (~K[2] & Q[2]) ) & Setn & Clrn ) | ~Setn;
			Q[3] <= ( ( (J[3] & Q_n[3]) | (~K[3] & Q[3]) ) & Setn & Clrn ) | ~Setn;
			Q_n[0] <= ~Q[0];
			Q_n[1] <= ~Q[1];
			Q_n[2] <= ~Q[2];
			Q_n[3] <= ~Q[3];		
		end
		
endmodule 