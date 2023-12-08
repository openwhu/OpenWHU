module pencode_module
(
	CLK, x, y, Valid
);
	 input CLK;
	 input wire [7:0]x;
	 output reg [2:0]y;
	 output reg Valid;
	
	 integer i;		

	always @ ( posedge CLK )
		begin 
			y <= 'b0;
			Valid <= 'b0;		
			for( i = 0; i <= 7; i = i+1 )	
				if( x[i] == 1 )
					begin 
						y <= i;
						Valid <= 1;					//While x[7:0] != 8'b0, Valid = 1'b1		
					end		
		end

endmodule  
	