module Accumulator_module
(
	CLK, RSTn, Result
);

	input CLK, RSTn;
	output [23:0]Result;
	
	reg [25:0]Count;
	reg [23:0]result;
	parameter Timex = 25'd12;
	always @ ( posedge CLK or negedge RSTn )
		if( !RSTn )	
			begin
				result <= 0;
				Count  <= 0;
			end
		else if(Count == Timex)
			begin
				Count <= 23'd0;
				result <= result + 1'b1;
			end
		else
			Count <= Count + 1'b1;
			
	
	assign Result = result;
endmodule