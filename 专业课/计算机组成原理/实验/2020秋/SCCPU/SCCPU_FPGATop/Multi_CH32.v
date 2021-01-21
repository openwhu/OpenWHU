`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:50:10 11/03/2014 
// Design Name: 
// Module Name:    Output_2_Disp 
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


module 		Multi_CH32(
              input clk,              // clock
              input rst,              // reset
              input EN,               // Write EN
              input[5:0]  ctrl,       // SW[5:0]
              input[31:0] Data0,      // channel 0 for CPU (sw)
              input[31:0] data1,      // data for test channel 1
              input[31:0] data2,      // data for test channel 2
              input[31:0] data3,      // data for test channel 3
              input[31:0] data4,      // data for test channel 4
              input[31:0] data5,      // data for test channel 5
              input[31:0] data6,      // data for test channel 6
              input[31:0] data7,      // data for test channel 7
              input[31:0] reg_data,   // data of selected register (ctrl[4:0] if ctrl[5] == '1')
              output reg [31:0] seg7_data // data to be displayed on seg7
              );

  reg[31:0] disp_data = 32'hAA5555AA; // default data for test channel 0
  
  always @( * )
      casex(ctrl) // SW[5:0]
         6'b000000: seg7_data = disp_data;
         6'b000001: seg7_data = data1;
         6'b000010: seg7_data = data2;
         6'b000011: seg7_data = data3;
         6'b000100: seg7_data = data4;
         6'b000101: seg7_data = data5;
         6'b000110: seg7_data = data6;
         6'b000111: seg7_data = data7;
         6'b001xxx: seg7_data = 32'hFFFFFFFF;
         6'b01xxxx: seg7_data = 32'hFFFFFFFF;
         6'b1xxxxx: seg7_data = reg_data;
      endcase


  always@(posedge rst, posedge clk )begin
    if (rst) 
      disp_data <= 32'hAA5555AA;
    else begin
      if(EN) 
        disp_data <= Data0;     //Data0
      else
        disp_data <= disp_data; 
    end
  end


endmodule
