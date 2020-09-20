`timescale 1ns / 1ps

module keyboard(
   input wire clk,
   input wire ps2_clk,
   input wire ps2_data,
   input wire rst,
   output reg [5:0] key,
   output reg [7:0] keyboard_signal
);

localparam ARROW_UP = 8'h75;
localparam ARROW_DOWN = 8'h72;
localparam ARROW_LEFT = 8'h6B;
localparam ARROW_RIGHT = 8'h74;
localparam ENTER = 8'h5A;
localparam ESC = 8'h76;


localparam KEY_UP = 6'b000001;
localparam KEY_DOWN = 6'b000010;
localparam KEY_LEFT = 6'b000100;
localparam KEY_RIGHT = 6'b001000;
localparam KEY_ENTER = 6'b010000;
localparam KEY_ESC = 6'b100000;
localparam NULL = 6'b000000;

reg [5:0] key_nxt;
wire [7:0] keycode;

PS2Receiver uut (
	.clk(clk),
	.kclk(ps2_clk), 
	.kdata(ps2_data),
	.keycode(keycode)
);

always @(*)
begin
	case( keycode[7:0] )
		ARROW_LEFT: 
		begin
			key_nxt = KEY_LEFT;     
		end
		ARROW_RIGHT: 
		begin
			key_nxt = KEY_RIGHT;        
		end
		ARROW_UP: 
		begin
			key_nxt = KEY_UP;        
		end
		ARROW_DOWN: 
		begin
			key_nxt = KEY_DOWN;
		end
	    ENTER:
	    begin
	       key_nxt = KEY_ENTER;
	    end
	    ESC:
	    begin
	       key_nxt = KEY_ESC;
	    end
		default: 
		begin
			key_nxt = NULL;
		end
	endcase
end

always@(posedge clk)
begin
    if(rst)
    begin
        key <= 0;
        keyboard_signal <= 0;
    end
    else
    begin
        key <= key_nxt;
        keyboard_signal <= keycode;
    end
end
  
endmodule