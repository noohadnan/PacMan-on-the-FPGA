module MapController(
	input [4:0] map_x,
	input [4:0] map_y,
	input [2:0] sprite_data_in,
	output [2:0] sprite_data_out,
	input readwrite,
	input clock_50);

	wire [8:0] extended_map_x = {3'b000, map_x};

	wire [8:0] extended_map_y = {3'b000, map_y};


	wire [8:0] client_address;
	assign client_address = (9'd21 * extended_map_y) + extended_map_x;

	Map map(
		.address(client_address),
		.clock(clock_50),
		.data(sprite_data_in),
		.wren(readwrite),
		.q(sprite_data_out)
		);

endmodule

module MapDisplayController(
	output reg unsigned [4:0] map_x, 
	output reg unsigned [4:0] map_y, 
	input [2:0] sprite_type, 
	output reg vga_plot, 
	output unsigned [7:0] vga_x,
	output unsigned [7:0] vga_y,
	output reg [2:0] vga_color,
	input reset, 
	input clock_50);
	
	reg unsigned [2:0] cur_sprite_x;
	reg unsigned [2:0] cur_sprite_y;
	

	always @(posedge clock_50) 
	begin
		if (reset == 1'b1) 
		begin
			map_x <= 5'd0;
			map_y <= 5'd0;
			cur_sprite_x <= 3'd0;
			cur_sprite_y <= 3'd0;	
			vga_plot <= 1'b1;
		end
		
		else
		begin
			// If we are currently drawing the sprite
			if (cur_sprite_y != 3'd4 || cur_sprite_x != 3'd4)
			begin			
				if(cur_sprite_x < 3'd4)
					cur_sprite_x <= cur_sprite_x + 3'd1;
					
				else //if (cur_sprite_x == 3'd4)
				begin
					cur_sprite_x <= 3'd0;
					cur_sprite_y <= cur_sprite_y + 3'd1;
				end
			end
			
			// If we have finished drawing the sprite
			else 
			begin
				cur_sprite_x <= 3'd0;
				cur_sprite_y <= 3'd0;
				
				// Reset the current sprite coordinates
				if (map_x == 5'd20)
				begin
					map_x <= 5'd0;											
					
					if (map_y == 5'd20)
					begin
						map_y <= 5'd0;
					end
					else
					begin
						map_y <= map_y + 5'd1;
					end
				end
				else 
				begin
					map_x <= map_x + 5'd1;					
				end	
			end		
		end
	end	

	// Determine the absolute pixel coordinates on the screen
	assign vga_x = ({3'b000, map_x} * 8'd5) + {5'd0, cur_sprite_x} + 8'd26;
	assign vga_y = ({3'b000, map_y} * 8'd5) + {5'd0, cur_sprite_y} + 8'd1;

	// Determining the sprite
	reg [4:0] row0;
	reg [4:0] row1;
	reg [4:0] row2;
	reg [4:0] row3;
	reg [4:0] row4;

	reg [2:0] sprite_color;

	always @(*)
	begin
		if (sprite_type == 3'b000) // A black tile
		begin
			row0 = 5'b00000;
			row1 = 5'b00000;
			row2 = 5'b00000;
			row3 = 5'b00000;
			row4 = 5'b00000;

			sprite_color = 3'b000;
		end
		else if (sprite_type == 3'b001) // A big orb
		begin
			row0 = 5'b00000;
			row1 = 5'b00100;
			row2 = 5'b01110;
			row3 = 5'b00100;
			row4 = 5'b00000;

			sprite_color = 3'b111;
		end
		else if (sprite_type == 3'b010) // A small orb
		begin
			row0 = 5'b00000;
			row1 = 5'b00000;
			row2 = 5'b00100;
			row3 = 5'b00000;
			row4 = 5'b00000;
			sprite_color = 3'b111;
		end
		else if (sprite_type == 3'b011) // A blue tile
		begin
			row0 = 5'b11111;
			row1 = 5'b11111;
			row2 = 5'b11111;
			row3 = 5'b11111;
			row4 = 5'b11111;

			sprite_color = 3'b001;
		end
		else if (sprite_type == 3'b100) // A grey tile
		begin
			row0 = 5'b11111;
			row1 = 5'b11111;
			row2 = 5'b11111;
			row3 = 5'b11111;
			row4 = 5'b11111;

			sprite_color = 3'b010;
		end
		else
		begin
			row0 = 5'b11111;
			row1 = 5'b11111;
			row2 = 5'b11111;
			row3 = 5'b11111;
			row4 = 5'b11111;

			sprite_color = 3'b010;
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
		case (selected_col)
			1'b1: vga_color = sprite_color;
			1'b0: vga_color = 3'b000;
		endcase
	end
endmodule

