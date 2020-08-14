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
    input wire [3:0] key,
    output reg [10:0] xpos,
    output reg [10:0] ypos
);

localparam SPEED_MAX = 2137;
localparam SPEED_MIN = -2137;

reg [10:0] xpos_nxt, ypos_nxt;
reg [10:0] speed, speed_nxt;

always @(posedge pclk)
if(rst)
begin
    xpos <= 0;
    ypos <= 0;
    timer <= 0;
end
else
begin
    xpos <= xpos_nxt;
    ypos <= ypos_nxt;
    timer <= timer_nxt;
end

always @*
begin
    speed_nxt = speed;
    xpos_nxt  = xpos + x_speed;
    ypos_nxt  = ypos;
    case(key)
        ARROW_UP:
            xspeed_nxt = xspeed + 1;
            xpos_nxt  = xpos + speed;
    endcase
end

endmodule
