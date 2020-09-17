
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2020 00:06:15
// Design Name: 
// Module Name: keyboard
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module keyboard(
   input wire clk,	//board clock
   input wire ps2_clk,	//keyboard clock and data signals
   input wire ps2_data,
   input wire rst,
   output reg [5:0] key
   	);
 
  reg        clk50M=0;
  wire [7:0] keycode;
  
 always @(posedge(clk))
    begin
     clk50M<=~clk50M;
    end


localparam ARROW_UP = 8'h75;	//codes for arrows
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

PS2Receiver uut (
	.clk(clk50M),
	.kclk(ps2_clk), 
	.kdata(ps2_data),
	.keycode(keycode)

);

always @(*)
	begin
		case( keycode[7:0] )
			ARROW_LEFT: 
				begin
				key = KEY_LEFT;     
				end
			ARROW_RIGHT: 
				begin
				key = KEY_RIGHT;        
				end
			ARROW_UP : 
				begin
				key= KEY_UP;        
				end
			ARROW_DOWN : 
				begin
				key = KEY_DOWN;
				end
		    ENTER:
		       begin
		       key = KEY_ENTER;
		       end
		    ESC:
		       begin
		       key = KEY_ESC;
		       end
			default: 
				begin
				key = NULL;
				end
		endcase
	end


endmodule