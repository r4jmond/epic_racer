
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

localparam ARROW_UP = 8'h75;	//codes for arrows
localparam ARROW_DOWN = 8'h72;
localparam ARROW_LEFT = 8'h6B;
localparam ARROW_RIGHT = 8'h74;
localparam SPACE = 8'h29;
localparam ESC = 8'h76;

	
reg [15:0] kcode, kcode_nxt;		
reg TRIGGER, TRIGGER_nxt = 0;
reg [5:0] key_nxt;
wire [15:0] keycode;
wire [15:0] keycodev=0;
wire flag;
reg delay_FLAG, delay_FLAG_nxt = 1'b0;

localparam ARROW_LEFT_keyboard = 6'b000001;
localparam ARROW_RIGHT_keyboard = 6'b000010;
localparam ARROW_UP_keyboard = 6'b000100;
localparam ARROW_DOWN_keyboard = 6'b001000;
localparam SPACE_keyboard = 6'b010000;
localparam ESC_keyboard = 6'b100000;

localparam NULL = 6'b0;

PS2Receiver (
	.clk(clk),
	.kclk(ps2_clk), 
	.kdata(ps2_data),
	.keycode(keycode),
	.oflag(flag)
);

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
     TRIGGER <= TRIGGER_nxt;
     kcode <= kcode_nxt;
    end

always@(*) 
  if( delay_FLAG != 1'b0 ) 
  begin
    key_nxt = key;
    delay_FLAG_nxt = 0;
  end 
  else if( TRIGGER == 1'b1 ) 
    case( kcode[7:0] )
      ARROW_LEFT: 
	   begin
         key_nxt = ARROW_LEFT_keyboard;
         delay_FLAG_nxt = 1'b1;
       end
      ARROW_RIGHT: 
	    begin
          key_nxt = ARROW_RIGHT_keyboard;
          delay_FLAG_nxt = 1'b1;
         end
	  ARROW_UP : 
	    begin
          key_nxt = ARROW_UP_keyboard;
          delay_FLAG_nxt = 1'b1;
       end
	  ARROW_DOWN : 
	    begin
          key_nxt = ARROW_DOWN_keyboard;
          delay_FLAG_nxt = 1'b1;
        end
	  SPACE : 
	    begin
          key_nxt = SPACE_keyboard;
          delay_FLAG_nxt = 1'b1;
        end
	  ESC : 
	    begin
          key_nxt = ESC_keyboard;
          delay_FLAG_nxt = 1'b1;
        end
     default: 
	    begin
         key_nxt = NULL;
         delay_FLAG_nxt = 1'b0;
        end
     endcase
   else 
    begin
      key_nxt = NULL;
      delay_FLAG_nxt = 1'b0;
    end
  
always@(posedge clk) 
begin
   if(rst) 
   begin
       key <= NULL;
       delay_FLAG <= 0;
       TRIGGER <= 0;
       kcode <= 0;
   end
   else 
   begin
       key <= key_nxt;
       delay_FLAG <= delay_FLAG_nxt;
       TRIGGER <= TRIGGER_nxt;
       kcode <= kcode_nxt;
   end  
end
          
endmodule