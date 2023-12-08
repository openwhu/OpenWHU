module trigger_module
(
	CLK, Setn, Clrn, D, Q
);
	 input wire CLK;
	 input wire Setn;
	 input wire Clrn;
	 input wire [7:0]D;
	 output reg [7:0]Q;

	always @(posedge CLK or negedge Setn or negedge Clrn)
		begin
			Q[0] <= ( D[0] & Setn & Clrn ) | ~Setn;
			Q[1] <= ( D[1] & Setn & Clrn ) | ~Setn;
			Q[2] <= ( D[2] & Setn & Clrn ) | ~Setn;
			Q[3] <= ( D[3] & Setn & Clrn ) | ~Setn;
			Q[4] <= ( D[4] & Setn & Clrn ) | ~Setn;
			Q[5] <= ( D[5] & Setn & Clrn ) | ~Setn;
			Q[6] <= ( D[6] & Setn & Clrn ) | ~Setn;
			Q[7] <= ( D[7] & Setn & Clrn ) | ~Setn;
		end
	
endmodule 