`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2020 14:32:16
// Design Name: 
// Module Name: draw_background
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


module draw_background(
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire pclk,
    input wire rst,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
    );
    
localparam BACKGROUND_COLOR = 12'h1_1_0; //hd0 for yellow
localparam RECT_COLOR = 12'hf45; //666 for gray

reg [11:0] rgb_out_nxt;

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
    hcount_out <= hcount_in;
    hsync_out <= hsync_in;
    hblnk_out <= hblnk_in;
    vcount_out <= vcount_in;
    vsync_out <= vsync_in;
    vblnk_out <= vblnk_in;
    rgb_out <= rgb_out_nxt;
end

always @*
begin
    // During blanking, make it it black.
    if (vblnk_in || hblnk_in) rgb_out_nxt = 12'h0_0_0;
    else
    begin
        // Active display, top edge, make a yellow line.
        if (vcount_in == 0) rgb_out_nxt = 12'hf_f_0;
        // Active display, bottom edge, make a red line.
        else if (vcount_in == 599) rgb_out_nxt = 12'hf_0_0;
        // Active display, left edge, make a green line.
        else if (hcount_in == 1) rgb_out_nxt = 12'h0_f_0;
        // Active display, right edge, make a blue line.
        else if (hcount_in == 799) rgb_out_nxt = 12'h0_0_f;

        else if (hcount_in > 190 && hcount_in < 220 && vcount_in > 145 && vcount_in < 459) rgb_out_nxt = RECT_COLOR; //bok-l
        else if (hcount_in > 155 && hcount_in < 362 && vcount_in > 419 && vcount_in < 459) rgb_out_nxt = RECT_COLOR; //dó³
        else if (hcount_in > 155 && hcount_in < 362 && vcount_in > 145 && vcount_in < 185) rgb_out_nxt = RECT_COLOR; //góra
        else if (hcount_in > 322 && hcount_in < 362 && vcount_in > 145 && vcount_in < 459) rgb_out_nxt = RECT_COLOR;//bok-p
                                                                                                         
        else if (hcount_in > 460 && hcount_in < 610 && vcount_in > 175 && vcount_in < 210) rgb_out_nxt = RECT_COLOR; //góra
        else if (hcount_in > 570 && hcount_in < 610 && vcount_in > 175 && vcount_in < 429) rgb_out_nxt = RECT_COLOR; //bok
        else if (hcount_in > 450 && hcount_in < 490 && vcount_in > 175 && vcount_in < 429) rgb_out_nxt = RECT_COLOR; //lewy bok - dla 9 vcount<295
        else if (hcount_in > 460 && hcount_in < 610 && vcount_in > 389 && vcount_in < 429) rgb_out_nxt = RECT_COLOR; //dolna -
        else rgb_out_nxt = BACKGROUND_COLOR;
    end
end
endmodule
