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
    output reg bg_visible,
    output reg track_visible,
    output reg player_visible
    );

localparam INIT = 3'b000;
localparam IDLE = 3'b001;
localparam GAME = 3'b011;
localparam GAME_FINISHED = 3'b010;
reg [2:0] state, state_nxt;     
 
always@*
begin
    state_nxt = GAME;
    bg_visible = 0;
    track_visible = 0;
    player_visible = 0;
    case(state)
        IDLE:
        begin
            bg_visible = 1;
        end
        GAME:
        begin
            track_visible = 1;
            player_visible = 1;
        end
    endcase
end

always @(posedge pclk)
if(rst)
begin
    state <= 0;
end
else
begin
    state <= state_nxt;
end

endmodule
