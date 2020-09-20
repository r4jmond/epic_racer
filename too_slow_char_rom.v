`timescale 1ns / 1ps


module too_slow_char_rom(
    input  wire [15:0] char_xy,
    output reg  [6:0]  char_code          // pixels of the character line
);

always@*
begin
    case(char_xy)
        16'h0000: char_code = 7'h54; 
        16'h0100: char_code = 7'h4f; 
        16'h0200: char_code = 7'h4f; 
        16'h0300: char_code = 7'h20; 
        16'h0400: char_code = 7'h53; 
        16'h0500: char_code = 7'h4c; 
        16'h0600: char_code = 7'h4f; 
        16'h0700: char_code = 7'h57;
        16'h0800: char_code = 7'h21; 
        16'h0900: char_code = 7'h21; 
        16'h0a00: char_code = 7'h21; 
        16'h0b00: char_code = 7'h00;
        16'h0c00: char_code = 7'h54;
        16'h0d00: char_code = 7'h72;
        16'h0e00: char_code = 7'h79;
        16'h0f00: char_code = 7'h20;
        16'h1000: char_code = 7'h61;
        16'h1100: char_code = 7'h67;
        16'h1200: char_code = 7'h61;
        16'h1300: char_code = 7'h69;
        16'h1400: char_code = 7'h6e;
        16'h1500: char_code = 7'h21;
        default: char_code = 0;
    endcase   
end            
endmodule                 
                          