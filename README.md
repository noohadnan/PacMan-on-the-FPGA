# PacMan on the FPGA

A hardware implementation of Pac-Man built for Altera/Intel FPGA development boards with VGA output and a PS/2 keyboard. The design renders a 21×21 tile maze at 160×120 resolution, draws sprites directly to the VGA controller, and lets players steer Pac-Man with the keyboard while hex displays show the collected pellets.

## Repository layout
- `Pacman.v`: Top-level module wiring the VGA adapter, PS/2 input, score displays, and the main game logic state machine.
- `Map.v` and `MapController.v`: On-chip RAM map storage plus logic to fetch sprites and translate map coordinates to VGA pixels.
- `CharacterDisplayController.v`, `ghostai.v`, and related files: Movement, AI targeting, and per-character drawing logic for Pac-Man and the four ghosts.
- `PS2_Demo.v` and `PS2_Controller*.v`: Keyboard interface that decodes arrow keys into movement signals.
- `vga_adapter.v` and `vga_controller.v`: VGA timing and framebuffer helpers configured for 160×120 with 1 bit per color channel.
- Support modules such as `RateDivider.v`, `Counter.v`, and `HexDisplay.v` provide slower game ticks, coordinate counting, and 7-segment score output.

## Hardware requirements
- An FPGA development board with a 50 MHz system clock, PS/2 port, VGA output, 10 slide switches, 4 pushbuttons, and six 7-segment HEX displays (e.g., DE1/DE2/DE1-SoC class boards).
- PS/2 keyboard for player input.
- VGA monitor and cable.

## Building the design
1. **Create or open a Quartus project** targeting your board and device family.
2. **Add all Verilog sources** from this repository to the project, ensuring `Pacman` is selected as the top-level entity.
3. **Set up the PLL/IP**: include `vga_pll.v` and the generated `vga_adapter` files as provided.
4. **Assign pins** according to your board's reference designations for VGA, PS/2, switches, keys, LEDs, HEX displays, and the 50 MHz clock.
5. **Compile** the project in Quartus. Resolve any device-specific pin assignment warnings that arise.
6. **Program the FPGA** using the generated `.sof`/`.pof` through the Quartus Programmer.

## Running the game
1. Connect the VGA display and PS/2 keyboard to the board.
2. Power on the board and program the bitstream.
3. Use switch `SW[9]` as reset (up = reset asserted, down = run).
4. Steer Pac-Man with the arrow keys:
   - Up: scan code `1D`
   - Down: scan code `1B`
   - Left: scan code `1C`
   - Right: scan code `23`
5. Watch the VGA output for the maze and characters. The HEX0/HEX1 displays show the pellet count, and the LEDR bar provides debug output from the game FSM.

## Notes and tips
- The VGA adapter is configured for a 160×120 frame with a black default background (`black.mif`). Adjust the `vga_adapter` parameters in `Pacman.v` if you target a different resolution or color depth.
- Game timing is slowed by `RateDivider` to keep movement visible; tune the divider interval to speed up or slow down gameplay.
- The map RAM stores sprite codes for 5×5 pixel tiles; see `Map.v` for the initial maze layout and modify it to change level geometry.
- For board-specific pinouts or simulation, integrate these sources into your existing Quartus workflows; no additional scripts are required in this repository.
