`timescale 1ns / 1ps


module cheater_char_rom(
    input  wire [15:0] char_xy,
    output reg  [6:0]  char_code          // pixels of the character line
);

always@*
begin
    case(char_xy)
        16'h0000: char_code = 7'h49;
        16'h0100: char_code = 7'h20; 
        16'h0200: char_code = 7'h74; 
        16'h0300: char_code = 7'h68; 
        16'h0400: char_code = 7'h69; 
        16'h0500: char_code = 7'h6e; 
        16'h0600: char_code = 7'h6b;
        16'h0700: char_code = 7'h20;
        16'h0800: char_code = 7'h77; 
        16'h0900: char_code = 7'h65; 
        16'h0a00: char_code = 7'h20;
        16'h0b00: char_code = 7'h67; 
        16'h0c00: char_code = 7'h6f; 
        16'h0d00: char_code = 7'h74; 
        16'h0e00: char_code = 7'h20; 
        16'h0f00: char_code = 7'h61; 
        16'h1000: char_code = 7'h20; 
        16'h1100: char_code = 7'h43;
        16'h1200: char_code = 7'h68;
        16'h1300: char_code = 7'h65;
        16'h1400: char_code = 7'h61;
        16'h1500: char_code = 7'h74;
        16'h1600: char_code = 7'h65;
        16'h1700: char_code = 7'h72;
        16'h1800: char_code = 7'h20;
        16'h1900: char_code = 7'h68;
        16'h1a00: char_code = 7'h65;
        16'h1b00: char_code = 7'h72;
        16'h1c00: char_code = 7'h65;
        16'h1d00: char_code = 7'h21;
        default: char_code = 0;
    endcase   
end         
endmodule                  