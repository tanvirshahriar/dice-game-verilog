`timescale 1ns / 1ps
// Conversion of a binary number into separate binary numbers representing digits of the decimal number
// suitable to be displayed on seven segment display
module Bin2BCD(
input [7:0] binary,
output reg [3:0] Digit0,
output reg [3:0] Digit1,
output reg [3:0] Digit2
);

integer i;
/*
If any digit (100's, 10's, 1's, etc.) is 5 or greater, add 3 to that digit.

Shift all #'s to the left 1 position.

If 8 shifts have been performed, it's done! Evaluate each digits for the BCD values.

Go to step 1. 
*/
always@*
begin
	Digit0 = 4'd0; 
	Digit1 = 4'd0; 
	Digit2 = 4'd0; 
	for(i=7; i>=0; i=i-1)
	begin
		if(Digit2 >= 5)
			Digit2 = Digit2 + 3;
		if(Digit1 >= 5)
			Digit1 = Digit1 + 3;
		if(Digit0 >= 5)
			Digit0 = Digit0 + 3;
		Digit2 = Digit2 << 1;
		Digit2[0] = Digit1[3];

		Digit1 = Digit1 << 1;
		Digit1[0] = Digit0[3];

		Digit0 = Digit0 << 1;
		Digit0[0] = binary[i];
	end
end

endmodule
