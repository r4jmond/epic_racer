`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2020 23:27:20
// Design Name: 
// Module Name: car_ctl
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


module car_ctl(
    input wire pclk,
    input wire rst,
    input wire frame_ended,
    input wire [3:0] key,
    output reg [10:0] xpos = 0,
    output reg [10:0] ypos = 0
);

localparam CAR_WIDTH = 64;
localparam CAR_LENGTH = 64;
localparam X_MAX = 1024 - CAR_WIDTH;
localparam Y_MAX = 768 - CAR_LENGTH;
localparam SPEED_MAX = 50;
localparam SPEED_MIN = -50;
localparam ARROW_UP = 4'b0001;
localparam ARROW_DOWN = 4'b0010;
localparam ARROW_LEFT = 4'b0100;
localparam ARROW_RIGHT = 4'b1000;
localparam ARROW_UPLEFT = ARROW_UP | ARROW_LEFT;
localparam ARROW_UPRIGHT = ARROW_UP | ARROW_RIGHT;
localparam ARROW_DOWNLEFT = ARROW_DOWN | ARROW_LEFT;
localparam ARROW_DOWNRIGHT = ARROW_DOWN | ARROW_RIGHT;

reg [10:0] xpos_nxt = 0, ypos_nxt = 0;
reg [10:0] xspeed = 0, xspeed_nxt = 0, yspeed = 0, yspeed_nxt = 0;
/*reg [10:0] xspeed = 0;
reg [10:0] xspeed_nxt = 0;
reg [10:0] yspeed = 0;
reg [10:0] yspeed_nxt = 0;*/
reg [31:0] timer = 0, timer_nxt = 0;

always @(posedge pclk)
if(rst)
begin
    xpos <= 300;
    ypos <= 250;
    xspeed <= 0;
    yspeed <= 0;
    timer <= 0;
end
else
begin
    xpos <= xpos_nxt;
    ypos <= ypos_nxt;
    xspeed <= xspeed_nxt;
    yspeed <= yspeed_nxt;
    timer <= timer_nxt;
end

always @*
begin
    if(xpos >= X_MAX) xpos_nxt = X_MAX;
    else if (xpos <= 5) xpos_nxt = 5;
    else xpos_nxt = xpos;
    if(ypos >= Y_MAX) ypos_nxt = Y_MAX;
    else if (ypos <= 5) ypos_nxt = 5;
    else ypos_nxt = ypos;
    timer_nxt = timer + 1;
    
    if(timer >= 2000000) begin
        timer_nxt = 0;
        xpos_nxt  = xpos + xspeed;
        ypos_nxt  = ypos + yspeed;
        if(key[0]) yspeed_nxt = yspeed - 1;
        if(key[1]) yspeed_nxt = yspeed + 1;
        if(key[2]) xspeed_nxt = xspeed - 1;
        if(key[3]) xspeed_nxt = xspeed + 1;
        
        /*if(xspeed > 0) xspeed_nxt = xspeed - 1;
        else if(xspeed < 0) xspeed_nxt = xspeed + 1;
        if(yspeed > 0) yspeed_nxt = yspeed - 1;
        else if(yspeed < 0) yspeed_nxt = yspeed + 1;*/
    end
   /* if(xspeed > SPEED_MAX) xspeed_nxt = SPEED_MAX;
    else if (xspeed < SPEED_MIN) xspeed_nxt = SPEED_MIN;
    if(yspeed > SPEED_MAX) yspeed_nxt = SPEED_MAX;
    else if (yspeed < SPEED_MIN) yspeed_nxt = SPEED_MIN;*/
end

endmodule
