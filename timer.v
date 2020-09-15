`timescale 1ns / 1ps
/******************************************************************************
 * (C) Copyright 2016 AGH UST All Rights Reserved
 *
 * MODULE:    timer
 * DEVICE:    general
 * PROJECT:   epic_racer
 *
 * ABSTRACT:  This counter is the core of the stopwatch.
 *
 * HISTORY:
 * 1 Jan 2016, RS - initial version
 * 21 Jan 2020, DO - increased counter size to 16 bits
 *
 *******************************************************************************/
module timer (
        input  wire        clk,    // posedge active clock
        input  wire        rst,    // sync reset active HIGH
        input  wire        lap_finished,
        input  wire        start,  // when 1 counter starts counting
        input  wire        stop,   // when 1 counter stops counting
        output reg  [15:0] counter
    ) ;

    localparam
    STATE_IDLE  = 1'b0,
    STATE_COUNT = 1'b1;

    reg        state;
    reg        state_nxt;

    always @(posedge clk)
        if(rst)
            state <= #1 STATE_IDLE;
        else
            state <= #1 state_nxt;

    always @*
        case({start,stop})
            2'b00: state_nxt   = state;
            2'b10: state_nxt   = STATE_COUNT;
            2'b01: state_nxt   = STATE_IDLE;
            default: state_nxt = state; // do nothing when two buttons pressed
        endcase


    reg [15:0] counter_nxt;

    always @(posedge clk)
        if(rst)
            counter <= #1 0;
        else
            counter <= #1 counter_nxt;

    always @*
        case(state)
            STATE_IDLE: counter_nxt  = counter;
            STATE_COUNT: counter_nxt = lap_finished ? 0 : counter + 1;
        endcase

endmodule
