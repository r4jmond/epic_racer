`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.08.2020 12:16:07
// Design Name: 
// Module Name: main_fsm
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


module main_fsm(
    input wire pclk,
    input wire rst,
    output reg splash_visible,
    output reg car_select_visible,
    output reg control_select_visible,
    output reg track_visible,
    output reg player_visible
);

localparam INIT = 3'b000;
localparam CAR_SELECT = 3'b001;
localparam CONTROL_SELECT = 3'b011;
localparam GAME = 3'b010;
reg [2:0] state, state_nxt;     
reg splash_visible_nxt, car_select_visible_nxt, control_select_visible_nxt, track_visible_nxt, player_visible_nxt;
 
always@*
begin

    state_nxt = GAME;
    splash_visible_nxt = 0;
    track_visible_nxt = 0;
    player_visible_nxt = 0;
    car_select_visible_nxt = 0;
    control_select_visible_nxt = 0;
    
    case(state)
        INIT: splash_visible_nxt = 1;
        CAR_SELECT: car_select_visible_nxt = 1;
        CONTROL_SELECT: control_select_visible_nxt = 1;
        GAME:
        begin
            track_visible_nxt = 1;
            player_visible_nxt = 1;
        end
    endcase
end

always @(posedge pclk)
if(rst)
begin
    state <= INIT;
    splash_visible <= 0;
    car_select_visible <= 0;
    control_select_visible <= 0;
    track_visible <= 0;
    player_visible <= 0;
end
else
begin
    state <= state_nxt;
    splash_visible <= splash_visible_nxt;
    car_select_visible <= car_select_visible_nxt;
    control_select_visible <= control_select_visible_nxt;
    track_visible <= track_visible_nxt;
    player_visible <= player_visible_nxt;
end

endmodule
