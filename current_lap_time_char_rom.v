`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2020 15:52:46
// Design Name: 
// Module Name: char_rom_16x16
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


module current_lap_time_char_rom(
    input  wire [15:0] char_xy,
    output reg  [6:0]  char_code          // pixels of the character line
);

always@*
begin
    case(char_xy)
        16'h0000: char_code = 7'h43; //C
        16'h0100: char_code = 7'h55; //U
        16'h0200: char_code = 7'h52; //R
        16'h0300: char_code = 7'h52; //R
        16'h0400: char_code = 7'h45; //E
        16'h0500: char_code = 7'h4e; //N
        16'h0600: char_code = 7'h54; //T
        16'h0700: char_code = 7'h00; //
        16'h0800: char_code = 7'h4c; //L
        16'h0900: char_code = 7'h41; //A
        16'h0a00: char_code = 7'h50; //P
        16'h0b00: char_code = 7'h00; // 
        16'h0c00: char_code = 7'h54; //T
        16'h0d00: char_code = 7'h49; //I
        16'h0e00: char_code = 7'h4d; //M
        16'h0f00: char_code = 7'h45; //E
        16'h1000: char_code = 7'h3a; //:
        16'h1100: char_code = 7'h00; //
        16'h1200: char_code = 7'h32; //2
        16'h1300: char_code = 7'h31; //1
        16'h1400: char_code = 7'h3a; //:
        16'h1500: char_code = 7'h33; //3
        16'h1600: char_code = 7'h37; //7
        16'h1700: char_code = 7'h3a; //:
        16'h1800: char_code = 7'h35; //5
        16'h1900: char_code = 7'h37; //7
        16'h1a00: char_code = 7'h20;
        16'h1b00: char_code = 7'h20;
        16'h1c00: char_code = 7'h20;
        default: char_code = 0;
    endcase   
end                       
                          
endmodule                 
                          