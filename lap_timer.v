`timescale 1ns / 1ps

module lap_timer(
    input wire pclk,
    input wire rst,
    input wire lap_finished,
    input wire start,
    input wire stop,
    output wire [15:0] current_lap_time,
    output wire [15:0] last_lap_time,
    output wire [15:0] best_lap_time
);

wire clk100;
reg state, state_nxt;
wire [15:0] counter_bin;

clk_divider u_clk_divider_main(
    .pclk(clk100),
    .rst (rst),
    .clk_div (clk100)
);

timer u_timer(
    .clk (clk100), 
    .rst (rst),
    .lap_finished(lap_finished),
    .start (start),
    .stop (stop),
    .counter(counter_bin)
);

lap_time u_lap_time(
    .clk(clk100),
    .rst(rst),
    .lap_finished(lap_finished),
    .bin_in(counter_bin),
    .current_lap_time(current_lap_time),
    .last_lap_time(last_lap_time),
    .best_lap_time(best_lap_time)
);

endmodule
