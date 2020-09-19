`timescale 1ns / 1ps

module checkpoints(
    input wire pclk,
    input wire rst,
    input wire [10:0] car_x_start, 
    input wire [10:0] car_x_end,
    input wire [10:0] car_y_start, 
    input wire [10:0] car_y_end,
    output reg lap_finished,
    output reg checkpoints_passed 
);

reg lap_finished_nxt, checkpoints_passed_nxt;
reg [5:0] checkpoints, checkpoints_nxt;

always@(posedge pclk)
begin
    if(rst)
    begin
        lap_finished <= 0;
        checkpoints_passed <= 0;
        checkpoints <= 0;
    end
    else
    begin
        lap_finished <= lap_finished_nxt;
        checkpoints_passed <= checkpoints_passed_nxt;
        checkpoints <= checkpoints_nxt;
    end
end

always@*
begin
    checkpoints_passed_nxt = 0;
    lap_finished_nxt = 0;
    checkpoints_nxt = checkpoints;
    
    if(checkpoints == 6'b111111) checkpoints_passed_nxt = 1;
    else checkpoints_passed_nxt = 0;
    
    if(car_x_start >= 506 && car_x_end <= 529 && car_y_end <= 160) 
    begin
        lap_finished_nxt = 1;
        checkpoints_nxt = 6'b0;
    end
    else 
    begin
        lap_finished_nxt = 0;
        checkpoints_nxt = checkpoints;
    end
    
    if(car_x_start >= 790 && car_x_end <= 912  && car_y_start >= 190 && car_y_end <= 215) checkpoints_nxt = checkpoints | 6'b000001;
    if(car_x_start >= 735 && car_x_end <= 760  && car_y_start >= 246 && car_y_end <= 450) checkpoints_nxt = checkpoints | 6'b000010;
    if(car_x_start >= 538 && car_x_end <= 565  && car_y_start >= 304 && car_y_end <= 512) checkpoints_nxt = checkpoints | 6'b000100;
    if(car_x_start >= 136 && car_x_end <= 268  && car_y_start >= 442 && car_y_end <= 470) checkpoints_nxt = checkpoints | 6'b001000;
    if(car_x_start >= 824 && car_x_end <= 1008 && car_y_start >= 628 && car_y_end <= 655) checkpoints_nxt = checkpoints | 6'b010000;
    if(car_x_start >= 48  && car_x_end <= 186  && car_y_start >= 424 && car_y_end <= 450) checkpoints_nxt = checkpoints | 6'b100000;
end

endmodule
