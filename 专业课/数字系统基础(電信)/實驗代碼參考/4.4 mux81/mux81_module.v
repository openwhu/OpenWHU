module mux81_module
(
	CSn, A, D0, D1, D2, D3, D4, D5, D6, D7, Y
);
	 input CSn;
	 input [2:0]A;
	 input [width-1:0]D0, D1, D2, D3, D4, D5, D6, D7;	 
	 output reg [width-1:0]Y;

	 parameter width = 1;

	always @ ( * )
		begin 
			if( !CSn )													//While CSn = 0, mux81 work
				case( A )
					3'b000: Y <= D0;
					3'b001: Y <= D1;
					3'b010: Y <= D2;
					3'b011: Y <= D3;
					3'b100: Y <= D4;
					3'b101: Y <= D5;
					3'b110: Y <= D6;
					3'b111: Y <= D7;
				endcase
			else				
				Y <= 0;
		end

endmodule 