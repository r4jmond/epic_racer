`timescale 1ns / 1ps

module lap_time(
    input   wire        clk,
    input   wire        rst,
    input   wire        lap_finished, //button, active high
    input   wire [15:0] bin_in, 
    output  reg  [15:0] current_lap_time,
    output  reg  [15:0] last_lap_time,
    output  reg  [15:0] best_lap_time
);
  
reg  [15:0] current_lap_time_nxt, last_lap_time_nxt, best_lap_time_nxt;

   
always @(posedge clk)
if(rst)
begin
    current_lap_time <= 0;
    last_lap_time <= 0;
    best_lap_time <= 0;
end
else
begin
    current_lap_time <= current_lap_time_nxt;
    last_lap_time <= last_lap_time_nxt;
    best_lap_time <= best_lap_time_nxt;
end

always @*
begin
    if(lap_finished) 
    begin
        current_lap_time_nxt = 0;
        last_lap_time_nxt = current_lap_time;
    end
    else
    begin
        current_lap_time_nxt = bin_in;
        last_lap_time_nxt = last_lap_time;
    end

    if(last_lap_time < best_lap_time) best_lap_time_nxt = last_lap_time;
    else best_lap_time_nxt = best_lap_time;
end
  
endmodule
