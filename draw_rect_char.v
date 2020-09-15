`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2020 12:36:06
// Design Name: 
// Module Name: draw_rect_char
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



module draw_rect_char(
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [7:0] char_pixels,
    input wire pclk,
    input wire rst,
    input wire [11:0] rgb_in,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output wire [15:0] char_xy,
    output wire [3:0] char_line
);
    
parameter XPOS = 15;
parameter YPOS = 170;
parameter X_LETTERS = 16;
parameter Y_LETTERS = 16;

localparam RECT_WIDTH = 8 * X_LETTERS;
localparam RECT_LENGTH = 16 * Y_LETTERS;

parameter FONT_COLOR = 12'h000;

reg [11:0] rgb_out_nxt;
wire [10:0] vcount_delayed, hcount_delayed;
wire hsync_delayed, vsync_delayed, hblnk_delayed, vblnk_delayed;

always @(posedge pclk)
if(rst)
begin
    hcount_out <= 0;
    hsync_out <= 0;
    hblnk_out <= 0;
    vcount_out <= 0;
    vsync_out <= 0;
    vblnk_out <= 0;
    rgb_out <= 0;
end
else
begin
    hcount_out <= hcount_delayed;
    hsync_out <= hsync_delayed;
    hblnk_out <= hblnk_delayed;
    vcount_out <= vcount_delayed;
    vsync_out <= vsync_delayed;
    vblnk_out <= vblnk_delayed;
    rgb_out <= rgb_out_nxt;
end

always @*
begin
    if(hcount_in > XPOS && hcount_in <= (XPOS + RECT_WIDTH) && vcount_in > YPOS && vcount_in <= (YPOS + RECT_LENGTH))
    begin
        if(char_pixels[8 - ((hcount_in - XPOS) & 3'b111)])
            rgb_out_nxt = FONT_COLOR;
        else
            rgb_out_nxt = rgb_in;
    end
    else rgb_out_nxt = rgb_in;
end

assign char_xy[7:0] = ((vcount_in - YPOS) >> 4'h4);
assign char_xy[15:8] = ((hcount_in - XPOS) >> 4'h3);
assign char_line = (vcount_in - YPOS);

delay #(11, 2) hcount_delay(
    .clk(pclk),
    .rst(rst),
    .din(hcount_in),
    .dout(hcount_delayed)
);

delay #(11, 2) vcount_delay(
    .clk(pclk),
    .rst(rst),
    .din(vcount_in),
    .dout(vcount_delayed)
);

delay #(1,2) vsync_delay(
    .clk(pclk),
    .rst(rst),
    .din(vsync_in),
    .dout(vsync_delayed)
);

delay #(1,2) hsync_delay(
    .clk(pclk),
    .rst(rst),
    .din(hsync_in),
    .dout(hsync_delayed)
);

delay #(1,2) vblnk_delay(
    .clk(pclk),
    .rst(rst),
    .din(vblnk_in),
    .dout(vblnk_delayed)
);

delay #(1,2) hblnk_delay(
    .clk(pclk),
    .rst(rst),
    .din(hblnk_in),
    .dout(hblnk_delayed)
);
endmodule
