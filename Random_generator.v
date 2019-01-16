module Random_generator
(
	input clk, 
	input enable, 
	output reg[2:0] rand_num
);

reg[2:0]LFSR;
wire clk_100hz;
reg [18:0]cnt;
initial
begin
	LFSR = 3'b100;
	cnt = 0;
end
// generate 100 HZ clock to blink the Dice fast when player run
// clock divider using a counter is responsible for it
always@(posedge clk)
	  if(cnt>=500000-1)
			cnt <= 0;
	  else
			cnt <= cnt + 1;
// 100 hz clock			
assign clk_100hz = (cnt>=500000-1)? 1'b1 : 1'b0;
// 3 bit linear feedback shift register running at 100 hz speed is used to generate random value 
always@(posedge clk_100hz)
	begin
	  LFSR[0] <= LFSR[1] ^ LFSR[2];
	  LFSR[2 : 1] <= LFSR[1 : 0];
	  if(!enable) // the output of the random number is latched when button is pressed
			rand_num <= LFSR;
	end
endmodule