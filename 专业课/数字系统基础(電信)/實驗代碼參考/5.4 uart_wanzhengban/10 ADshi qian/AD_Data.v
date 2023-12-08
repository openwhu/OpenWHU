module AD_Data
(
	CLK, RSTn, AD_EOC, AD_DigData_In, AD_CSn, AD_Clk, AD_Address, Digitron_Out, DigitronCS_Out  
);

	 input CLK;
	 input RSTn;		//SW0
	 
	 input AD_EOC;
	 input AD_DigData_In;	 
	 output AD_CSn;
	 output AD_Clk;
	 output AD_Address;
	 	 			 	 
	 output [7:0]Digitron_Out; 
	 output [5:0]DigitronCS_Out;
	 
	 reg AD_CSn_r;
	 reg AD_Clk_r;
	 reg AD_Address_r;
	 reg [9:0]Data_Out_r;
	 
	 reg CS_Valid_Sig;
	 wire [3:0]Addr = 4'b0101;	   	//AIN5
	 wire [9:0]Data_Out;
	 
/***************************************/	 		 	 	
	 wire Clk_100K;	
	pll1	pll1_inst 
	(
		.inclk0 ( CLK ),
		.c0 ( Clk_100K )
	);
	
	 wire Clk_10M;	
	PLL2	PLL2_inst (
	.inclk0 ( CLK ),
	.c0 ( Clk_10M )
	);
/****************************************/	 
	 reg [7:0]Cnt1;
	 reg Cnt1_en;
	 
	always @ ( posedge CLK or negedge RSTn )
		begin
			if( !RSTn )
				begin
					Cnt1 <= 8'd0;
				end
			else if( Cnt1 == 8'd12 )		// generate " I/O CLOCK ( AD_Clk ) " , period is 2*65*20ns = 2600ns
				begin
					Cnt1 <= 8'b0;
				end
			else if( Cnt1_en )
				begin
					Cnt1 <= Cnt1 + 1'b1;
				end
			else 
				Cnt1 <= 8'b0;			
		end

/****************************************/		
	 reg [7:0]Cnt2;
	 reg Cnt2_en;
	 
	always @ ( posedge CLK or negedge RSTn )
		begin
			if( !RSTn )
				begin
					Cnt2 <= 8'd0;
				end
		 	else if( Cnt2 == 8'd71 )		// generate " tsu(cs) " , Delayed Time is 75*20ns = 1500ns > 1.425us
				begin
					Cnt2 <= 8'b0;
				end 
			else if( Cnt2_en )
				begin
					Cnt2 <= Cnt2 + 1'b1;
				end
			else 
				Cnt2 <= 8'b0;			
		end
	
/********************************************/	
	 reg [7:0]Cnt3;
	 reg Cnt3_en;

	always @ ( posedge CLK or negedge RSTn )
		begin
			if( !RSTn )
				begin
					Cnt3 <= 8'd0;
				end
		 	else if( Cnt3 == 8'd25 )		// generate a clock signal to control the data transmitted to "AD_Address", 													
				begin								//	period is 130*20ns = 2600ns			
					Cnt3 <= 8'b0;
				end 
			else if( Cnt3_en )
				begin
					Cnt3 <= Cnt3 + 1'b1;
				end
			else 
				Cnt3 <= 8'b0;			
		end	
	
/*****************************************/	
	 reg [10:0]Cnt4;
	 reg Cnt4_en;

	always @ ( posedge CLK or negedge RSTn )
		begin
			if( !RSTn )
				begin
					Cnt4 <= 11'd0;
				end
		 	else if( Cnt4 == 11'd1050 )		// generate " Conversion time " , Delayed Time is 1050*20ns = 21us
				begin								 
					Cnt4 <= 11'b0;	
				end 
			else if( Cnt4_en )
				begin
					Cnt4 <= Cnt4 + 1'b1;
				end
			else 
				Cnt4 <= 11'b0;			
		end
	
	
/*******************************************/	
	 reg [4:0]i;
	 
	always @ ( posedge CLK or negedge RSTn )
		begin
			if( !RSTn )
				begin
					i <= 5'b1;
					Data_Out_r <= 10'b0;					
					Cnt1_en <= 1'b0;
					Cnt2_en <= 1'b0;
					Cnt3_en <= 1'b0;
					Cnt4_en <= 1'b0;
					CS_Valid_Sig <= 1'b0;
				end
			else  	
				case( i )
					1: begin							//initial state
							AD_CSn_r <= 1'b1;
							AD_Clk_r <= 1'b0;
							Cnt1_en <= 1'b0;
							Cnt2_en <= 1'b0;
							Cnt3_en <= 1'b0;
							Cnt4_en <= 1'b0;
							i <= i + 1'b1;
							CS_Valid_Sig <= 1'b0;
						end
					
					2: begin							 
							AD_CSn_r <= 1'b0;							 
							Cnt2_en <= 1'b1;							 
							i <= i + 1'b1;
						end
						
					3: if( Cnt2 == 8'd71 )		//valid CS↓
							begin
								AD_Clk_r <= 1'b0;
								CS_Valid_Sig <= 1'b1;							
								Cnt1_en <= 1'b1;
								Cnt3_en <= 1'b1;								
								i <= i + 1'b1;
							end
						else 	
							begin
								AD_Clk_r <= 1'b0;							 
								i <= i ;
							end
							
					4:	if( Cnt3 == 8'd6 )
							begin
								AD_Address_r <= Addr[3];
								i <= i ;
							end
						else if( Cnt1 == 8'd12 )
							begin
								AD_Clk_r <= 1'b1;
								Data_Out_r[9] <= AD_DigData_In;							
								i <= i + 1'b1;
							end	
						else 	
							begin							 
								i <= i ;
							end
							
					6:	if( Cnt3 == 8'd6 )
							begin
								AD_Address_r <= Addr[2];
								i <= i ;
							end
						else if( Cnt1 == 8'd12 )
							begin
								AD_Clk_r <= 1'b1;
								Data_Out_r[8] <= AD_DigData_In;							
								i <= i + 1'b1;
							end	
						else 	
							begin							 
								i <= i ;
							end
							
					8:	if( Cnt3 == 8'd6 )
							begin
								AD_Address_r <= Addr[1];
								i <= i ;
							end
						else if( Cnt1 == 8'd12 )
							begin
								AD_Clk_r <= 1'b1;
								Data_Out_r[7] <= AD_DigData_In;							
								i <= i + 1'b1;
							end	
						else 	
							begin							 
								i <= i ;
							end
							
					10: if( Cnt3 == 8'd6 )
							begin
								AD_Address_r <= Addr[0];
								i <= i ;
							end
						else if( Cnt1 == 8'd12 )
							begin
								AD_Clk_r <= 1'b1;
								Data_Out_r[6] <= AD_DigData_In;							
								i <= i + 1'b1;
							end	
						else 	
							begin							 
								i <= i ;
							end
							
		   		12, 14, 16, 18, 20, 22:
						if( Cnt1 == 8'd12 )
							begin
								AD_Clk_r <= 1'b1;
								Data_Out_r[11 - (i >> 1)] <= AD_DigData_In;			// from Data_Out_r[5] to Data_Out_r[0]					
								i <= i + 1'b1;
							end	
						else 	
							begin							 
								i <= i ;
							end 

					5, 7, 9, 11, 13, 15, 17, 19, 21, 23: 
						if( Cnt1 == 8'd12 )
							begin
								AD_Clk_r <= 1'b0;
								i <= i + 1'b1;
							end
						else 	
							begin							 
								i <= i ;
							end
							
					24: begin
								AD_CSn_r <= 1'b1;
								Cnt4_en <= 1'b1;
								i <= i + 1'b1;
							end
						 
					25: if( Cnt4 == 11'd1050 )			 // " Conversion time "
							begin
								i <= i + 1'b1;
							end
						 else 	
							begin							 
								i <= i ;
							end
							
					26: begin
							i <= 1;
						 end
						 
				endcase
		end
		
 	assign Data_Out = Data_Out_r; 
	assign AD_CSn = AD_CSn_r;
	assign AD_Clk = AD_Clk_r;
	assign AD_Address = AD_Address_r;
	
/******************************************************/	
	Digitron_NumDisplay U1
	(
		.CLK( CLK ) ,	 
		.RSTn( RSTn ) ,	 
		.Data( Data_Out ) ,	// input - from top
		.Digitron_Out( Digitron_Out ) ,	// output - to top
		.DigitronCS_Out( DigitronCS_Out ) 	// output - to top
	);


endmodule

							
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	