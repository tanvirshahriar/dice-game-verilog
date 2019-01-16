module vga_timing

(
	input reset,
	input clk, 
	input trig1, // player1 trigger
	input trig2, // player2 trigger
	input [2:0]player1, // player1 random value
	input [2:0]player2, // player2 random value
	output End_Of_Game, // end of game flag
	output [2:0] score1,// player1 score
	output [2:0] score2,// player 2 score
	input start,
	
	//////////// VGA signals//////////
	output		          		VGA_BLANK_N,
	output		     reg[7:0]	VGA_B,
	output		          		VGA_CLK,
	output		     reg[7:0]	VGA_G,
	output		     reg     	VGA_HS,
	output		     reg[7:0]	VGA_R,
	output		          		VGA_SYNC_N,
	output		     reg       VGA_VS
);
// horizontal sync counter
reg signed[13:0]hscnt;
// vertical sync counter
reg signed[13:0]vscnt;
// vertical cordinates for player 1 and player 2 these values changes with score
reg [13:0]P1_v;
reg [13:0]P2_v;
// winner flags
reg win1, win2;
// Rom addresses
wire signed[13:0]h_addr;
wire signed[13:0]v_addr;
wire signed[12:0]data_addr;
wire signed[13:0]h1_addr;
wire signed[13:0]v1_addr;
wire signed[12:0]data1_addr;
wire signed[13:0]h2_addr;
wire signed[13:0]v2_addr;
wire signed[12:0]data2_addr;
// output of ROMs representing Dice Face
wire [0:0]face1, face2, face3, face4, face5, face6, dice1, dice2;
reg signed [19:0] back_count;
wire signed [19:0] back_wire;
wire [2:0] back_color;
wire [2:0] horse1_color;
wire [2:0] horse2_color;
wire [2:0] start_color;
// constants for DICE coardinates
localparam h=260;
localparam v=280;
// horizontal cordinates for player 1 and player 2 these values are constant
localparam P2_h = 64;
localparam P1_h = 1024-128;
reg screen;

initial begin
hscnt = 0;
vscnt = 0;
back_count = 0;
end
// VGA signals
assign VGA_SYNC_N  = 1'b0;
assign VGA_BLANK_N = 1'b1;
assign VGA_CLK = clk;
//always for start screen
always@(posedge clk)
	begin
		if (!reset) begin
			screen <= 1'b0;
		end else begin
			if(start)
				screen <= 1'b1;
		end
	end
// generate vertical and horizontal signals
always@(posedge clk)
	begin
		if(back_count == 786432)
			back_count <= 0;
		else back_count <= back_count + 1;
		if(hscnt < 1343) begin// increment horizontal counter whenever it is less than max
			hscnt <= hscnt + 1;
		end
		else
			begin
				hscnt <= 0;
				if(vscnt < 805) begin// increment vertical counter whenever it is less than max
					vscnt <= vscnt + 1;
				end
				else
					vscnt <= 0;
			end
		if((hscnt > 1047) && (hscnt < 1184))
			VGA_HS <= 1'b1; // generate horizontal sync
		else
			VGA_HS <= 1'b0;
		if((vscnt > 770) && (vscnt < 777))
			VGA_VS <=  1'b1; // generate vertical sync
		else
			VGA_VS <= 1'b0;
	end

// display Dice
always@(posedge clk)
	if(screen == 1'b0) 		// display start screen
		begin
			// VGA_R <= 8'H00;  // Black region
			// VGA_G <= 8'H00;
			// VGA_B <= 8'H00;
			if(start_color[0] == 1'b0)
				VGA_B <= 8'H00;
			else 
				VGA_B <= 8'HFF;
			if(start_color[1] == 1'b0)
				VGA_G <= 8'H00;
			else
				VGA_G <= 8'HFF;
			if(start_color[2] == 1'b0)
				VGA_R <= 8'H00;
			else
				VGA_R <= 8'HFF;
		end
	else begin 
		if((vscnt < 768) && (hscnt < 1024)) // display region
			begin
				// display Dice12 defined by h+64 to h+127 location and v+64 to v+127 location
				if(hscnt>=h+64 && hscnt<=h+127 && vscnt>=v+64 && vscnt<=v+127) 
					if(dice2==1'b1)
					begin // white
						VGA_R <= 8'HFF;
						VGA_G <= 8'HFF;
						VGA_B <= 8'HFF;
					end
					else begin
						VGA_R <= 8'H00;
						VGA_G <= 8'H00;
						VGA_B <= 8'H00;
					end
				//display Dice 1
				else if(hscnt>=h+384 && hscnt<=h+447 && vscnt>=v+64 && vscnt<=v+127)
					if(dice1==1'b1)
					begin // white
						VGA_R <= 8'HFF;
						VGA_G <= 8'HFF;
						VGA_B <= 8'HFF;
					end
					else begin
						VGA_R <= 8'H00;
						VGA_G <= 8'H00;
						VGA_B <= 8'H00;
					end
				// player 1
				else if(hscnt>=P1_h && hscnt<=P1_h+63 && vscnt>=P1_v && vscnt<=P1_v+63)
					begin
						if(horse1_color[0] == 1'b0)
							VGA_B <= 8'H00;
						else 
							VGA_B <= 8'HFF;
						if(horse1_color[1] == 1'b0)
							VGA_G <= 8'H00;
						else
							VGA_G <= 8'HFF;
						if(horse1_color[2] == 1'b0)
							VGA_R <= 8'H00;
						else
							VGA_R <= 8'HFF;
					end				
				// player 2
				else if(hscnt>=P2_h && hscnt<=P2_h+63 && vscnt>=P2_v && vscnt<=P2_v+63)
					begin
						if(horse2_color[0] == 1'b0)
							VGA_B <= 8'H00;
						else 
							VGA_B <= 8'HFF;
						if(horse2_color[1] == 1'b0)
							VGA_G <= 8'H00;
						else
							VGA_G <= 8'HFF;
						if(horse2_color[2] == 1'b0)
							VGA_R <= 8'H00;
						else
							VGA_R <= 8'HFF;
					end				
				else	
					begin
						if(back_color[0] == 1'b0)
							VGA_B <= 8'H00;
						else 
							VGA_B <= 8'HFF;
						if(back_color[1] == 1'b0)
							VGA_G <= 8'H00;
						else
							VGA_G <= 8'HFF;
						if(back_color[2] == 1'b0)
							VGA_R <= 8'H00;
						else
							VGA_R <= 8'HFF;
					end
			end
		else // outside display region
			begin
				VGA_R <= 8'H00;  // Black region
				VGA_G <= 8'H00;
				VGA_B <= 8'H00;
			end
	end
// the background ram
assign back_wire = {vscnt[9:0], hscnt[9:0]};

//background rom
tack tack
(
	.address(back_wire),
	.clock(clk),
	.q(back_color)
);

// start_screen
startscr startscr
(
	.address(back_wire),
	.clock(clk),
	.q(start_color)
);


// horse1
assign h1_addr = hscnt-P1_h;
assign v1_addr = vscnt-P1_v;
assign data1_addr = {v_addr[5:0],h_addr[5:0]};
horse1 horse1
(
	.address(data1_addr),
	.clock(clk),
	.q(horse1_color)
);
// horse2
assign h2_addr = hscnt-P1_h;
assign v2_addr = vscnt-P1_v;
assign data2_addr = {v_addr[5:0],h_addr[5:0]};
horse2 horse2
(
	.address(data2_addr),
	.clock(clk),
	.q(horse2_color)
);

// set the vertical and horizontal locations for DICE by concatinating vertical and horizontal counters
assign h_addr = hscnt-h;
assign v_addr = vscnt-v;
assign data_addr = {v_addr[5:0],h_addr[5:0]};
// instantiate 6 ROMS containing the 6 Dice Faces
// ROM1
dice1_rom dice1_rom
(
	.addr(data_addr),// rom address
	.clk(clk), 
	.q(face1) // rom output representing dice face 1
);
// ROM2
dice2_rom dice2_rom
(
	.addr(data_addr),// rom address
	.clk(clk), 
	.q(face2) // rom output representing dice face 2
);
// ROM3
dice3_rom dice3_rom
(
	.addr(data_addr),// rom address
	.clk(clk), 
	.q(face3) // rom output representing dice face 3
);
// ROM4
dice4_rom dice4_rom
(
	.addr(data_addr),// rom address
	.clk(clk), 
	.q(face4) // rom output representing dice face 4
);
// ROM5
dice5_rom dice5_rom
(
	.addr(data_addr),// rom address
	.clk(clk), 
	.q(face5) // rom output representing dice face 5
);
// ROM6
dice6_rom dice6_rom
(
	.addr(data_addr),// rom address
	.clk(clk), 
	.q(face6) // rom output representing dice face 6
);

// set the score from 1 to 6 because the random generator output is from 0 to 7
// but the dice values are from 1 to 6
assign score1 =(player1==0)?1 :
					(player1==1)?2 :
					(player1==2)?3 :
					(player1==3)?4 :
					(player1==4)?5 :
					(player1==5)?6 :
					1;
assign score2 =(player2==0)?1 :
					(player2==1)?2 :
					(player2==2)?3 :
					(player2==3)?4 :
					(player2==4)?5 :
					(player2==5)?6 :
					1;
// set the value of dice1 which draws the dice1 on vga depending on the selected rom
// but the dice values are from 1 to 6
assign dice1 = (player1==0)?~face1 :
					(player1==1)?~face2 :
					(player1==2)?~face3 :
					(player1==3)?~face4 :
					(player1==4)?~face5 :
					(player1==5)?~face6 :
					~face1;
// set the value of dice2 which draws the dice2 on vga depending on the selected rom
assign dice2 = (player2==0)?~face1 :
					(player2==1)?~face2 :
					(player2==2)?~face3 :
					(player2==3)?~face4 :
					(player2==4)?~face5 :
					(player2==5)?~face6 :
					~face1;
	// set the value of player1 coardinates
	always@(posedge trig1 or negedge reset)
		if(!reset)begin // when reset set the location to 0
			P1_v <= 0;
			win1 <= 1'b0;
			end
		else if(P1_v>=700)// when 700 set winner player 1
			win1 <= 1'b1;
		else if(win2)     // stop if player 2 wins
		   P1_v <= P1_v; 
		else
			P1_v <= P1_v + (10*score1); // increment player 1 location
	// set the value of player2 coardinates
	always@(posedge trig2 or negedge reset)
		if(!reset)begin // when reset set the location to 0
			P2_v <= 0;
			win2 <= 1'b0;
			end
		else if(P2_v>=700)// when 700 set winner player 2
			win2 <= 1'b1;
		else if(win1)    // stop if player 1 wins
		   P2_v <= P2_v; 
		else
			P2_v <= P2_v + (10*score2); // increment player 1 location	
// end of game when player 1 or player 2 wins
assign End_Of_Game = win1 | win2;
endmodule
