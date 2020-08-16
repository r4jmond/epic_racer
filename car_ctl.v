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
localparam ARROW_UP = 4'b0001;

reg [10:0] xpos_nxt, ypos_nxt;
reg [10:0] speed, speed_nxt;
reg [10:0] timer, timer_nxt;

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
    xpos_nxt  = xpos + speed;
    ypos_nxt  = ypos;
    case(key)
        ARROW_UP:
        begin
            speed_nxt = speed + 1;
            xpos_nxt  = xpos + speed;
        end
    endcase
end

endmodule
