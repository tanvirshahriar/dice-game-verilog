
module SSD_Driver(
    input  [3:0]data,
    output reg[6:0]HEX
    );
   // generate seven segment values from input BCD values
	always@(*)
	 case(data)
		 0:		HEX=7'b100_0_000;
		 1:		HEX=7'b111_1_001;
		 2:		HEX=7'b010_0_100;
		 3:		HEX=7'b011_0_000;
		 4:		HEX=7'b001_1_001;
		 5:		HEX=7'b001_0_010;
		 6:		HEX=7'b000_0_010;
		 7:		HEX=7'b111_1_000;
		 8:		HEX=7'b000_0_000;
		 9:		HEX=7'b001_1_000;
		 default: HEX= 7'b111_1111;
		endcase
endmodule
