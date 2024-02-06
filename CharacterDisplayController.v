
module CharacterDisplayController(
	input pacman_orientation,
	output reg [2:0] character_type,
	input unsigned [7:0] char_x,
	input unsigned [7:0] char_y,
	output reg vga_plot,
	output [7:0] vga_x,
	output [7:0] vga_y,
	output reg [2:0] vga_color,
	input reset,
	input clock_50);

	// Drawing the pixels of each character and of each of their bitmaps
	reg unsigned [2:0] cur_sprite_x;
	reg unsigned [2:0] cur_sprite_y;

	always @(posedge clock_50)
	begin
		if (reset == 1'b1)
		begin
			character_type <= 3'd0;
			cur_sprite_x <= 3'd0;
			cur_sprite_y <= 3'd0;
		end
		else 
		begin
			if (cur_sprite_y != 3'd4 || cur_sprite_x != 3'd4)
			begin
				if(cur_sprite_x < 3'd4)
				begin
					cur_sprite_x <= cur_sprite_x + 3'd1;
				end

				else
				begin
					cur_sprite_x <= 3'd0;
					cur_sprite_y <= cur_sprite_y + 3'd1;
				end
			end
			else
			begin
				cur_sprite_x <= 3'd0;
				cur_sprite_y <= 3'd0;

				if (character_type == 3'd4)
				begin
					character_type <= 3'd0;
				end
				else
				begin
					character_type <= character_type + 3'd1;
				end
			end
		end
	end

	assign vga_x = char_x + {5'd00000, cur_sprite_x} + 8'd26;
	assign vga_y = char_y + {5'd00000, cur_sprite_y} + 8'd1;

	reg [4:0] row0;
	reg [4:0] row1;
	reg [4:0] row2;
	reg [4:0] row3;
	reg [4:0] row4;

	reg [2:0] sprite_color;

	always @(*)
	begin
		if (character_type == 3'b000) // Pacman
		begin
			if (pacman_orientation == 1'b0) 
			begin
				row0 = 5'b01110;
				row1 = 5'b00111;
				row2 = 5'b00011;
				row3 = 5'b00111;
				row4 = 5'b01110;
			end

			sprite_color = 3'b110;
		end
		else // The ghosts
		begin
			row0 = 5'b01110;
			row1 = 5'b10101;
			row2 = 5'b11111;
			row3 = 5'b11111;
			row4 = 5'b10101;

			case (character_type)
				3'b001: sprite_color = 3'b011; // Cyan color
				3'b010: sprite_color = 3'b100; // Red color
				3'b011: sprite_color = 3'b010; // Green
				3'b100: sprite_color = 3'b101; // Magenta
				default: sprite_color = 3'b000;
			endcase
		end
	end

	reg [6:0] selected_row;
	always @(*)
	begin
		case (cur_sprite_y)
			4'd0: selected_row = row0;
			4'd1: selected_row = row1;
			4'd2: selected_row = row2;
			4'd3: selected_row = row3;
			4'd4: selected_row = row4;

			default: selected_row = row0;
		endcase
	end

	reg selected_col;
	always @(*)
	begin
		case (cur_sprite_x)
			4'd0: selected_col = selected_row[0];
			4'd1: selected_col = selected_row[1];
			4'd2: selected_col = selected_row[2];
			4'd3: selected_col = selected_row[3];
			4'd4: selected_col = selected_row[4];

			default: selected_col = selected_row[0];
		endcase
	end

	always @(*)
	begin
		vga_color = sprite_color;

		if (selected_col == 1'b1 && reset == 1'b0)
		begin
			vga_plot = 1'b1;
		end
		else
		begin
			vga_plot = 1'b0;
		end
	end

endmodule
