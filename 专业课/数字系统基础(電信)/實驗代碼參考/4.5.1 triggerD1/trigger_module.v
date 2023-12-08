module trigger_module
(	
	CLK, Setn, Clrn, D, Q
);
	 input wire CLK;
	 input wire Setn;
	 input wire Clrn;
	 input wire D;
	 output wire Q;
	 
	nand  U1 ( f1, Setn, f4, f2 ),
			U2 ( f2, f1, f5, Clrn ),
			U3 ( f3, Setn, f6, f4 ),
			U4 ( f4, f3, CLK, Clrn ),
			U5 ( f5, f4, Setn, CLK, f6 ),
			U6 ( f6, f5, D, Clrn );
	
	assign Q = f1;
	
endmodule 