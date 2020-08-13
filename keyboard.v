
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
   input wire CLK,	//board clock
   input wire PS2_CLK,	//keyboard clock and data signals
   input wire  PS2_DATA,
   input wire rst,
   output reg [1:0] key
   	);

	localparam ARROW_UP = 8'h75;	//codes for arrows
	localparam ARROW_DOWN = 8'h72;
	localparam ARROW_LEFT = 8'h6B;
	localparam ARROW_RIGHT = 8'h74;
	localparam SPACE = 8'h29;
	localparam ESC = 8'h76;

	
	reg [15:0] kcode, kcode_nxt;		
	reg TRIGGER, TRIGGER_nxt = 0;
	reg [1:0] key_nxt;
	reg [15:0] scan_code;
	wire FLAG;
	reg delay_FLAG, delay_FLAG_nxt = 1'b0;
	
		
	Keyboard_PS2 (
		.CLK(CLK),
		.PS2_CLK(PS2_CLK), 
		.PS2_DATA(PS2_DATA),
		.scan_code(scan_code),
		.FLAG(FLAG)
		);

  always@(*)
    if (scan_code[7:0] == 8'hf0) 
	begin
      TRIGGER = 1'b0;
      kcode_nxt = kcode;
    end 
	else if (scan_code[15:8] == 8'hf0)
	begin
      TRIGGER = 1'b0;
      kcode_nxt = (FLAG == 1'b1 && (scan_code != kcode) ) ? scan_code : kcode;
    end
	else 
	begin
      TRIGGER_nxt = (FLAG == 1'b1 && (scan_code[7:0] != kcode[7:0] || kcode[15:8] == 8'hf0) ) ? 1'b1 : 1'b0;
      kcode_nxt = (FLAG == 1'b1 && (scan_code[7:0] != kcode[7:0] || kcode[15:8] == 8'hf0) ) ? scan_code : kcode;
    end
	
	always@(posedge CLK)
	begin
    TRIGGER <= TRIGGER_nxt;
    kcode <= kcode_nxt;
    end

  always@(*) 
   if( delay_FLAG != 1'b0 ) 
   begin
     key_nxt = key;
     delay_FLAG_nxt = delay_FLAG- 1;
   end 
   else if( TRIGGER == 1'b1 ) 
     case( kcode[7:0] )
       ARROW_LEFT: 
	   begin
         key_nxt = ARROW_LEFT_state;
         delay_FLAG_nxt = 1'b1;
       end
       ARROW_RIGHT: 
	   begin
         key_nxt = ARROW_RIGHT_state;
         delay_FLAG_nxt = 1'b1;
       end
	   ARROW_UP : 
	   begin
         key_nxt = ARROW_UP_state;
         delay_FLAG_nxt = 1'b1;
       end
	   ARROW_DOWN : 
	   begin
         key_nxt = ARROW_DOWN_state;
         delay_FLAG_nxt = 1'b1;
       end
	    SPACE : 
	   begin
         key_nxt = SPACE_state;
         delay_FLAG_nxt = 1'b1;
       end
	    ESC : 
	   begin
         key_nxt = ESC_state;
         delay_FLAG_nxt = 1'b1;
       end
       default: 
	   begin
         key_nxt = NULL_state;
         delay_FLAG_nxt = 1'b0;
       end
     endcase
   else 
   begin
     key_nxt = NULL_state;
     delay_FLAG_nxt = 1'b0;
   end
  
  always@(posedge CLK) 
  begin
    if(rst) 
	begin
      key <= NULL_state;
      delay_FLAG<= 1'b0;
    end
    else 
	begin
      key <= key_nxt;
      delay_FLAG <= delay_FLAG_nxt;
    end  
  end
          
endmodule