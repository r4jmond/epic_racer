
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
   output reg [4:0] key
   	);
 
   reg        clk50M=0;
   wire [7:0] keycode;
   
    always @(posedge(clk))begin
     clk50M<=~clk50M;
     end

localparam ARROW_UP = 8'h75;	//codes for arrows
localparam ARROW_DOWN = 8'h72;
localparam ARROW_LEFT = 8'h6B;
localparam ARROW_RIGHT = 8'h74;
localparam SPACE = 8'h29;
localparam ESC = 8'h76;

/*	
reg [15:0] kcode, kcode_nxt;		
reg TRIGGER, TRIGGER_nxt = 0;
reg [1:0] key_nxt;
wire [15:0] keycode;
wire [15:0] keycodev=0;
wire flag;
reg delay_FLAG, delay_FLAG_nxt = 1'b0;

localparam SPACE_keyboard = 6'b010000;
localparam ESC_keyboard = 6'b100000;


wire clk50M;
*/

reg [4:0] key_nxt;

localparam KEY_UP = 4'b0001;
localparam KEY_DOWN = 4'b0010;
localparam KEY_LEFT = 4'b0100;
localparam KEY_RIGHT = 4'b1000;

localparam NULL = 4'b0;


PS2Receiver uut (
	.clk(clk50M),
	.kclk(ps2_clk), 
	.kdata(ps2_data),
	.keycode(keycode)

);
/*
 always@(*)
    if (keycode[7:0] == 8'hf0) 
    begin
      TRIGGER_nxt = 1'b0;
      kcode_nxt = kcode;
    end 
    
	else if (keycode[15:8] == 8'hf0)
	begin
      TRIGGER_nxt = 1'b0;
      kcode_nxt = (flag == 1'b1 && (keycode != kcode) ) ? keycode : kcode;
    end
	else 
	begin
      TRIGGER_nxt = (flag == 1'b1 && (keycode[7:0] != kcode[7:0] || kcode[15:8] == 8'hf0) ) ? 1'b1 : 1'b0;
      kcode_nxt = (flag == 1'b1 && (keycode[7:0] != kcode[7:0] || kcode[15:8] == 8'hf0) ) ? keycode : kcode;
    end
    
	always@(posedge clk)
	begin
     //TRIGGER <= TRIGGER_nxt;
     key <= key_nxt;
    end

always@(*) 
  if( delay_FLAG != 1'b0 ) 
  begin
    key_nxt = key;
    delay_FLAG_nxt = 0;
  end 
  else if( TRIGGER == 1'b1 ) 
  */
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
        /*
	  SPACE : 
	    begin
          key = SPACE_k;
          
        end
	  ESC : 
	    begin
          key = ESC_k;
          
        end
        */
     default: 
	    begin
         key = NULL;
        
        end
     endcase
end

          
endmodule