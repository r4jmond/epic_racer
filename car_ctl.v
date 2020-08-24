`timescale 1ns / 1ps

module car_ctl(
    input wire pclk,
    input wire rst,
    input wire frame_ended,
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
localparam DELAY_STEP = 10000;
localparam DELAY_MAX = 400000;

reg [10:0] xpos_nxt, ypos_nxt;
reg [2:0] state, state_nxt;
reg [23:0] xtimer, xtimer_nxt, ytimer, ytimer_nxt;
reg [23:0] xdelay, xdelay_nxt, ydelay, ydelay_nxt;
reg [1:0] move_dir_nxt;

always @(posedge pclk)
if(rst)
begin
    xpos <= 300;
    ypos <= 250;
    xtimer <= 0;
    ytimer <= 0;
    move_dir <= DIR_DOWN;
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
    /*if(xpos >= X_MAX) xpos_nxt = X_MAX;
    else if (xpos <= 1) xpos_nxt = 1;
    else xpos_nxt = xpos;
    if(ypos >= Y_MAX) ypos_nxt = Y_MAX;*/

    /*case (key)
        KEY_UP: state_nxt = GOING_UP;
        KEY_DOWN: state_nxt = GOING_DOWN;
        KEY_LEFT: state_nxt = GOING_LEFT;
        KEY_RIGHT: state_nxt = GOING_RIGHT;
        default: state_nxt = IDLE;
    endcase*/

    if(xtimer < xdelay) xtimer_nxt = xtimer + 1;
    else 
    begin
        xtimer_nxt = 0;
        if(xdelay < DELAY_MAX)
        begin
            if(move_dir == DIR_LEFT) xpos_nxt = (xpos <= 1) ? 0 : xpos - 1; //xpos_nxt = xpos - 1; // 
            else if(move_dir == DIR_RIGHT) xpos_nxt = (xpos >= X_MAX) ? X_MAX : xpos + 1;  //xpos_nxt = xpos + 1; // 
        end
    end

    if(ytimer < ydelay) ytimer_nxt = ytimer + 1;
    else
    begin
        ytimer_nxt = 0;
        if(ydelay < DELAY_MAX)
        begin
            if(move_dir == DIR_UP) ypos_nxt = (ypos <= 1) ? 0 : ypos - 1; //ypos_nxt = ypos - 1; // 
            else if(move_dir == DIR_DOWN) ypos_nxt = (ypos >= Y_MAX) ? Y_MAX : ypos + 1; //ypos_nxt = ypos + 1; // 
        end
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
  /*  if(timer >= 2000000) begin
        timer_nxt = 0;
        xpos_nxt  = xpos + xspeed;
        ypos_nxt  = ypos + yspeed;
        if(key && KEY_UP) 
        begin
            yspeed_nxt = yspeed - 1;
            state_nxt = GOING_UP;
        end
        if(key && KEY_DOWN) 
        begin
            yspeed_nxt = yspeed + 1;
            state_nxt = GOING_DOWN;
        end
        if(key && KEY_LEFT) begin
            xspeed_nxt = xspeed - 1;
            state_nxt = GOING_LEFT;
        end 
        if(key && KEY_RIGHT) 
        begin
            xspeed_nxt = xspeed + 1;
            state_nxt = GOING_RIGHT;
        end*/
        /*if(xspeed > 0) xspeed_nxt = xspeed - 1;
        else if(xspeed < 0) xspeed_nxt = xspeed + 1;
        if(yspeed > 0) yspeed_nxt = yspeed - 1;
        else if(yspeed < 0) yspeed_nxt = yspeed + 1;*/
    //end
   /* if(xspeed > SPEED_MAX) xspeed_nxt = SPEED_MAX;
    else if (xspeed < SPEED_MIN) xspeed_nxt = SPEED_MIN;
    if(yspeed > SPEED_MAX) yspeed_nxt = SPEED_MAX;
    else if (yspeed < SPEED_MIN) yspeed_nxt = SPEED_MIN;*/
end

endmodule
