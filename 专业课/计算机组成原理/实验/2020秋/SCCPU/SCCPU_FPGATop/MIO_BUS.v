`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:14 06/30/2012 
// Design Name: 
// Module Name:    MIO_BUS 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// memory IO bus

module MIO_BUS(
    input mem_w,
    input [15:0]  sw_i,               // switch input
    input [31:0]  cpu_data_out,       // data from CPU
    input [31:0]  cpu_data_addr,      // address for CPU
    input [31:0]  ram_data_out,       // data from data memory
    
    output reg [31:0]  cpu_data_in,   // data to CPU
    output reg [31:0]  ram_data_in,   // data to data memory
    output reg [6:0]   ram_addr,      // address for data memory
    output reg [31:0]  cpuseg7_data,  // cpu seg7 data (from sw instruction)
    output reg ram_we,                // signal to write data memory
    output reg seg7_we                // signal to write seg7 display 
);


//RAM & IO decode signals:
  always @* begin

    ram_addr = 7'h0;
    ram_data_in = 32'h0;
    cpuseg7_data = 32'h0;
    cpu_data_in = 32'h0;
    seg7_we = 0;
    ram_we = 0;
    
    case(cpu_data_addr[31:0])
      32'hffff0004: // switch
        cpu_data_in = {16'h0, sw_i};
      32'hffff000c: begin // seg7
        cpuseg7_data = cpu_data_out;
        seg7_we = mem_w;
        end
      default: begin
        ram_addr = cpu_data_addr[8:2];
        ram_data_in = cpu_data_out;
        ram_we = mem_w;
        cpu_data_in = ram_data_out;
      end
    endcase
  end

endmodule
