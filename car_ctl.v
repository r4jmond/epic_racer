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
    output reg [10:0] xpos,
    output reg [10:0] ypos
);

localparam SPEED_MAX = 2000;
localparam SPEED_MIN = -2000;
localparam ARROW_UP = 4'b0001;
localparam ARROW_DOWN = 4'b0010;
localparam ARROW_LEFT = 4'b0100;
localparam ARROW_RIGHT = 4'b1000;
localparam ARROW_UPLEFT = ARROW_UP | ARROW_LEFT;
localparam ARROW_UPRIGHT = ARROW_UP | ARROW_RIGHT;
localparam ARROW_DOWNLEFT = ARROW_DOWN | ARROW_LEFT;
localparam ARROW_DOWNRIGHT = ARROW_DOWN | ARROW_RIGHT;

reg [10:0] xpos_nxt, ypos_nxt;
signed reg [10:0] xspeed, xspeed_nxt, yspeed, yspeed_nxt;
reg [10:0] timer, timer_nxt;

always @(posedge pclk)
if(rst)
begin
    xpos <= 640;
    ypos <= 480;
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

always @(frame_ended)
begin
    xpos_nxt  = xpos + speed;
    ypos_nxt  = ypos + speed;
    xspeed_nxt = xspeed - 2;
    yspeed_nxt = yspeed - 2;
    case(key)
        ARROW_UP:
        begin
            yspeed_nxt = yspeed + 5;
        end
        ARROW_DOWN:
        begin
            yspeed_nxt = yspeed - 5;
        end
        ARROW_RIGHT:
        begin
            xspeed_nxt = xspeed + 5;
        end
        ARROW_LEFT:
        begin
            xspeed_nxt = xspeed - 5;
        end
        ARROW_UPLEFT:
        begin
            xspeed_nxt = xspeed - 5;
            yspeed_nxt = yspeed + 5;
        end
        ARROW_UPRIGHT:
        begin
            xspeed_nxt = xspeed + 5;
            yspeed_nxt = yspeed + 5;
        end
        ARROW_DOWNLEFT:
        begin
            xspeed_nxt = xspeed - 5;
            yspeed_nxt = yspeed - 5;
        end
        ARROW_DOWNRIGHT:
        begin
            xspeed_nxt = xspeed + 5;
            yspeed_nxt = yspeed - 5;
        end
    endcase
    if(xspeed >= SPEED_MAX) xspeed = SPEED_MAX;
    else if (xspeed <= SPEED_MIN) xspeed = SPEED_MIN;
    if(yspeed >= SPEED_MAX) yspeed = SPEED_MAX;
    else if (yspeed <= SPEED_MIN) yspeed = SPEED_MIN;
end

endmodule
