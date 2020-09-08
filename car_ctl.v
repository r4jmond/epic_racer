`timescale 1ns / 1ps

module car_ctl(
    input wire pclk,
    input wire rst,
    input wire [3:0] key,
    output reg [10:0] xpos,
    output reg [10:0] ypos,
    output reg [1:0] move_dir
);

localparam CAR_WIDTH = 64;
localparam CAR_LENGTH = 64;
localparam X_MAX = 1024 - CAR_WIDTH;
localparam Y_MAX = 768 - CAR_LENGTH;

localparam KEY_UP = 4'b0001;
localparam KEY_DOWN = 4'b0010;
localparam KEY_LEFT = 4'b0100;
localparam KEY_RIGHT = 4'b1000;

/*
localparam KEY_UPLEFT = KEY_UP | KEY_LEFT;
localparam KEY_UPRIGHT = KEY_UP | KEY_RIGHT;
localparam KEY_DOWNLEFT = KEY_DOWN | KEY_LEFT;
localparam KEY_DOWNRIGHT = KEY_DOWN | KEY_RIGHT;*/
/*
localparam IDLE = 3'b000;
localparam GOING_UP = 3'b001;
localparam GOING_DOWN = 3'b011;
localparam GOING_LEFT = 3'b010;
localparam GOING_RIGHT = 3'b110;
*/

localparam DIR_DOWN = 2'b00;
localparam DIR_RIGHT = 2'b01;
localparam DIR_LEFT = 2'b11;
localparam DIR_UP = 2'b10;

localparam DELAY_MIN = 100000;
localparam DELAY_STEP = 5000;
localparam DELAY_SLOWED = 350000;
localparam DELAY_MAX = 400000;

reg [10:0] xpos_nxt, ypos_nxt;
reg [2:0] state, state_nxt;
reg [23:0] xtimer, xtimer_nxt, ytimer, ytimer_nxt;
reg [23:0] xdelay, xdelay_nxt, ydelay, ydelay_nxt;
reg [1:0] move_dir_nxt;
reg [10:0] car_x_pos, car_y_pos;


always @(posedge pclk)
if(rst)
begin
    xpos <= 490;
    ypos <= 90;
    xtimer <= 0;
    ytimer <= 0;
    move_dir <= DIR_RIGHT;
    xdelay <= 0;
    ydelay <= 0;
end
else
begin
    xpos <= xpos_nxt;
    ypos <= ypos_nxt;
    xtimer <= xtimer_nxt;
    ytimer <= ytimer_nxt;
    move_dir <= move_dir_nxt;
    xdelay <= xdelay_nxt;
    ydelay <= ydelay_nxt;
end

always @*
begin
    move_dir_nxt = move_dir;
    xpos_nxt = xpos;
    ypos_nxt = ypos;
    xdelay_nxt = xdelay;
    ydelay_nxt = ydelay;
    
    if(xtimer < xdelay) xtimer_nxt = xtimer + 1;
    else
    begin
        xtimer_nxt = 0;
        if(xdelay < DELAY_MAX)
        begin
            if(move_dir == DIR_LEFT) xpos_nxt = (car_x_pos <= 48) ? 48 : xpos - 1;
            else if(move_dir == DIR_RIGHT) xpos_nxt = (car_x_pos >= X_MAX) ? X_MAX : xpos + 1;
        end
    end

    if(ytimer < ydelay) ytimer_nxt = ytimer + 1;
    else
    begin
        ytimer_nxt = 0;
        if(ydelay < DELAY_MAX)
        begin
            if(move_dir == DIR_UP) ypos_nxt = (ypos <= 1) ? 1 : ypos - 1;
            else if(move_dir == DIR_DOWN) ypos_nxt = (ypos >= Y_MAX) ? Y_MAX : ypos + 1; 
        end
    end

    if((car_x_pos >= 896 && car_y_pos <= 384) || (car_x_pos >= 48 && car_x_pos <= 64 && car_y_pos <= 96) || 
        (car_x_pos >= 64 && car_x_pos <= 80 && car_y_pos <= 64) || (car_x_pos >= 80 && car_x_pos <= 96 && car_y_pos <= 48) || 
        (car_x_pos >= 96 && car_x_pos <= 112 && car_y_pos <= 32) || (car_y_pos <= 16) || 
        (car_x_pos >= 140  && car_x_pos <= 168 && car_y_pos >= 136 && car_y_pos <= 164) ||
        (car_x_pos >= 764  && car_x_pos <= 792 && car_y_pos >= 136 && car_y_pos <= 164) ||
        (car_x_pos >= 176  && car_x_pos <= 592 && car_y_pos >= 160 && car_y_pos <= 304) ||
        (car_x_pos >= 480  && car_x_pos <= 540 && car_y_pos >= 332 && car_y_pos <= 352) ||
        (car_x_pos >= 268  && car_x_pos <= 294 && car_y_pos >= 424 && car_y_pos <= 488) ||
        (car_x_pos >= 324  && car_x_pos <= 380 && car_y_pos >= 488 && car_y_pos <= 512) ||
        (car_x_pos >= 548  && car_x_pos <= 604 && car_y_pos >= 488 && car_y_pos <= 512) ||
        (car_x_pos >= 740  && car_x_pos <= 796 && car_y_pos >= 488 && car_y_pos <= 512) ||
        (car_x_pos >= 832  && car_x_pos <= 912 && car_y_pos >= 496 && car_y_pos <= 512) ||
        (car_x_pos >= 336  && car_x_pos <= 784 && car_y_pos >= 592 && car_y_pos <= 608) ||
        (car_x_pos >= 800  && car_x_pos <= 824 && car_y_pos >= 596 && car_y_pos <= 666) ||
        (car_x_pos >= 304  && car_x_pos <= 784 && car_y_pos >= 656 && car_y_pos <= 672) ||
        (car_x_pos >= 324  && car_x_pos <= 380 && car_y_pos >= 488 && car_y_pos <= 512) ||
        (car_x_pos >= 50  && car_x_pos <= 234 && car_y_pos >= 720 && car_y_pos <= 752) ||
        (car_x_pos >= 946  && car_x_pos <= 1008 && car_y_pos >= 730 && car_y_pos <= 752)) 
        begin
            if(move_dir == DIR_DOWN) begin
                ypos_nxt = ypos - 1;
            end
            else if(move_dir == DIR_UP) begin
                ypos_nxt = ypos + 1;
            end
            else if(move_dir == DIR_LEFT) begin
                xpos_nxt = xpos + 1;
            end
            else if(move_dir == DIR_RIGHT) begin
                xpos_nxt = xpos - 1;
            end
   
       end
    
    if(move_dir == DIR_DOWN) begin
        car_x_pos = xpos + 32;
        car_y_pos = ypos + 54;
    end
    else if(move_dir == DIR_UP) begin
        car_x_pos = xpos + 32;
        car_y_pos = ypos + 10;
    end
    else if(move_dir == DIR_LEFT) begin
        car_x_pos = xpos + 10;
        car_y_pos = ypos + 32;
    end
    else if(move_dir == DIR_RIGHT) begin
        car_x_pos = xpos + 54;
        car_y_pos = ypos + 32;
    end
    else begin
        car_x_pos = xpos + 32;
        car_y_pos = ypos + 32;
    end

    case (key)
        KEY_UP:
        begin
            move_dir_nxt = DIR_UP;
            if((ytimer >= ydelay) && (ydelay > DELAY_MIN)) ydelay_nxt = ydelay - DELAY_STEP;
            if((xtimer >= xdelay) && (xdelay < DELAY_MAX)) xdelay_nxt = xdelay + DELAY_STEP;
        end
        KEY_DOWN:
        begin
            move_dir_nxt = DIR_DOWN;
            if((ytimer >= ydelay) && (ydelay > DELAY_MIN)) ydelay_nxt = ydelay - DELAY_STEP;
            if((xtimer >= xdelay) && (xdelay < DELAY_MAX)) xdelay_nxt = xdelay + DELAY_STEP;
        end
        KEY_LEFT:
        begin
            move_dir_nxt = DIR_LEFT;
            if((xtimer >= xdelay) && (xdelay > DELAY_MIN)) xdelay_nxt = xdelay - DELAY_STEP;
            if((ytimer >= ydelay) && (ydelay < DELAY_MAX)) ydelay_nxt = ydelay + DELAY_STEP;
        end
        KEY_RIGHT:
        begin
            move_dir_nxt = DIR_RIGHT;
            if((xtimer >= xdelay) && (xdelay > DELAY_MIN)) xdelay_nxt = xdelay - DELAY_STEP;
            if((ytimer >= ydelay) && (ydelay < DELAY_MAX)) ydelay_nxt = ydelay + DELAY_STEP;
        end
        default:
        begin
            move_dir_nxt = move_dir;
            if((xtimer >= xdelay) && (xdelay < DELAY_MAX)) xdelay_nxt = xdelay + DELAY_STEP;
            if((ytimer >= ydelay) && (ydelay < DELAY_MAX)) ydelay_nxt = ydelay + DELAY_STEP;
        end
    endcase
end

endmodule
