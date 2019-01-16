# dice-game-verilog
Modified implementation of the South Asian board game - Ludo, for Altera Cyclone V FPGAs. 

### I/O
- DE1_SoC prototype board KEYs 0-3
- VGA monitor

### Notes
- VGA display adapter *(vga_timing.v)* built for 1024x768 displays
- If FPGA runs out of storage disable start screen and recompile
  * Remove lines vga_timing.v:109 - vga_timing.v:127 and vga_timing.v:223 - vga_timing.v:228

### Gameplay
Hold down player keys to roll dice, release key to move player piece. First player to reach the end of the board wins.
- Key 0 - Reset
- Key 1 - Player 1
- Key 2 - Player 2
- Key 3 - Start Game **Only applies to game version with start screen
