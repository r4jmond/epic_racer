`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2020 14:40:48
// Design Name: 
// Module Name: epic_racer
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


module epic_racer (
    input wire clk,
    input wire rst,
    output wire hs,
    output wire vs,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b,
    output wire pclk_mirror
);

wire clk100M, clk65M, gnd;

clk_wiz_0 my_clk(
    .clk(clk),
    .clk_100M(clk100M),
    .clk_65M(clk65M),
    .reset(gnd)
);

  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(clk65M),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );
 
wire [10:0] vcount, hcount, vcount2, hcount2;
wire vsync, vblnk, hsync, hblnk, vsync2, vblnk2, hsync2, hblnk2;

xga_timing my_timing (
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk),
    .pclk(clk65M),
    .rst(rst)
);

wire [11:0] intro_data;
wire [15:0] intro_adress;
wire [11:0] rgb;
wire [10:0] xpos, ypos;

draw_img #(1024, 768) draw_background(
    .vcount_in(vcount),
    .hcount_in(hcount),
    .vsync_in(vsync),
    .hsync_in(hsync),
    .vblnk_in(vblnk),
    .hblnk_in(hblnk),
    .pclk(clk65M),
    .rst(rst),
    .xpos(xpos),
    .ypos(ypos),
    .rgb_pixel(intro_data),
    .pixel_addr(intro_adress),
    .rgb_out({r, g, b}),
    //.hcount_out(hcount2),
    //.vcount_out(vcount2),
    //.vblnk_out(vblnk2),
    //.hblnk_out(hblnk2),
    .vsync_out(vs),
    .hsync_out(hs)
);

image_rom #(128, 128, "./images/tile.data") image_intro(
    .clk(clk65M),
    .address(intro_adress),
    .rgb_out(intro_data)
);
/*
draw_img #(128, 0) draw_intro_2(
    .vcount_in(vcount2),
    .hcount_in(hcount2),
    .vsync_in(vsync2),
    .hsync_in(hsync2),
    .vblnk_in(vblnk2),
    .hblnk_in(hblnk2),
    .pclk(clk65M),
    .rst(rst),
    .rgb_in(rgb),
    .rgb_in(intro_2_data),
    .pixel_addr(intro_2_adress),
    .rgb_out({r, g, b}),
    .vsync_out(vs),
    .hsync_out(hs)
);
*/
endmodule
