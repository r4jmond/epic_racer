`timescale 1ns / 1ps

module car_ctl(
    input wire pclk,
    input wire rst,
    input wire [3:0] key,
    output reg [10:0] xpos,
    output reg [10:0] ypos,
    output reg [1:0] move_dir,
    output wire [10:0] car_x_start, 
    output wire [10:0] car_x_end,
    output wire [10:0] car_y_start, 
    output wire [10:0] car_y_end
);

localparam CAR_WIDTH = 64;
localparam CAR_LENGTH = 64;
localparam SCREEN_WIDTH = 1024;
localparam SCREEN_LENGTH = 768;
localparam TILE_SIZE = 16;

localparam KEY_UP = 4'b0001;
localparam KEY_DOWN = 4'b0010;
localparam KEY_LEFT = 4'b0100;
localparam KEY_RIGHT = 4'b1000;

/*
localparam KEY_UPLEFT = KEY_UP | KEY_LEFT;
localparam KEY_UPRIGHT = KEY_UP | KEY_RIGHT;
localparam KEY_DOWNLEFT = KEY_DOWN | KEY_LEFT;
localparam KEY_DOWNRIGHT = KEY_DOWN | KEY_RIGHT;*/

localparam DIR_DOWN = 2'b00;
localparam DIR_RIGHT = 2'b01;
localparam DIR_LEFT = 2'b11;
localparam DIR_UP = 2'b10;

localparam DELAY_MIN = 160000;
localparam DELAY_STEP = 2000;
localparam DELAY_SLOWED = 490000;
localparam DELAY_MAX = 500000;


reg [23:0] delay_min = 160000;
reg [10:0] xpos_nxt, ypos_nxt;
reg [2:0] state, state_nxt;
reg [23:0] xtimer, xtimer_nxt, ytimer, ytimer_nxt;
reg [23:0] xdelay, xdelay_nxt, ydelay, ydelay_nxt;
reg [1:0] move_dir_nxt, move_dir_prev, move_dir_prev_nxt;
reg [10:0] car_x_start_prev, car_x_end_prev, car_y_start_prev, car_y_end_prev;
reg moving_down, moving_up, moving_left, moving_right;
reg moving_down_nxt, moving_up_nxt, moving_left_nxt, moving_right_nxt;

assign car_x_start = xpos + 20;
assign car_y_start = ypos + 20;
assign car_x_end = xpos + 43;
assign car_y_end = ypos + 43;

always @(posedge pclk)
if(rst)
begin
    xpos <= 300;
    ypos <= 70;
    xtimer <= 0;
    ytimer <= 0;
    move_dir <= DIR_RIGHT;
    move_dir_prev <= DIR_RIGHT;
    xdelay <= 0;
    ydelay <= 0;
    car_x_start_prev <= 0;
    car_x_end_prev <= 0;
    car_y_start_prev <= 0;
    car_y_end_prev <= 0;
    moving_right <= 0;
    moving_left <= 0;
    moving_down <= 0;
    moving_up <= 0;
    /*car_x_start <= 0;
    car_x_end <= 0;
    car_y_start <= 0;
    car_y_end <= 0;*/
end
else
begin
    xpos <= xpos_nxt;
    ypos <= ypos_nxt;
    xtimer <= xtimer_nxt;
    ytimer <= ytimer_nxt;
    move_dir <= move_dir_nxt;
    move_dir_prev <= move_dir_prev_nxt;
    xdelay <= xdelay_nxt;
    ydelay <= ydelay_nxt;
    car_x_start_prev <= car_x_start;
    car_x_end_prev <= car_x_end;
    car_y_start_prev <= car_y_start;
    car_y_start_prev <= car_y_end;
    moving_right <= moving_right_nxt;
    moving_left <= moving_left_nxt;
    moving_down <= moving_down_nxt;
    moving_up <= moving_up_nxt;
    /*car_x_start <= car_x_start_nxt;
    car_x_end <= car_x_end_nxt;
    car_y_start <= car_y_start_nxt;
    car_y_end <= car_y_end_nxt;*/
end

always @*
begin
    move_dir_nxt = move_dir;
    move_dir_prev_nxt = move_dir_prev;
    xpos_nxt = xpos;
    ypos_nxt = ypos;
    xdelay_nxt = xdelay;
    ydelay_nxt = ydelay;

    moving_left_nxt = 0;
    moving_right_nxt = 0;
    moving_down_nxt = 0;
    moving_up_nxt = 0;

    
    if(xtimer < xdelay) xtimer_nxt = xtimer + 1;
    else
    begin
        xtimer_nxt = 0;
        if(xdelay < DELAY_MAX)
        begin
            if ((move_dir == DIR_LEFT) || ((move_dir_prev == DIR_LEFT)  && (move_dir != DIR_RIGHT)))
            begin
                xpos_nxt = (xpos <= 0) ? 0 : (xpos - 1);
                moving_left_nxt = 1;
            end
            else if ((move_dir == DIR_RIGHT) || ((move_dir_prev == DIR_RIGHT) && move_dir != DIR_LEFT))
            begin
                xpos_nxt = (car_x_end >= SCREEN_WIDTH) ? xpos : (xpos + 1);
                moving_right_nxt = 1;
            end
        end
    end

    if(ytimer < ydelay) ytimer_nxt = ytimer + 1;
    else
    begin
        ytimer_nxt = 0;
        if(ydelay < DELAY_MAX)
        begin
            if ((move_dir == DIR_UP) || ((move_dir_prev == DIR_UP) && (move_dir != DIR_DOWN)))
            begin
                ypos_nxt = (ypos <= 0) ? 0 : ypos - 1;
                moving_up_nxt = 1;
            end
            else if ((move_dir == DIR_DOWN) || ((move_dir_prev == DIR_DOWN) && (move_dir != DIR_UP)))
            begin
                ypos_nxt = (car_y_end >= SCREEN_LENGTH) ? xpos : ypos + 1;
                moving_down_nxt = 1;
            end
        end
    end

    if( (car_x_end >= 110  && car_y_end >= 70  && car_x_start <= 825 && car_y_start <= 143) || //track coords
        (car_x_end >= 786  && car_y_end >= 85  && car_x_start <= 880 && car_y_start <= 335) ||
        (car_x_end >= 625  && car_y_end >= 260 && car_x_start <= 788 && car_y_start <= 335) ||
        (car_x_end >= 625  && car_y_end >= 335 && car_x_start <= 702 && car_y_start <= 430) ||
        (car_x_end >= 206  && car_y_end >= 356 && car_x_start <= 625 && car_y_start <= 430) ||
        (car_x_end >= 182  && car_y_end >= 372 && car_x_start <= 270 && car_y_start <= 500) ||
        (car_x_end >= 208  && car_y_end >= 500 && car_x_start <= 270 && car_y_start <= 555) ||
        (car_x_end >= 270  && car_y_end >= 478 && car_x_start <= 304 && car_y_start <= 594) ||
        (car_x_end >= 304  && car_y_end >= 506 && car_x_start <= 948 && car_y_start <= 594) ||
        (car_x_end >= 824  && car_y_end >= 594 && car_x_start <= 948 && car_y_start <= 750) ||
        (car_x_end >= 268  && car_y_end >= 666 && car_x_start <= 824 && car_y_start <= 750) ||
        (car_x_end >= 262  && car_y_end >= 640 && car_x_start <= 300 && car_y_start <= 675) ||
        (car_x_end >= 235  && car_y_end >= 608 && car_x_start <= 268 && car_y_start <= 746) ||
        (car_x_end >= 200  && car_y_end >= 568 && car_x_start <= 235 && car_y_start <= 707) ||
        (car_x_end >= 172  && car_y_end >= 535 && car_x_start <= 200 && car_y_start <= 674) ||
        (car_x_end >= 141  && car_y_end >= 502 && car_x_start <= 172 && car_y_start <= 642) ||
        (car_x_end >= 86   && car_y_end >= 560 && car_x_start <= 141 && car_y_start <= 614) ||
        (car_x_end >= 56   && car_y_end >= 84  && car_x_start <= 141 && car_y_start <= 560)
    )  delay_min = DELAY_MIN;
    else delay_min = DELAY_SLOWED;

    if( (car_x_start <= (TILE_SIZE * 3)) || (car_x_end >= (SCREEN_WIDTH - TILE_SIZE)) || (car_y_start <= TILE_SIZE) || //objects you can't go through
        (car_y_end >= (SCREEN_LENGTH - TILE_SIZE)) || (car_x_end >= 912 && car_y_start <= 400)                      || 
        (car_x_end >= 48 && car_x_start <= 64 && car_y_start <= 96)                                                 || 
        (car_x_end >= 64 && car_x_start <= 80 && car_y_start <= 64)                                                 || 
        (car_x_end >= 80 && car_x_start <= 96 && car_y_start <= 48)                                                 || 
        (car_x_end >= 96 && car_x_start <= 112 && car_y_start <= 32)                                                || 
        (car_x_end >= 140  && car_x_start <= 168 && car_y_end >= 136 && car_y_start <= 164)                         ||
        (car_x_end >= 764  && car_x_start <= 792 && car_y_end >= 136 && car_y_start <= 164)                         ||
        (car_x_end >= 176  && car_x_start <= 592 && car_y_end >= 160 && car_y_start <= 304)                         ||
        (car_x_end >= 480  && car_x_start <= 540 && car_y_end >= 332 && car_y_start <= 352)                         ||
        (car_x_end >= 268  && car_x_start <= 294 && car_y_end >= 424 && car_y_start <= 488)                         ||
        (car_x_end >= 324  && car_x_start <= 380 && car_y_end >= 488 && car_y_start <= 512)                         ||
        (car_x_end >= 548  && car_x_start <= 604 && car_y_end >= 488 && car_y_start <= 512)                         ||
        (car_x_end >= 740  && car_x_start <= 796 && car_y_end >= 488 && car_y_start <= 512)                         ||
        (car_x_end >= 832  && car_x_start <= 912 && car_y_end >= 496 && car_y_start <= 512)                         ||
        (car_x_end >= 336  && car_x_start <= 784 && car_y_end >= 592 && car_y_start <= 608)                         ||
        (car_x_end >= 800  && car_x_start <= 824 && car_y_end >= 596 && car_y_start <= 666)                         ||
        (car_x_end >= 304  && car_x_start <= 784 && car_y_end >= 656 && car_y_start <= 672)                         ||
        (car_x_end >= 324  && car_x_start <= 380 && car_y_end >= 488 && car_y_start <= 512)                         ||
        (car_x_end >= 50   && car_x_start <= 234 && car_y_end >= 720 && car_y_start <= 752)                         ||
        (car_x_end >= 946  && car_x_start <= 1008 && car_y_end >= 720 && car_y_start <= 752) ) 
    begin
        if(moving_left && (((car_x_start <= (TILE_SIZE * 3)) && (car_x_start_prev > (TILE_SIZE * 3))) || 
            ((car_x_start <= 64)   && (car_x_start_prev > 64))  ||
            ((car_x_start <= 80)   && (car_x_start_prev > 80))  ||
            ((car_x_start <= 96)   && (car_x_start_prev > 96))  ||
            ((car_x_start <= 112)  && (car_x_start_prev > 112)) ||
            ((car_x_start <= 168)  && (car_x_start_prev > 168)) || 
            ((car_x_start <= 792)  && (car_x_start_prev > 792)) ||
            ((car_x_start <= 592)  && (car_x_start_prev > 592)) ||
            ((car_x_start <= 540)  && (car_x_start_prev > 540)) ||
            ((car_x_start <= 294)  && (car_x_start_prev > 294)) ||
            ((car_x_start <= 380)  && (car_x_start_prev > 380)) ||
            ((car_x_start <= 604)  && (car_x_start_prev > 604)) ||
            ((car_x_start <= 796)  && (car_x_start_prev > 796)) ||
            ((car_x_start <= 912)  && (car_x_start_prev > 912)) ||
            ((car_x_start <= 784)  && (car_x_start_prev > 784)) ||
            ((car_x_start <= 824)  && (car_x_start_prev > 824)) ||
            ((car_x_start <= 784)  && (car_x_start_prev > 784)) ||
            ((car_x_start <= 380)  && (car_x_start_prev > 380)) ||
            ((car_x_start <= 234)  && (car_x_start_prev > 234)) ||
            ((car_x_start <= 1008) && (car_x_start_prev > 1008))
        )) xpos_nxt = xpos + 1;
        else if(moving_right && (
            ((car_x_end >= (SCREEN_WIDTH - TILE_SIZE)) && (car_x_end_prev < (SCREEN_WIDTH - TILE_SIZE))) || 
            ((car_x_end >= 912) && (car_x_end_prev < 912)) ||
            ((car_x_end >= 48 ) && (car_x_end_prev < 48 )) ||
            ((car_x_end >= 64 ) && (car_x_end_prev < 64 )) ||
            ((car_x_end >= 80 ) && (car_x_end_prev < 80 )) ||
            ((car_x_end >= 96 ) && (car_x_end_prev < 96 )) ||
            ((car_x_end >= 140) && (car_x_end_prev < 140)) ||
            ((car_x_end >= 764) && (car_x_end_prev < 764)) ||
            ((car_x_end >= 176) && (car_x_end_prev < 176)) ||
            ((car_x_end >= 480) && (car_x_end_prev < 480)) ||
            ((car_x_end >= 268) && (car_x_end_prev < 268)) ||
            ((car_x_end >= 324) && (car_x_end_prev < 324)) ||
            ((car_x_end >= 548) && (car_x_end_prev < 548)) ||
            ((car_x_end >= 740) && (car_x_end_prev < 740)) ||
            ((car_x_end >= 832) && (car_x_end_prev < 832)) ||
            ((car_x_end >= 336) && (car_x_end_prev < 336)) ||
            ((car_x_end >= 800) && (car_x_end_prev < 800)) ||
            ((car_x_end >= 304) && (car_x_end_prev < 304)) ||
            ((car_x_end >= 324) && (car_x_end_prev < 324)) ||
            ((car_x_end >= 50 ) && (car_x_end_prev < 50 )) ||
            ((car_x_end >= 946) && (car_x_end_prev < 946))
        )) xpos_nxt = xpos - 1;
        if (moving_up && ( 
            ((car_y_start <= TILE_SIZE) && (car_y_start_prev > TILE_SIZE)) ||
            ((car_y_start <= 400) && (car_y_start_prev > 400))       || 
            ((car_y_start <= 96)  && (car_y_start_prev > 96) )       ||
            ((car_y_start <= 64)  && (car_y_start_prev > 64) )       ||
            ((car_y_start <= 48)  && (car_y_start_prev > 48) )       ||
            ((car_y_start <= 32)  && (car_y_start_prev > 32) )       ||
            ((car_y_start <= 164) && (car_y_start_prev > 164))       ||
            ((car_y_start <= 164) && (car_y_start_prev > 164))       ||
            ((car_y_start <= 304) && (car_y_start_prev > 304))       ||
            ((car_y_start <= 352) && (car_y_start_prev > 352))       ||
            ((car_y_start <= 488) && (car_y_start_prev > 488))       ||
            ((car_y_start <= 512) && (car_y_start_prev > 512))       ||
            ((car_y_start <= 512) && (car_y_start_prev > 512))       ||
            ((car_y_start <= 512) && (car_y_start_prev > 512))       ||
            ((car_y_start <= 512) && (car_y_start_prev > 512))       ||
            ((car_y_start <= 608) && (car_y_start_prev > 608))       ||
            ((car_y_start <= 666) && (car_y_start_prev > 666))       ||
            ((car_y_start <= 672) && (car_y_start_prev > 672))       ||
            ((car_y_start <= 512) && (car_y_start_prev > 512))       ||
            ((car_y_start <= 752) && (car_y_start_prev > 752))
        )) ypos_nxt = ypos + 1;
        else if(moving_down && (
            ((car_y_end >= (SCREEN_LENGTH - TILE_SIZE)) && (car_y_end_prev < (SCREEN_LENGTH - TILE_SIZE))) ||
            ((car_y_end >= 136) && (car_y_end_prev < 136)) ||
            ((car_y_end >= 136) && (car_y_end_prev < 136)) ||
            ((car_y_end >= 160) && (car_y_end_prev < 160)) ||
            ((car_y_end >= 332) && (car_y_end_prev < 332)) ||
            ((car_y_end >= 424) && (car_y_end_prev < 424)) ||
            ((car_y_end >= 488) && (car_y_end_prev < 488)) ||
            ((car_y_end >= 488) && (car_y_end_prev < 488)) ||
            ((car_y_end >= 488) && (car_y_end_prev < 488)) ||
            ((car_y_end >= 496) && (car_y_end_prev < 496)) ||
            ((car_y_end >= 592) && (car_y_end_prev < 592)) ||
            ((car_y_end >= 596) && (car_y_end_prev < 596)) ||
            ((car_y_end >= 656) && (car_y_end_prev < 656)) ||
            ((car_y_end >= 488) && (car_y_end_prev < 488)) ||
            ((car_y_end >= 720) && (car_y_end_prev < 720))
        )) ypos_nxt = ypos - 1;
    end

    case (key)
        KEY_UP:
        begin
            move_dir_nxt = DIR_UP;
            if(move_dir_nxt != move_dir) move_dir_prev_nxt = move_dir;
            if((ytimer >= ydelay) && (ydelay > delay_min)) ydelay_nxt = ydelay - DELAY_STEP;
            else if((ytimer >= ydelay) && (ydelay < delay_min)) ydelay_nxt = ydelay + DELAY_STEP;
            if((xtimer >= xdelay) && (xdelay < DELAY_MAX)) xdelay_nxt = xdelay + DELAY_STEP;
        end
        KEY_DOWN:
        begin
            move_dir_nxt = DIR_DOWN;
            if(move_dir_nxt != move_dir) move_dir_prev_nxt = move_dir;
            if((ytimer >= ydelay) && (ydelay > delay_min)) ydelay_nxt = ydelay - DELAY_STEP;
            else if((ytimer >= ydelay) && (ydelay < delay_min)) ydelay_nxt = ydelay + DELAY_STEP;
            if((xtimer >= xdelay) && (xdelay < DELAY_MAX)) xdelay_nxt = xdelay + DELAY_STEP;
        end
        KEY_LEFT:
        begin
            move_dir_nxt = DIR_LEFT;
            if(move_dir_nxt != move_dir) move_dir_prev_nxt = move_dir;
            if((xtimer >= xdelay) && (xdelay > delay_min)) xdelay_nxt = xdelay - DELAY_STEP;
            else if((xtimer >= xdelay) && (xdelay < delay_min)) xdelay_nxt = xdelay + DELAY_STEP;
            if((ytimer >= ydelay) && (ydelay < DELAY_MAX)) ydelay_nxt = ydelay + DELAY_STEP;
        end
        KEY_RIGHT:
        begin
            move_dir_nxt = DIR_RIGHT;
            if(move_dir_nxt != move_dir) move_dir_prev_nxt = move_dir;
            if((xtimer >= xdelay) && (xdelay > delay_min)) xdelay_nxt = xdelay - DELAY_STEP;
            else if((xtimer >= xdelay) && (xdelay < delay_min)) xdelay_nxt = xdelay + DELAY_STEP;
            if((ytimer >= ydelay) && (ydelay < DELAY_MAX)) ydelay_nxt = ydelay + DELAY_STEP;
        end
        default:
        begin
            move_dir_prev_nxt = move_dir_prev;
            move_dir_nxt = move_dir;
            if((xtimer >= xdelay) && (xdelay < DELAY_MAX)) xdelay_nxt = xdelay + DELAY_STEP;
            if((ytimer >= ydelay) && (ydelay < DELAY_MAX)) ydelay_nxt = ydelay + DELAY_STEP;
        end
    endcase
end

/*
   if(move_dir == DIR_DOWN) begin 
        car_x_start = xpos + 20;
        car_y_start = ypos + 12;
        car_x_end = xpos + 43;
        car_y_end = ypos + 54;
    end
    else if(move_dir == DIR_UP) begin
        car_x_start = xpos + 20;
        car_y_start = ypos + 9;
        car_x_end = xpos + 43;
        car_y_end = ypos + 51;
    end
    else if(move_dir == DIR_LEFT) begin
        car_x_start = xpos + 9;
        car_y_start = ypos + 20;
        car_x_end = xpos + 51;
        car_y_end = ypos + 43;
    end
    else if(move_dir == DIR_RIGHT) begin
        car_x_start = xpos + 12;
        car_y_start = ypos + 20;
        car_x_end = xpos + 54;
        car_y_end = ypos + 43;
    end
    else begin
        car_x_start = xpos + 20;
        car_y_start = ypos + 12;
        car_x_end = xpos + 43;
        car_y_end = ypos + 54;
    end*/

endmodule
