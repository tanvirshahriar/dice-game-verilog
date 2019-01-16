`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:30:32 11/26/2014 
// Design Name: 
// Module Name:    ShiftAdd3 
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
module ShiftAdd3(data, d_in, d_out);

parameter digits = 4;
input wire data;
input wire [4*digits - 1:0] d_in;
output wire[4*digits - 1:0] d_out;

wire [3:0]d[0:digits-1];
wire [digits-1:0]msb;

assign msb[0] = data;
genvar i;
   generate
      for (i=1; i < digits; i=i+1) begin : MSB_array
					assign	msb[i] = d[i-1][3];
			  end 
	endgenerate

   generate
      for (i=0; i < digits; i=i+1) begin : shift_add
					assign	d[i] =(d_in[3+(4*i) : 4*i]>=5)? (d_in[3+(4*i) : 4*i] + 3):
										 d_in[3+(4*i) : 4*i];
			  end 
	endgenerate

   generate
      for (i=0; i < digits; i=i+1) begin : pack_data
					assign	d_out[3+(4*i) : 4*i] = {d[i][2:0], msb[i]};
			  end 
	endgenerate
endmodule
