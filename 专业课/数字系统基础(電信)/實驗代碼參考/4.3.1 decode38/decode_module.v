module decode_module
(
	a2, a1, a0, y7, y6, y5, y4, y3, y2, y1, y0
);
	input wire a2, a1, a0;
	output wire y7, y6, y5, y4, y3, y2, y1, y0;

	assign y0 = ~a2 & ~a1 & ~a0;								//While {a2,a1,a0} = 3'b000, {y7,y6,y5,y4,y3,y2,y1,y0} = 8'b00000001
	assign y1 = ~a2 & ~a1 & a0;
	assign y2 = ~a2 & a1 & ~a0;
	assign y3 = ~a2 & a1 & a0;
	assign y4 = a2 & ~a1 & ~a0;
	assign y5 = a2 & ~a1 & a0;
	assign y6 = a2 & a1 & ~a0;
	assign y7 = a2 & a1 & a0;

endmodule
