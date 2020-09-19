`timescale 1ns / 1ps

module lap_timer(
    input wire pclk,
    input wire rst,
    input wire lap_finished,
    input wire start,
    input wire stop,
    output reg [15:0] current_lap_time,
    output reg [15:0] last_lap_time,
    output reg [15:0] best_lap_time
);

reg [15:0] current_lap_time_nxt, last_lap_time_nxt, best_lap_time_nxt;
reg [9:0] counter1, counter1_nxt;
reg [9:0] counter1k, counter1k_nxt;

reg [1:0] state, state_nxt;

localparam MAX_LAP_TIME = 4000; //1 = 0.01s
reg max_time_exceeded, max_time_exceeded_nxt;

localparam RESET = 2'b00;
localparam IDLE = 2'b01;
localparam COUNT = 2'b11;
localparam LAP_FINISHED = 2'b10;

always@(posedge pclk)
begin
    if(rst)
    begin
        current_lap_time <= 0;
        counter1 <= 0;
        counter1k <= 0;
        max_time_exceeded <= 0;
        last_lap_time <= 0;          
        best_lap_time <= 0;
        state <= RESET;
    end
    else
    begin
        current_lap_time <= current_lap_time_nxt;
        counter1 <= counter1_nxt;
        counter1k <= counter1k_nxt;
        max_time_exceeded <= max_time_exceeded_nxt;
        last_lap_time <= last_lap_time_nxt;
        best_lap_time <= best_lap_time_nxt;
        state <= state_nxt;
    end
end

always@*
begin
    case(state)
    RESET:
    begin
        current_lap_time_nxt = 0;
        counter1_nxt = 0;
        counter1k_nxt = 0;
        last_lap_time_nxt = 0;
        best_lap_time_nxt = 0;
        max_time_exceeded_nxt = 0;
        if(start) state_nxt = COUNT;
        else state_nxt = IDLE;
    end
    IDLE:
    begin
        current_lap_time_nxt = current_lap_time;
        counter1_nxt = counter1;
        counter1k_nxt = counter1k;
        last_lap_time_nxt = last_lap_time;
        best_lap_time_nxt = best_lap_time;
        max_time_exceeded_nxt = max_time_exceeded;
        if(start) state_nxt = COUNT;
        else state_nxt = IDLE;
    end
    COUNT:
    begin
        last_lap_time_nxt = last_lap_time;
        best_lap_time_nxt = best_lap_time;
        counter1_nxt = counter1;
        counter1k_nxt = counter1k;
        max_time_exceeded_nxt = max_time_exceeded;
        current_lap_time_nxt = current_lap_time;
        if(counter1 < 1000) counter1_nxt = counter1 + 1;
        else 
        begin
            counter1_nxt = 0;
            if(counter1k < 650) counter1k_nxt = counter1k + 1;
            else
            begin
                counter1k_nxt = 0;
                if(current_lap_time < MAX_LAP_TIME) current_lap_time_nxt = current_lap_time + 1;
                else 
                begin
                    current_lap_time_nxt = 0;
                    max_time_exceeded_nxt = 1;
                end
            end
        end
        if(stop) state_nxt = IDLE;
        else if(lap_finished) state_nxt = LAP_FINISHED;
        else state_nxt = COUNT;
    end
    LAP_FINISHED:
    begin
        if((current_lap_time > 100) && (max_time_exceeded == 0)) last_lap_time_nxt = current_lap_time;
        else last_lap_time_nxt = last_lap_time;
        if((best_lap_time == 0) && (max_time_exceeded == 0) && (current_lap_time > 100)) best_lap_time_nxt = current_lap_time;
        else if((current_lap_time < best_lap_time) && (max_time_exceeded == 0) && (current_lap_time > 100)) best_lap_time_nxt = current_lap_time;
        else best_lap_time_nxt = best_lap_time;
        current_lap_time_nxt = 0;
        counter1_nxt = 0;
        counter1k_nxt = 0;
        if(stop) state_nxt = IDLE;
        else state_nxt = COUNT;
    end
    default:
    begin
        current_lap_time_nxt = current_lap_time;
        last_lap_time_nxt = last_lap_time;
        best_lap_time_nxt = best_lap_time;
        state_nxt = state;
        counter1_nxt = counter1;
        counter1k_nxt = counter1k;
    end
    endcase
end


endmodule
