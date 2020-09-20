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
    input wire ps2_clk,
    input wire ps2_data,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b
);

wire clk65M;

clk_wiz_0 my_clk(
    .clk(clk),
    .clk_65M(clk65M)
);

wire btnR_D, btnL_D, btnD_D, btnU_D;

buttons_debouncer my_buttons_debouncer(
    .clk(clk65M),
    .btnR(btnR),
    .btnL(btnL),
    .btnU(btnU),
    .btnD(btnD),
    .btnR_D(btnR_D),
    .btnL_D(btnL_D),
    .btnU_D(btnU_D),
    .btnD_D(btnD_D)
);

wire [5:0] keyboard_key;
wire [7:0] keyboard_signal;

keyboard my_keyboard(
    .clk(clk65M),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .rst(rst),
    .key(keyboard_key),
    .keyboard_signal(keyboard_signal)
);
 
wire [10:0] vcount, hcount;
wire vsync, vblnk, hsync, hblnk;

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
wire game_visible, arrow_visible;
wire too_slow_visible, cheater_visible;
wire [3:0] car_control;
wire [1:0] car_visible;
wire [10:0] nitro_avatar_xpos, nitro_avatar_ypos, rapid_avatar_xpos, rapid_avatar_ypos;
wire [10:0] arrow_xpos, arrow_ypos;
wire lap_finished, checkpoints_passed;
wire max_lap_time_exceeded;

main_fsm epic_racer_fsm (
    .pclk(clk65M),
    .rst(rst),
    .btnR(btnR_D),
    .btnU(btnU_D),
    .btnD(btnD_D),
    .btnL(btnL_D),
    .key(keyboard_key),
    .keycode(keyboard_signal),
    .title_screen_visible(title_screen_visible),
    .car_select_visible(car_select_visible),
    .control_select_visible(control_select_visible),
    .max_lap_time_exceeded(max_lap_time_exceeded),
    .lap_finished(lap_finished),
    .checkpoints_passed(checkpoints_passed),
    .game_visible(game_visible),
    .car_visible(car_visible),
    .arrow_visible(arrow_visible),
    .too_slow_visible(too_slow_visible),
    .cheater_visible(cheater_visible),
    .controls(car_control),
    .nitro_avatar_xpos(nitro_avatar_xpos),
    .nitro_avatar_ypos(nitro_avatar_ypos),
    .rapid_avatar_xpos(rapid_avatar_xpos),
    .rapid_avatar_ypos(rapid_avatar_ypos),
    .arrow_xpos(arrow_xpos),
    .arrow_ypos(arrow_ypos)
);

wire [11:0] menu_data;
wire [15:0] menu_adress;

wire [10:0] vcount_mna, hcount_mna;
wire vsync_mna, vblnk_mna, hsync_mna, hblnk_mna;
wire [11:0] rgb_mna;

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
    .rgb_out(rgb_mna),
    .hcount_out(hcount_mna),
    .vcount_out(vcount_mna),
    .vblnk_out(vblnk_mna),
    .hblnk_out(hblnk_mna),
    .vsync_out(vsync_mna),
    .hsync_out(hsync_mna)
);

image_rom #(192, 160, 16, "./images/menu_tiles.data") menu_tiles(
    .clk(clk65M),
    .address(menu_adress),
    .rgb_out(menu_data)
);

wire [11:0] avatar_nitro_data;
wire [11:0] avatar_nitro_address;

wire [10:0] vcount_anar, hcount_anar;           
wire vsync_anar, vblnk_anar, hsync_anar, hblnk_anar;
wire [11:0] rgb_anar;

draw_img #(64, 43, 12) draw_avatar_nitro(
    .vcount_in(vcount_mna),
    .hcount_in(hcount_mna),
    .vsync_in(vsync_mna),
    .hsync_in(hsync_mna),
    .vblnk_in(vblnk_mna),
    .hblnk_in(hblnk_mna),
    .pclk(clk65M),
    .rst(rst),
    .xpos(nitro_avatar_xpos),
    .ypos(nitro_avatar_ypos),
    .visible(car_select_visible),
    .rotation(0),
    .rgb_in(rgb_mna),
    .rgb_pixel(avatar_nitro_data),
    .pixel_addr(avatar_nitro_address),
    .rgb_out(rgb_anar),
    .vcount_out(vcount_anar),
    .hcount_out(hcount_anar),
    .vsync_out(vsync_anar),
    .hsync_out(hsync_anar),
    .vblnk_out(vblnk_anar),
    .hblnk_out(hblnk_anar)
);

image_rom #(64, 43, 12, "./images/nitro_avatar.data") avatar_nitro_rom(
    .clk(clk65M),
    .address(avatar_nitro_address),
    .rgb_out(avatar_nitro_data)
);

wire [11:0] avatar_rapid_data;
wire [11:0] avatar_rapid_address;

wire [10:0] vcount_ara, hcount_ara;           
wire vsync_ara, vblnk_ara, hsync_ara, hblnk_ara;
wire [11:0] rgb_ara;

draw_img #(64, 43, 12) draw_avatar_rapid(
    .vcount_in(vcount_anar),
    .hcount_in(hcount_anar),
    .vsync_in(vsync_anar),
    .hsync_in(hsync_anar),
    .vblnk_in(vblnk_anar),
    .hblnk_in(hblnk_anar),
    .pclk(clk65M),
    .rst(rst),
    .xpos(rapid_avatar_xpos),
    .ypos(rapid_avatar_ypos),
    .visible(car_select_visible),
    .rotation(0),
    .rgb_in(rgb_anar),
    .rgb_pixel(avatar_rapid_data),
    .pixel_addr(avatar_rapid_address),
    .rgb_out(rgb_ara),
    .vcount_out(vcount_ara),
    .hcount_out(hcount_ara),
    .vsync_out(vsync_ara),
    .hsync_out(hsync_ara),
    .vblnk_out(vblnk_ara),
    .hblnk_out(hblnk_ara)
);

image_rom #(64, 43, 12, "./images/rapid_avatar.data") avatar_rapid_rom(
    .clk(clk65M),
    .address(avatar_rapid_address),
    .rgb_out(avatar_rapid_data)
);

wire [11:0] arrow_data;
wire [11:0] arrow_address;

wire [10:0] vcount_at, hcount_at;
wire vsync_at, vblnk_at, hsync_at, hblnk_at;
wire [11:0] rgb_at;

draw_img #(45, 62, 12) draw_arrow(
    .vcount_in(vcount_ara),
    .hcount_in(hcount_ara),
    .vsync_in(vsync_ara),
    .hsync_in(hsync_ara),
    .vblnk_in(vblnk_ara),
    .hblnk_in(hblnk_ara),
    .pclk(clk65M),
    .rst(rst),
    .xpos(arrow_xpos),
    .ypos(arrow_ypos),
    .visible(arrow_visible),
    .rotation(0),
    .rgb_in(rgb_ara),
    .rgb_pixel(arrow_data),
    .pixel_addr(arrow_address),
    .rgb_out(rgb_at),
    .vcount_out(vcount_at),
    .hcount_out(hcount_at),
    .vsync_out(vsync_at),
    .hsync_out(hsync_at),
    .vblnk_out(vblnk_at),
    .hblnk_out(hblnk_at)
);

image_rom #(45, 62, 12, "./images/arrow.data") arrow_rom(
    .clk(clk65M),
    .address(arrow_address),
    .rgb_out(arrow_data)
);

wire [10:0] vcount_tcn, hcount_tcn;
wire vsync_tcn, vblnk_tcn, hsync_tcn, hblnk_tcn;
wire [11:0] rgb_tcn;
wire [11:0] track_data;
wire [15:0] track_adress;

draw_track #(16, 16, 16) draw_track(
    .vcount_in(vcount_at),
    .hcount_in(hcount_at),
    .vsync_in(vsync_at),
    .hsync_in(hsync_at),
    .vblnk_in(vblnk_at),
    .hblnk_in(hblnk_at),
    .pclk(clk65M),
    .rst(rst),
    .visible(game_visible),
    .rgb_in(rgb_at),
    .rgb_pixel(track_data),
    .pixel_addr(track_adress),
    .rgb_out(rgb_tcn),
    .hcount_out(hcount_tcn),
    .vcount_out(vcount_tcn),
    .vblnk_out(vblnk_tcn),
    .hblnk_out(hblnk_tcn),
    .vsync_out(vsync_tcn),
    .hsync_out(hsync_tcn)
);

image_rom #(256, 240, 16, "./images/track.data") track_tiles(
    .clk(clk65M),
    .address(track_adress),
    .rgb_out(track_data)
);

wire [1:0] car_rotation;

wire [10:0] vcount_cfcr, hcount_cfcr;           
wire vsync_cfcr, vblnk_cfcr, hsync_cfcr, hblnk_cfcr;
wire [11:0] rgb_cfcr;

wire [11:0] nitro_car_data, rapid_car_data;
wire [11:0] nitro_car_address, rapid_car_address;
wire [10:0] car_xpos, car_ypos;
wire [10:0] car_x_start, car_x_end, car_y_start, car_y_end;

car_ctl my_car_ctl(
    .pclk(clk65M),
    .rst(rst),
    .key(car_control),
    .xpos(car_xpos),
    .ypos(car_ypos),
    .move_dir(car_rotation),
    .car_x_start(car_x_start),
    .car_x_end(car_x_end),
    .car_y_start(car_y_start),
    .car_y_end(car_y_end)
);

wire [10:0] vcount_cncr, hcount_cncr;           
wire vsync_cncr, vblnk_cncr, hsync_cncr, hblnk_cncr;
wire [11:0] rgb_cncr;

draw_img #(64, 64, 12) draw_car_nitro(
    .vcount_in(vcount_tcn),
    .hcount_in(hcount_tcn),
    .vsync_in(vsync_tcn),
    .hsync_in(hsync_tcn),
    .vblnk_in(vblnk_tcn),
    .hblnk_in(hblnk_tcn),
    .pclk(clk65M),
    .rst(rst),
    .xpos(car_xpos),
    .ypos(car_ypos),
    .visible(car_visible[0] && game_visible),
    .rotation(car_rotation),
    .rgb_in(rgb_tcn),
    .rgb_pixel(nitro_car_data),
    .pixel_addr(nitro_car_address),
    .rgb_out(rgb_cncr),
    .vcount_out(vcount_cncr),
    .hcount_out(hcount_cncr),
    .vsync_out(vsync_cncr),
    .hsync_out(hsync_cncr),
    .vblnk_out(vblnk_cncr),
    .hblnk_out(hblnk_cncr)
);

image_rom #(64, 64, 12, "./images/nitro.data") car_nitro_rom(
    .clk(clk65M),
    .address(nitro_car_address),
    .rgb_out(nitro_car_data)
);

wire [10:0] vcount_crrc, hcount_crrc;           
wire vsync_crrc, vblnk_crrc, hsync_crrc, hblnk_crrc;
wire [11:0] rgb_crrc;

draw_img #(64, 64, 12) draw_car_rapid(
    .vcount_in(vcount_cncr),
    .hcount_in(hcount_cncr),
    .vsync_in(vsync_cncr),
    .hsync_in(hsync_cncr),
    .vblnk_in(vblnk_cncr),
    .hblnk_in(hblnk_cncr),
    .pclk(clk65M),
    .rst(rst),
    .xpos(car_xpos),
    .ypos(car_ypos),
    .visible(car_visible[1] && game_visible),
    .rotation(car_rotation),
    .rgb_in(rgb_cncr),
    .rgb_pixel(rapid_car_data),
    .pixel_addr(rapid_car_address),
    .rgb_out(rgb_crrc),
    .vcount_out(vcount_crrc),
    .hcount_out(hcount_crrc),
    .vsync_out(vsync_crrc),
    .hsync_out(hsync_crrc),
    .vblnk_out(vblnk_crrc),
    .hblnk_out(hblnk_crrc)
);

image_rom #(64, 64, 12, "./images/rapid.data") car_rapid_rom(
    .clk(clk65M),
    .address(rapid_car_address),
    .rgb_out(rapid_car_data)
);

wire [15:0] current_lap_time, last_lap_time, best_lap_time;

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
    .hcount_in(hcount_crrc),
    .hsync_in(hsync_crrc),
    .hblnk_in(hblnk_crrc),
    .vcount_in(vcount_crrc),
    .vsync_in(vsync_crrc),
    .vblnk_in(vblnk_crrc),
    .rgb_in(rgb_crrc),
    .char_pixels(current_lap_time_char_pixels),
    .pclk(clk65M),
    .rst(rst),
    .visible(game_visible),
    .hsync_out(hsync_rcrl),
    .hcount_out(hcount_rcrl),
    .hblnk_out(hblnk_rcrl),
    .vcount_out(vcount_rcrl),
    .vsync_out(vsync_rcrl),
    .vblnk_out(vblnk_rcrl),
    .rgb_out(rgb_rcrl),
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
    //.last_lap_time(max_lap_time_exceeded),
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

wire [10:0] vcount_rbrs, hcount_rbrs;
wire vsync_rbrs, vblnk_rbrs, hsync_rbrs, hblnk_rbrs;
wire [11:0] rgb_rbrs;

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
    .hcount_out(hcount_rbrs),
    .vcount_out(vcount_rbrs),
    .hsync_out(hsync_rbrs),
    .vsync_out(vsync_rbrs),
    .hblnk_out(hblnk_rbrs),
    .vblnk_out(vblnk_rbrs),
    .rgb_out(rgb_rbrs),
    //.rgb_out({r, g, b}),
    //.vsync_out(vs),
    //.hsync_out(hs),
    .char_xy(best_lap_time_char_xy),
    .char_line(best_lap_time_char_addr[3:0])
);

best_lap_time_char_rom best_lap_time_char_rom(
    .char_xy(best_lap_time_char_xy),
    .best_lap_time(checkpoints_passed),
  //  .best_lap_time(best_lap_time),
    .char_code(best_lap_time_char_addr[10:4])
);

font_rom best_lap_time_font_rom (
    .clk(clk65M),
    .addr(best_lap_time_char_addr),
    .char_line_pixels(best_lap_time_char_pixels)
);

wire [10:0] too_slow_char_addr;
wire [7:0] too_slow_char_pixels;
wire [15:0] too_slow_char_xy;

wire [10:0] vcount_rsrc, hcount_rsrc;
wire vsync_rsrc, vblnk_rsrc, hsync_rsrc, hblnk_rsrc;
wire [11:0] rgb_rsrc;

draw_rect_char #(424, 376, 22, 1, 12'h333) draw_too_slow_rect_char (
    .hcount_in(hcount_rbrs),
    .vcount_in(vcount_rbrs),
    .hsync_in(hsync_rbrs),
    .hblnk_in(hblnk_rbrs),
    .vsync_in(vsync_rbrs),
    .vblnk_in(vblnk_rbrs),
    .rgb_in(rgb_rbrs),
    .char_pixels(too_slow_char_pixels),
    .pclk(clk65M),
    .rst(rst),
    .visible(too_slow_visible),
    .hcount_out(hcount_rsrc),
    .vcount_out(vcount_rsrc),
    .hsync_out(hsync_rsrc),
    .vsync_out(vsync_rsrc),
    .hblnk_out(hblnk_rsrc),
    .vblnk_out(vblnk_rsrc),
    .rgb_out(rgb_rsrc),
    .char_xy(too_slow_char_xy),
    .char_line(too_slow_char_addr[3:0])
);

too_slow_char_rom my_too_slow_char_rom(
    .char_xy(too_slow_char_xy),
    .char_code(too_slow_char_addr[10:4])
);

font_rom too_slow_font_rom (
    .clk(clk65M),
    .addr(too_slow_char_addr),
    .char_line_pixels(too_slow_char_pixels)
);

wire [10:0] cheater_char_addr;
wire [7:0] cheater_char_pixels;
wire [15:0] cheater_char_xy;

wire [10:0] vcount_out, hcount_out;
wire vsync_out, vblnk_out, hsync_out, hblnk_out;
wire [11:0] rgb_out;

draw_rect_char #(424, 350, 22, 1, 12'h333) draw_cheater_rect_char (
    .hcount_in(hcount_rsrc),
    .vcount_in(vcount_rsrc),
    .hsync_in(hsync_rsrc),
    .hblnk_in(hblnk_rsrc),
    .vsync_in(vsync_rsrc),
    .vblnk_in(vblnk_rsrc),
    .rgb_in(rgb_rsrc),
    .char_pixels(cheater_char_pixels),
    .pclk(clk65M),
    .rst(rst),
    //.visible(game_visible),
    .visible(cheater_visible),
    .hcount_out(hcount_out),
    .vcount_out(vcount_out),
    .hblnk_out(hblnk_out),
    .vblnk_out(vblnk_out),
    .rgb_out({r, g, b}),
    .vsync_out(vs),
    .hsync_out(hs),
    .char_xy(cheater_char_xy),
    .char_line(cheater_char_addr[3:0])
);

cheater_char_rom my_cheater_char_rom(
    .char_xy(cheater_char_xy),
    .char_code(cheater_char_addr[10:4])
);

font_rom cheater_font_rom (
    .clk(clk65M),
    .addr(cheater_char_addr),
    .char_line_pixels(cheater_char_pixels)
);

endmodule
