module fir_top
(
	CLK, RSTn, DA_CLK, DA_Data, Buzzer_Out
);
	 input CLK;
	 input RSTn;			//SW0
	 
    output DA_CLK; 
    output [7:0]DA_Data;
    output Buzzer_Out = 1'b1; 
	 
/***************************/	 	 
	 
	 wire [6:0]Sin6K_Out;	 
	 wire [6:0]Sin24K_Out;
	 wire [7:0]data_in;

	assign data_in = Sin6K_Out + Sin24K_Out;

	dds_module U1
	(
		.CLK( CLK ) ,	// input 
		.RSTn( RSTn ) ,	// input  
		.Sin6K_Out( Sin6K_Out ) ,	// output [6:0] - to top
		.Sin24K_Out( Sin24K_Out ) 	// output [6:0] - to top
	);

/********************************/

	 wire CLK_70K;
	
	pll_70K	U4 
	(
		.inclk0 ( CLK ),
		.c0 ( CLK_70K )
	);

/******************************/

	wire [22:0]data_out;
	
	wire ast_sink_valid = 1'b1;
	wire ast_source_ready = 1'b1;
	wire [1:0]ast_sink_error = 2'b0;
	
	wire ast_sink_ready;
	wire ast_source_valid;
	wire [1:0]ast_source_error;

low_pass_filter1 U2
(
	.clk( CLK_70K ) ,	// input  
	.reset_n( RSTn ) ,	// input   
	.ast_sink_data( data_in ) ,	// input [7:0] - from top
	.ast_sink_valid( ast_sink_valid ) ,	// input - from top 
	.ast_source_ready( ast_source_ready ) ,	// input - from top
	.ast_sink_error( ast_sink_error ) ,	// input [1:0] - from top
	.ast_source_data( data_out ) ,	// output [22:0] - to top
	.ast_sink_ready( ast_sink_ready_sig ) ,	// output   
	.ast_source_valid( ast_source_valid ) ,	// output   
	.ast_source_error( ast_source_error ) 	// output [1:0]  
);

/*******************************/

	 wire [7:0]DA_Data_In;
	 
/*	assign DA_Data_In = {1'b0,Sin6K_Out};*/
/*	assign DA_Data_In = {1'b0,Sin24K_Out};*/
/* assign DA_Data_In = data_in; */
   assign DA_Data_In = data_out[22:15];  

	DA_Data_Out_module U3
	(
		.CLK( CLK ) ,	// input   
		.RSTn( RSTn ) ,	// input   
		.DA_Data_In( DA_Data_In ) ,	// input [7:0] - from top
		.DA_CLK( DA_CLK ) ,	// output - to top
		.DA_Data( DA_Data ) 	// output [7:0] - to top
	);
	
	
endmodule