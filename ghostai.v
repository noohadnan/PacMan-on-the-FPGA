module return_pink_ghost_direction(

	input wire slow_clock_in,
	output reg [1:0] dx,
	output reg [1:0] dy);

	reg vx_s;
	reg vy_s;

	always @(posedge slow clock_in) begin

		vx_s<={$random}%2;
		vy_s<={$random}%2;

		if(vectorx!=9'b000000000) begin
			case(vx_s)
				1'b1: dx=2'b10;
				1'b0: dx=2'b01;
			endcase
		end
		else begin
			dx=2'b00;
		end
		
		if(vectory!=9'b000000000) begin
			case(vy_s)
				1'b1: dy=2'b10;
				1'b0: dy=2'b01;
			endcase
		end
		else begin
			dy=2'b00;
		end
	end

endmodule

module return_blue_ghost_direction(
	input [8:0] pacmanx,
    input [8:0] pacmany,
	input [8:0] B_ghostx,
    input [8:0] B_ghosty,
	input [8:0] R_ghostx,
    input [8:0] R_ghosty,
	input clock_in,
	output reg [1:0] dx,
	output reg [1:0] dy);

	reg vx_s;
	reg vy_s;
	reg [8:0] BPvectorx;
	reg [8:0] BPvectory;
	reg [8:0] RPvectorx;
	reg [8:0] RPvectory;
	reg [8:0] avgvectorx;
	reg [8:0] avgvectory;

	localparam map_array = 9'd21;

	always @(posedge clock_in) begin
		BPvectorx<=pacmanx-Bghostx;
		BPvectory<=pacmany-Bghosty;
		RBvectorx<=Rghostx-Bghostx;
		RBvectory<=Rghosty-Bghosty;
		avgvectorx<=((BPvectorx+RBvectorx)/2);
		avgvectory<=((BPvectory+RBvectory)/2);

		vx_s<=avgvectorx[8];
		vy_s<=avgvectory[8];

		if(vectorx!=9'b000000000) begin
			case(vx_s)
				1'b1: dx=2'b10;
				1'b0: dx=2'b01;
			endcase
		end
		else begin
			dx=2'b00;
		end
		
		if(vectory!=9'b000000000) begin
			case(vy_s)
				1'b1: dy=2'b10;
				1'b0: dy=2'b01;
			endcase
		end
		else begin
			dy=2'b00;
		end
	end
endmodule


module return_green_ghost_direction(
	input [8:0] pacmanx,
    input [8:0] pacmany,
	input [8:0] ghostx,
    input [8:0] ghosty,
	input clock_in,
	output reg [1:0] dx,
	output reg [1:0] dy);

	reg vx_s;
	reg vy_s;
	reg [8:0] vectorx;
	reg [8:0] vectory;


	localparam map_array = 9'd21;

	always @(posedge clock_in) begin

		vectorx<=pacmanx-ghostx;
		vectory<=pacmany-ghosty;
		vx_s<= ~vectorx[8];
		vy_s<= ~vectory[8];

		if(vectorx!=9'b000000000) begin
			case(vx_s)
				1'b1: dx=2'b10;
				1'b0: dx=2'b01;
			endcase
		end
		else begin
			dx=2'b00;
		end
		
		if(vectory!=9'b000000000) begin
			case(vy_s)
				1'b1: dy=2'b10;
				1'b0: dy=2'b01;
			endcase
		end
		else begin
			dy=2'b00;
		end
	end

endmodule



module return_red_ghost_direction(
	input [8:0] pacmanx,
    input [8:0] pacmany,
	input [8:0] ghostx,
    input [8:0] ghosty,
	input clock_in,
	output reg [1:0] dx,
	output reg [1:0] dy);

	reg vx_s;
	reg vy_s;
	reg [8:0] vectorx;
	reg [8:0] vectory;


	localparam map_array = 9'd21;

	always @(posedge clock_in) begin

		vectorx<=pacmanx-ghostx;
		vectory<=pacmany-ghosty;
		vx_s<=vectorx[8];
		vy_s<=vectory[8];

		if(vectorx!=9'b000000000) begin
			case(vx_s)
				1'b1: dx=2'b10;
				1'b0: dx=2'b01;
			endcase
		end
		else begin
			dx=2'b00;
		end
		
		if(vectory!=9'b000000000) begin
			case(vy_s)
				1'b1: dy=2'b10;
				1'b0: dy=2'b01;
			endcase
		end
		else begin
			dy=2'b00;
		end
	end

endmodule



/*
module RandomNumberGenerator (
  input wire clk,
  input wire rst,
  output reg rand_out
);

  reg [0:0] lfsr;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      lfsr <= 1'b1; // Initialize the LFSR with any non-zero seed
    end else begin
      // Shift the LFSR and XOR the feedback bit
      lfsr <= {lfsr[0] ^ lfsr[0], lfsr[0]};
    end
  end

  // Output the LSB of the LFSR as the random bit
  assign rand_out = lfsr[0];

endmodule