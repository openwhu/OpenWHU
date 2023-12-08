module Accumulator_module
(
	CLK, RSTn, Result
);
	 input CLK;
	 input RSTn;
	 output reg [7:0]Result; 

	 reg CLK1=0;
	 reg [25:0]Count;
	 parameter T05S = 26'd25_000_000;		//period of CLK1 is 1 second

	always @ ( posedge CLK )
		begin 
			if( Count == T05S - 26'b1 )
				begin
					Count <= 0;
					CLK1 <= ~CLK1;
				end
			else
				Count <= Count + 1;
		end

	always @ ( posedge CLK1 or negedge RSTn )
		begin
			if( !RSTn )
				begin 
					Result[7:4] <= 0;		//ResultH
					Result[3:0] <= 0;		//ResultL		
				end
			else if( Result[7:4] == 4'd2 && Result[3:0] == 4'd3 )
				begin
					Result[7:4] <= 0;
					Result[3:0] <= 0;
				end
			else if( Result[3:0] == 4'd9 )
				begin
					Result[3:0] <= 0;					
					Result[7:4] <= Result[7:4] + 1'b1;
				end
			else 
				Result[3:0] <= Result[3:0] + 1'b1;
		end
   
endmodule 
	