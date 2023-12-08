// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/main/ip/altera_connection_identification_hub/altera_connection_identification_hub.sv.terp#1 $
// $Revision: #1 $
// $Date: 2012/05/24 $
// $Author: adraper $

// -------------------------------------------------------
// Altera Identification hub
//
// Parameters
//   DESIGN_HASH   : 898a9063126e9ac8936b
//   COUNT         : 1
//   ROM_WIDTHS    : 4
//   LATENCIES     : 0
//
// -------------------------------------------------------


`timescale 1 ns / 1 ns

module alt_sld_fab_ident
(
	input [4:0] address_0,
	input [3:0] contrib_0,
	output [3:0] rdata_0,
	output [3:0] mixed
);


wire [127:0] data_0 = { mixed, 12'h0, 32'h0, 80'h898a9063126e9ac8936b };

reg [3:0] result_0;
always @(address_0 or data_0) begin
        case (address_0)
            0: result_0 <= data_0[0+:4];    
            1: result_0 <= data_0[4+:4];    
            2: result_0 <= data_0[8+:4];    
            3: result_0 <= data_0[12+:4];    
            4: result_0 <= data_0[16+:4];    
            5: result_0 <= data_0[20+:4];    
            6: result_0 <= data_0[24+:4];    
            7: result_0 <= data_0[28+:4];    
            8: result_0 <= data_0[32+:4];    
            9: result_0 <= data_0[36+:4];    
            10: result_0 <= data_0[40+:4];    
            11: result_0 <= data_0[44+:4];    
            12: result_0 <= data_0[48+:4];    
            13: result_0 <= data_0[52+:4];    
            14: result_0 <= data_0[56+:4];    
            15: result_0 <= data_0[60+:4];    
            16: result_0 <= data_0[64+:4];    
            17: result_0 <= data_0[68+:4];    
            18: result_0 <= data_0[72+:4];    
            19: result_0 <= data_0[76+:4];    
            20: result_0 <= data_0[80+:4];    
            21: result_0 <= data_0[84+:4];    
            22: result_0 <= data_0[88+:4];    
            23: result_0 <= data_0[92+:4];    
            24: result_0 <= data_0[96+:4];    
            25: result_0 <= data_0[100+:4];    
            26: result_0 <= data_0[104+:4];    
            27: result_0 <= data_0[108+:4];    
            28: result_0 <= data_0[112+:4];    
            29: result_0 <= data_0[116+:4];    
            30: result_0 <= data_0[120+:4];    
            31: result_0 <= data_0[124+:4];    
            default: result_0 <= 0;
        endcase
end
assign rdata_0 = result_0;

// TODO: Cut timing paths into and out of mixed

assign mixed =
	contrib_0 ^
	4'h0;

endmodule

