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

wire clk100M, clk65M, clk50M, clk1, gnd;

clk_wiz_0 my_clk(
    .clk(clk),
    .clk_100M(clk100M),
    .clk_65M(clk65M),
    .clk_50M(clk50M),
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
 
wire [10:0] vcount, hcount, vcount2, hcount2, vcount3, hcount3;
wire vsync, vblnk, hsync, hblnk, vsync2, vblnk2, hsync2, hblnk2, vsync3, vblnk3, hsync3, hblnk3;
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

wire [11:0] bg_data, track_data, car_data;
wire [13:0] bg_adress;
wire [15:0] track_adress;
wire [11:0] car_adress;
wire [11:0] rgb_bt, rgb_tc;
wire [10:0] xpos, ypos;
wire bg_visible, track_visible, player_visible;

main_fsm epic_racer_fsm (
    .pclk(clk65M),
    .rst(rst),
    .bg_visible(bg_visible),
    .track_visible(track_visible),
    .player_visible(player_visible)
);

draw_img #(1024, 768, 14) draw_background(
    .vcount_in(vcount),
    .hcount_in(hcount),
    .vsync_in(vsync),
    .hsync_in(hsync),
    .vblnk_in(vblnk),
    .hblnk_in(hblnk),
    .pclk(clk65M),
    .rst(rst),
    .visible(bg_visible),
    .rgb_pixel(bg_data),
    .pixel_addr(bg_adress),
    .rgb_out(rgb_bt),
    .hcount_out(hcount2),
    .vcount_out(vcount2),
    .vblnk_out(vblnk2),
    .hblnk_out(hblnk2),
    .vsync_out(vsync2),
    .hsync_out(hsync2)
);

image_rom #(128, 128, 14, "./images/tile.data") background_tile(
    .clk(clk65M),
    .address(bg_adress),
    .rgb_out(bg_data)
);


draw_tiles #(16, 16, 16) draw_track(
    .vcount_in(vcount2),
    .hcount_in(hcount2),
    .vsync_in(vsync2),
    .hsync_in(hsync2),
    .vblnk_in(vblnk2),
    .hblnk_in(hblnk2),
    .pclk(clk65M),
    .rst(rst),
    .visible(track_visible),
    .rgb_in(rgb_bt),
    .rgb_pixel(track_data),
    .pixel_addr(track_adress),
    .rgb_out(rgb_tc),
    .hcount_out(hcount3),
    .vcount_out(vcount3),
    .vblnk_out(vblnk3),
    .hblnk_out(hblnk3),
    .vsync_out(vsync3),
    .hsync_out(hsync3)
);

image_rom #(256, 240, 16, "./images/track2.data") track_tiles(
    .clk(clk65M),
    .address(track_adress),
    .rgb_out(track_data)
);

wire [1:0] car_rotation;

draw_img #(64, 64, 12) draw_car(
    .vcount_in(vcount3),
    .hcount_in(hcount3),
    .vsync_in(vsync3),
    .hsync_in(hsync3),
    .vblnk_in(vblnk3),
    .hblnk_in(hblnk3),
    .pclk(clk65M),
    .rst(rst),
    .xpos(xpos),
    .ypos(ypos),
    .visible(player_visible),
    .rgb_in(rgb_tc),
    .rgb_pixel(car_data),
    .pixel_addr(car_adress),
    .rgb_out({r, g, b}),
    .vsync_out(vs),
    .hsync_out(hs),
    .rotation(car_rotation)
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
    .clk(clk50M),
    .I(btnU),
    .O(btnU_D)
);

wire [15:0] keycode;

car_ctl my_car_ctl(
    .pclk(clk65M),
    .rst(rst),
   // .key({ btnR_D, btnL_D, btnD_D, btnU_D }),
    .key(keycode),
    .xpos(xpos),
    .ypos(ypos),
    .move_dir(car_rotation)
);


keyboard my_keyboard(
    .clk(clk50M),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .rst(rst),
    .key(keycode)
);

/*


bufor my_bufor(
    .clk50M(clk50M),
    .rst(rst),
    .clk1(clk1)
    );
  */  
image_rom #(64, 64, 12, "./images/car.data") car_rom(
    .clk(clk65M),
    .address(car_adress),
    .rgb_out(car_data)
);

endmodule
