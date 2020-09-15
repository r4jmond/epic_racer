`timescale 1ns / 1ps

module epic_racer (
    input wire clk,
    input wire rst,
    output wire hs,
    output wire vs,
    input wire btnR,
    input wire btnL,
    input wire btnD,
    input wire btnU,
    inout wire ps2_clk,
    inout wire ps2_data,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b,
    output wire pclk_mirror
);

wire clk100M, clk65M, gnd;

clk_wiz_0 my_clk(
    .clk(clk),
    .clk_100M(clk100M),
    .clk_65M(clk65M)
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

wire btnR_D, btnL_D, btnD_D, btnU_D;

debouncer btnR_debouncer(
    .clk(clk65M),
    .I(btnR),
    .O(btnR_D)
);
debouncer btnL_debouncer(
    .clk(clk65M),
    .I(btnL),
    .O(btnL_D)
);
debouncer btnD_debouncer(
    .clk(clk65M),
    .I(btnD),
    .O(btnD_D)
);
debouncer btnU_debouncer(
    .clk(clk65M),
    .I(btnU),
    .O(btnU_D)
);
 
wire [10:0] vcount, hcount;
wire vsync, vblnk, hsync, hblnk;
wire frame_ended;

xga_timing my_timing (
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk),
    .pclk(clk65M),
    .rst(rst),
    .frame_ended(frame_ended)
);

wire [10:0] xpos, ypos;
wire splash_visible, car_select_visible, control_select_visible;
wire track_visible, player_visible;

main_fsm epic_racer_fsm (
    .pclk(clk65M),
    .rst(rst),
    .splash_visible(splash_visible),
    .car_select_visible(car_select_visible),
    .control_select_visible(control_select_visible),
    .track_visible(track_visible),
    .player_visible(player_visible)
);

wire [10:0] vcount_mt, hcount_mt;
wire vsync_mt, vblnk_mt, hsync_mt, hblnk_mt;
wire [11:0] rgb_mt;
wire [11:0] menu_data;
wire [15:0] menu_adress;

draw_menu #(16, 16, 16) draw_menu(
    .vcount_in(vcount),
    .hcount_in(hcount),
    .vsync_in(vsync),
    .hsync_in(hsync),
    .vblnk_in(vblnk),
    .hblnk_in(hblnk),
    .pclk(clk65M),
    .rst(rst),
    .splash_visible(splash_visible),
    .car_select_visible(car_select_visible),
    .control_select_visible(control_select_visible),
    .rgb_pixel(menu_data),
    .pixel_addr(menu_adress),
    .rgb_out(rgb_mt),
    .hcount_out(hcount_mt),
    .vcount_out(vcount_mt),
    .vblnk_out(vblnk_mt),
    .hblnk_out(hblnk_mt),
    .vsync_out(vsync_mt),
    .hsync_out(hsync_mt)
);

image_rom #(192, 160, 16, "./images/menu_tiles.data") menu_tiles(
    .clk(clk65M),
    .address(menu_adress),
    .rgb_out(menu_data)
);

wire [10:0] vcount_tc, hcount_tc;
wire vsync_tc, vblnk_tc, hsync_tc, hblnk_tc;
wire [11:0] rgb_tc;
wire [11:0] track_data;
wire [15:0] track_adress;

draw_track #(16, 16, 16) draw_track(
    .vcount_in(vcount_mt),
    .hcount_in(hcount_mt),
    .vsync_in(vsync_mt),
    .hsync_in(hsync_mt),
    .vblnk_in(vblnk_mt),
    .hblnk_in(hblnk_mt),
    .pclk(clk65M),
    .rst(rst),
    .visible(track_visible),
    .rgb_in(rgb_mt),
    .rgb_pixel(track_data),
    .pixel_addr(track_adress),
    .rgb_out(rgb_tc),
    .hcount_out(hcount_tc),
    .vcount_out(vcount_tc),
    .vblnk_out(vblnk_tc),
    .hblnk_out(hblnk_tc),
    .vsync_out(vsync_tc),
    .hsync_out(hsync_tc)
);

image_rom #(256, 240, 16, "./images/track.data") track_tiles(
    .clk(clk65M),
    .address(track_adress),
    .rgb_out(track_data)
);

wire [1:0] car_rotation;
wire [10:0] vcount_cr, hcount_cr;           
wire vsync_cr, vblnk_cr, hsync_cr, hblnk_cr;
wire [11:0] rgb_cr;
wire [11:0] car_data;
wire [11:0] car_adress;

car_ctl my_car_ctl(
    .pclk(clk65M),
    .rst(rst),
    .key({ btnR_D, btnL_D, btnD_D, btnU_D }),
    .xpos(xpos),
    .ypos(ypos),
    .move_dir(car_rotation)
);

draw_img #(64, 64, 12) draw_car_nitro(
    .vcount_in(vcount_tc),
    .hcount_in(hcount_tc),
    .vsync_in(vsync_tc),
    .hsync_in(hsync_tc),
    .vblnk_in(vblnk_tc),
    .hblnk_in(hblnk_tc),
    .pclk(clk65M),
    .rst(rst),
    .xpos(xpos),
    .ypos(ypos),
    .visible(player_visible),
    .rgb_in(rgb_tc),
    .rgb_pixel(car_data),
    .pixel_addr(car_adress),
    .rgb_out(rgb_cr),
    .vcount_out(vcount_cr),
    .hcount_out(hcount_cr),
    .vsync_out(vsync_cr),
    .hsync_out(hsync_cr),
    .vblnk_out(vblnk_cr),
    .hblnk_out(hblnk_cr),
    .rotation(car_rotation)
);

image_rom #(64, 64, 12, "./images/car_nitro.data") car_nitro_rom(
    .clk(clk65M),
    .address(car_adress),
    .rgb_out(car_data)
);

wire [10:0] current_lap_time_char_addr;
wire [7:0] current_lap_time_char_pixels;
wire [15:0] current_lap_time_char_xy;

draw_rect_char #(128, 32, 28, 1, 12'h333) draw_current_lap_time (
    .hcount_in(hcount_cr),
    .hsync_in(hsync_cr),
    .hblnk_in(hblnk_cr),
    .vcount_in(vcount_cr),
    .vsync_in(vsync_cr),
    .vblnk_in(vblnk_cr),
    .rgb_in(rgb_cr),
    .char_pixels(current_lap_time_char_pixels),
    .pclk(clk65M),
    .rst(rst),
    //.hsync_out(hsync2),
   // .hcount_out(hcount2),
    //.hblnk_out(hblnk2),
    //.vcount_out(vcount2),
    //.vsync_out(vsync2),
   // .vblnk_out(vblnk2),
    .rgb_out({r, g, b}),
    .vsync_out(vs),
    .hsync_out(hs),
    .char_xy(current_lap_time_char_xy),
    .char_line(current_lap_time_char_addr[3:0])
);

current_lap_time_char_rom my_current_lap_time_char_rom(
    .char_xy(current_lap_time_char_xy),
    .char_code(current_lap_time_char_addr[10:4])
);

font_rom current_lap_time_font_rom (
    .clk(clk65M),
    .addr(current_lap_time_char_addr),
    .char_line_pixels(current_lap_time_char_pixels)
);

/*
keyboard my_keyboard(
    .clk(clk100M),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .rst(rst),
    .key(keyboard_key)
);*/

endmodule
