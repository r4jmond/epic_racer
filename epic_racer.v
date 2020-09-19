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
//    .clk_100M(clk100M),
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
    .rst(rst)
);

wire title_screen_visible, car_select_visible, control_select_visible;
wire game_visible, arrow_visible, control;
wire [3:0] car;
wire [21:0] eco_car_pos, force_car_pos, nitro_car_pos, rapid_car_pos;
wire [10:0] arrow_xpos, arrow_ypos;

main_fsm epic_racer_fsm (
    .pclk(clk65M),
    .rst(rst),
    .btnR(btnR_D),
    .btnU(btnU_D),
    .btnD(btnD_D),
    .btnL(btnL_D),
    .title_screen_visible(title_screen_visible),
    .car_select_visible(car_select_visible),
    .control_select_visible(control_select_visible),
    .game_visible(game_visible),
    .arrow_visible(arrow_visible),
    .control(control),
    .eco_car_pos(eco_car_pos),
    .force_car_pos(force_car_pos),
    .nitro_car_pos(nitro_car_pos),
    .rapid_car_pos(rapid_car_pos),
    .arrow_xpos(arrow_xpos),
    .arrow_ypos(arrow_ypos)
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
    .rgb_in(0),
    .pclk(clk65M),
    .rst(rst),
    .title_screen_visible(title_screen_visible),
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
    .visible(game_visible),
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
wire [10:0] vcount_crc, hcount_crc;           
wire vsync_crc, vblnk_crc, hsync_crc, hblnk_crc;
wire [11:0] rgb_crc;
wire [11:0] car_data;
wire [11:0] car_adress;
wire [10:0] car_xpos, car_ypos;
wire [10:0] car_x_start, car_x_end, car_y_start, car_y_end;

wire lap_finished, checkpoints_passed;

car_ctl my_car_ctl(
    .pclk(clk65M),
    .rst(rst),
    .key({ btnR_D, btnL_D, btnD_D, btnU_D }),
    .xpos(car_xpos),
    .ypos(car_ypos),
    .move_dir(car_rotation),
    .car_x_start(car_x_start),
    .car_x_end(car_x_end),
    .car_y_start(car_y_start),
    .car_y_end(car_y_end)
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
    .xpos(car_xpos),
    .ypos(car_ypos),
    .visible(game_visible),
    .rgb_in(rgb_tc),
    .rgb_pixel(car_data),
    .pixel_addr(car_adress),
    .rgb_out(rgb_crc),
    .vcount_out(vcount_crc),
    .hcount_out(hcount_crc),
    .vsync_out(vsync_crc),
    .hsync_out(hsync_crc),
    .vblnk_out(vblnk_crc),
    .hblnk_out(hblnk_crc),
    .rotation(car_rotation)
);

image_rom #(64, 64, 12, "./images/car_nitro.data") car_nitro_rom(
    .clk(clk65M),
    .address(car_adress),
    .rgb_out(car_data)
);


wire [15:0] current_lap_time, last_lap_time, best_lap_time;
wire max_lap_time_exceeded;

checkpoints my_checkpoints(
    .pclk(clk65M),
    .rst(rst),
    .car_x_start(car_x_start),
    .car_x_end(car_x_end),
    .car_y_start(car_y_start),
    .car_y_end(car_y_end),
    .lap_finished(lap_finished),
    .checkpoints_passed(checkpoints_passed)
);

lap_timer my_lap_timer(
    .pclk(clk65M),
    .rst(rst),
    .start(game_visible),
    .stop(0),
    .lap_finished(lap_finished),
    .checkpoints_passed(checkpoints_passed),
    .max_time_exceeded(max_lap_time_exceeded),
    .current_lap_time(current_lap_time),
    .last_lap_time(last_lap_time),
    .best_lap_time(best_lap_time)
);

wire [10:0] current_lap_time_char_addr;
wire [7:0] current_lap_time_char_pixels;
wire [15:0] current_lap_time_char_xy;

wire [10:0] vcount_rcrl, hcount_rcrl;           
wire vsync_rcrl, vblnk_rcrl, hsync_rcrl, hblnk_rcrl;
wire [11:0] rgb_rcrl;

draw_rect_char #(144, 32, 23, 1, 12'h333) draw_current_lap_time (
    .hcount_in(hcount_crc),
    .hsync_in(hsync_crc),
    .hblnk_in(hblnk_crc),
    .vcount_in(vcount_crc),
    .vsync_in(vsync_crc),
    .vblnk_in(vblnk_crc),
    .rgb_in(rgb_crc),
    .char_pixels(current_lap_time_char_pixels),
    .pclk(clk65M),
    .rst(rst),
    .visible(game_visible),
    //.hsync_out(hs),
    .hsync_out(hsync_rcrl),
    .hcount_out(hcount_rcrl),
    .hblnk_out(hblnk_rcrl),
    .vcount_out(vcount_rcrl),
    .vsync_out(vsync_rcrl),
    //.vsync_out(vs),
    .vblnk_out(vblnk_rcrl),
    .rgb_out(rgb_rcrl),
    //.rgb_out({r, g, b}),
    .char_xy(current_lap_time_char_xy),
    .char_line(current_lap_time_char_addr[3:0])
);

current_lap_time_char_rom current_lap_time_char_rom(
    .char_xy(current_lap_time_char_xy),
    .current_lap_time(current_lap_time),
    .char_code(current_lap_time_char_addr[10:4])
);

font_rom current_lap_time_font_rom (
    .clk(clk65M),
    .addr(current_lap_time_char_addr),
    .char_line_pixels(current_lap_time_char_pixels)
);

wire [10:0] last_lap_time_char_addr;
wire [7:0] last_lap_time_char_pixels;
wire [15:0] last_lap_time_char_xy;

wire [10:0] vcount_rlrb, hcount_rlrb;
wire vsync_rlrb, vblnk_rlrb, hsync_rlrb, hblnk_rlrb;
wire [11:0] rgb_rlrb;

draw_rect_char #(416, 32, 20, 1, 12'h333) draw_last_lap_time (
    .hcount_in(hcount_rcrl),
    .vcount_in(vcount_rcrl),
    .hsync_in(hsync_rcrl),
    .hblnk_in(hblnk_rcrl),
    .vsync_in(vsync_rcrl),
    .vblnk_in(vblnk_rcrl),
    .rgb_in(rgb_rcrl),
    .char_pixels(last_lap_time_char_pixels),
    .pclk(clk65M),
    .rst(rst),
    .visible(game_visible),
    .hcount_out(hcount_rlrb),
    .vcount_out(vcount_rlrb),
    .hsync_out(hsync_rlrb),
    .vsync_out(vsync_rlrb),
    .hblnk_out(hblnk_rlrb),
    .vblnk_out(vblnk_rlrb),
    .rgb_out(rgb_rlrb),
    .char_xy(last_lap_time_char_xy),
    .char_line(last_lap_time_char_addr[3:0])
);

last_lap_time_char_rom last_lap_time_char_rom(
    .char_xy(last_lap_time_char_xy),
    .last_lap_time(last_lap_time),
    .char_code(last_lap_time_char_addr[10:4])
);

font_rom last_lap_time_font_rom (
    .clk(clk65M),
    .addr(last_lap_time_char_addr),
    .char_line_pixels(last_lap_time_char_pixels)
);

wire [10:0] best_lap_time_char_addr;
wire [7:0] best_lap_time_char_pixels;
wire [15:0] best_lap_time_char_xy;

draw_rect_char #(664, 32, 20, 1, 12'h333) draw_best_lap_time (
    .hcount_in(hcount_rlrb),
    .vcount_in(vcount_rlrb),
    .hsync_in(hsync_rlrb),
    .hblnk_in(hblnk_rlrb),
    .vsync_in(vsync_rlrb),
    .vblnk_in(vblnk_rlrb),
    .rgb_in(rgb_rlrb),
    .char_pixels(best_lap_time_char_pixels),
    .pclk(clk65M),
    .rst(rst),
    .visible(game_visible),
    /*.hcount_out(hcount_rlrb),
    .vcount_out(vcount_rlrb),
    .hsync_out(hsync_rlrb),
    .vsync_out(vsync_rlrb),
    .hblnk_out(hblnk_rlrb),
    .vblnk_out(vblnk_rlrb),
    .rgb_out(rgb_rlrb),*/
    .rgb_out({r, g, b}),
    .vsync_out(vs),
    .hsync_out(hs),
    .char_xy(best_lap_time_char_xy),
    .char_line(best_lap_time_char_addr[3:0])
);

best_lap_time_char_rom best_lap_time_char_rom(
    .char_xy(best_lap_time_char_xy),
    .best_lap_time(best_lap_time),
    .char_code(best_lap_time_char_addr[10:4])
);

font_rom best_lap_time_font_rom (
    .clk(clk65M),
    .addr(best_lap_time_char_addr),
    .char_line_pixels(best_lap_time_char_pixels)
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
