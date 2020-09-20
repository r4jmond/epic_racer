`timescale 1ns / 1ps


module current_lap_time_char_rom(
    input  wire [15:0] char_xy,
    input  wire [15:0] current_lap_time,
    output reg  [6:0]  char_code          // pixels of the character line
);

wire [3:0] bcd0, bcd1, bcd2, bcd3, minutes;

bin2bcd(
    .bin(current_lap_time),
    .bcd0(bcd0),
    .bcd1(bcd1),
    .bcd2(bcd2),
    .bcd3(bcd3),
    .minutes(minutes)
);

reg [7:0] char_code_0, char_code_1, char_code_2, char_code_3, char_code_4;

always@*
begin

    char_code_0 = 7'h00;
    char_code_1 = 7'h00;
    char_code_2 = 7'h00;
    char_code_3 = 7'h00;
    char_code_4 = 7'h00;

    case(bcd0)
    4'b0000: char_code_0 = 7'h30;
    4'b0001: char_code_0 = 7'h31;
    4'b0010: char_code_0 = 7'h32;
    4'b0011: char_code_0 = 7'h33;
    4'b0100: char_code_0 = 7'h34;
    4'b0101: char_code_0 = 7'h35;
    4'b0110: char_code_0 = 7'h36;
    4'b0111: char_code_0 = 7'h37;
    4'b1000: char_code_0 = 7'h38;
    4'b1001: char_code_0 = 7'h39;
    default: char_code_0 = 7'h00;
    endcase
    
    case(bcd1)
    4'b0000: char_code_1 = 7'h30;
    4'b0001: char_code_1 = 7'h31;
    4'b0010: char_code_1 = 7'h32;
    4'b0011: char_code_1 = 7'h33;
    4'b0100: char_code_1 = 7'h34;
    4'b0101: char_code_1 = 7'h35;
    4'b0110: char_code_1 = 7'h36;
    4'b0111: char_code_1 = 7'h37;
    4'b1000: char_code_1 = 7'h38;
    4'b1001: char_code_1 = 7'h39;
    default: char_code_1 = 7'h00;
    endcase
    
    case(bcd2)
    4'b0000: char_code_2 = 7'h30;
    4'b0001: char_code_2 = 7'h31;
    4'b0010: char_code_2 = 7'h32;
    4'b0011: char_code_2 = 7'h33;
    4'b0100: char_code_2 = 7'h34;
    4'b0101: char_code_2 = 7'h35;
    4'b0110: char_code_2 = 7'h36;
    4'b0111: char_code_2 = 7'h37;
    4'b1000: char_code_2 = 7'h38;
    4'b1001: char_code_2 = 7'h39;
    default: char_code_2 = 7'h00;
    endcase
    
    case(bcd3)
    4'b0000: char_code_3 = 7'h30;
    4'b0001: char_code_3 = 7'h31;
    4'b0010: char_code_3 = 7'h32;
    4'b0011: char_code_3 = 7'h33;
    4'b0100: char_code_3 = 7'h34;
    4'b0101: char_code_3 = 7'h35;
    4'b0110: char_code_3 = 7'h36;
    4'b0111: char_code_3 = 7'h37;
    4'b1000: char_code_3 = 7'h38;
    4'b1001: char_code_3 = 7'h39;
    default: char_code_3 = 7'h00;
    endcase
    
    case(minutes)
    4'b0000: char_code_4 = 7'h30;
    4'b0001: char_code_4 = 7'h31;
    4'b0010: char_code_4 = 7'h32;
    4'b0011: char_code_4 = 7'h33;
    4'b0100: char_code_4 = 7'h34;
    4'b0101: char_code_4 = 7'h35;
    4'b0110: char_code_4 = 7'h36;
    4'b0111: char_code_4 = 7'h37;
    4'b1000: char_code_4 = 7'h38;
    4'b1001: char_code_4 = 7'h39;
    default: char_code_4 = 7'h00;
    endcase
    
end

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
        16'h1200: char_code = char_code_3;
        16'h1300: char_code = char_code_2;
        16'h1400: char_code = 7'h3a; //:
        16'h1500: char_code = char_code_1;
        16'h1600: char_code = char_code_0;
        default: char_code = 0;
    endcase   
end                       
                          
endmodule                 
                          