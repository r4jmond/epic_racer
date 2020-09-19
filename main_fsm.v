`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.09.2020 13:29:37
// Design Name: 
// Module Name: menu
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
    input wire btnR,
    input wire btnU,
    input wire btnD,
    input wire btnL,
    output reg track_visible,
    output reg player_visible,
    output reg [1:0] title_screen_visible,
    output reg [1:0] car_select_visible,
    output reg [1:0] control_select_visible,
    output reg [1:0] arrow_visible,
    output reg [1:0] eco_car_visible,
    output reg [1:0] force_car_visible,
    output reg [1:0] nitro_car_visible,
    output reg [1:0] rapid_car_visible,
    output reg [1:0] control,
    output reg [3:0] car,
    output reg eco_car_xpos,
    output reg eco_car_ypos,
    output reg force_car_xpos,
    output reg force_car_ypos,
    output reg nitro_car_xpos,
    output reg nitro_car_ypos,
    output reg rapid_car_xpos,
    output reg rapid_car_ypos,
    output reg arrow_xpos,
    output reg arrow_ypos,
    output reg lap_timer_start
    );
    
localparam KEY_UP = 6'b000001;
localparam KEY_DOWN = 6'b000010;
localparam KEY_LEFT = 6'b000100;
localparam KEY_RIGHT = 6'b001000;
localparam KEY_ENTER = 6'b010000;
localparam KEY_ESC = 6'b100000;
    
localparam NULL = 6'b000000;

    
localparam GAME = 2'b01;
localparam TITLE_SCREEN = 2'b00;
localparam CAR_SELECT = 2'b11;
localparam CONTROL_SELECT = 2'b10;

localparam ARROW_ON_ECO_CAR = 3'b001;
localparam ARROW_ON_FORCE_CAR = 3'b010;
localparam ARROW_ON_NITRO_CAR = 3'b011;
localparam ARROW_ON_RAPID_CAR = 3'b100;

localparam ARROW_ON_KEYBOARD = 1'b0;
localparam ARROW_ON_BASYS = 1'b1;

localparam ECO_CAR = 4'b0001;
localparam FORCE_CAR = 4'b0010;
localparam NITRO_CAR = 4'b0011;
localparam RAPID_CAR = 4'b0100;
localparam KEYBOARD = 4'b0101;
localparam BASYS = 4'b0110;
localparam INIT = 0 ; 

reg [3:0] car_arrow, car_arrow_nxt;
reg [1:0] control_arrow, control_arrow_nxt;
reg [3:0] state, state_nxt;
reg [3:0] car_nxt;
reg [1:0] control_nxt;
reg [1:0] car_select_visible_nxt, control_select_visible_nxt,arrow_visible_nxt, title_screen_visible_nxt, track_visible_nxt, player_visible_nxt;
reg [1:0] eco_car_visible_nxt, rapid_car_visible_nxt, nitro_car_visible_nxt, force_car_visible_nxt;
reg arrow_xpos_nxt, arrow_ypos_nxt;
reg  eco_car_xpos_nxt, eco_car_ypos_nxt, rapid_car_xpos_nxt, rapid_car_ypos_nxt, force_car_xpos_nxt, force_car_ypos_nxt, nitro_car_xpos_nxt, nitro_car_ypos_nxt;
reg lap_timer_start_nxt;

always@(*)
    begin
        car_nxt = car;
        state_nxt=TITLE_SCREEN;
        control_arrow_nxt=control_arrow;
        car_arrow_nxt=car_arrow;
        control_nxt = control;
        lap_timer_start_nxt = lap_timer_start;
        title_screen_visible_nxt = title_screen_visible;
        track_visible_nxt = track_visible;
        player_visible_nxt = player_visible;
        control_select_visible_nxt = control_select_visible;
        car_select_visible_nxt = car_select_visible;
        arrow_visible_nxt = arrow_visible;
        eco_car_visible_nxt = eco_car_visible;
        rapid_car_visible_nxt = rapid_car_visible;
        nitro_car_visible_nxt = nitro_car_visible;
        force_car_visible_nxt = force_car_visible;
        eco_car_xpos_nxt = eco_car_xpos;
        eco_car_ypos_nxt = eco_car_ypos;
        force_car_xpos_nxt = force_car_xpos;
        force_car_ypos_nxt = force_car_ypos;
        nitro_car_xpos_nxt = nitro_car_xpos;
        nitro_car_ypos_nxt = nitro_car_ypos;
        rapid_car_xpos_nxt = rapid_car_xpos;
        rapid_car_ypos_nxt = rapid_car_ypos;
        arrow_xpos_nxt = arrow_xpos; 
        arrow_ypos_nxt = arrow_ypos; 
        case(state)

        	
            TITLE_SCREEN:
                begin
                 car_arrow_nxt=0;
                 control_nxt = 0;
                 lap_timer_start_nxt = 0;
                 title_screen_visible_nxt = 1;
                 track_visible_nxt = 0;
                 player_visible_nxt = 0;
                 control_select_visible_nxt = 0;
                 car_select_visible_nxt = 0;
                 arrow_visible_nxt = 0;
                 eco_car_visible_nxt = 0;
                 rapid_car_visible_nxt = 0;
                 nitro_car_visible_nxt = 0;
                 force_car_visible_nxt = 0;
 
                    if(btnU) 
                        state_nxt = CAR_SELECT;
                    else 
                        state_nxt = TITLE_SCREEN;   
                         


            end
            CAR_SELECT:
                begin
                car_arrow_nxt=0;
                control_nxt = 0;
                lap_timer_start_nxt = 0;
                title_screen_visible_nxt = 0;
                track_visible_nxt = 0;
                player_visible_nxt = 0;
                control_select_visible_nxt = 0;
                car_select_visible_nxt = 1;
                arrow_visible_nxt = 0;
                eco_car_visible_nxt = 1;
                rapid_car_visible_nxt = 1;
                nitro_car_visible_nxt = 1;
                force_car_visible_nxt = 1;
                if(btnU)
                    state_nxt = CONTROL_SELECT;
                else
                    state_nxt = CAR_SELECT;    
                                
                 eco_car_xpos_nxt = 0;
                 eco_car_ypos_nxt = 0;
                 force_car_xpos_nxt = 0;
                 force_car_ypos_nxt = 0;
                 nitro_car_xpos_nxt = 0;
                 nitro_car_ypos_nxt = 0;
                 rapid_car_xpos_nxt = 768;
                 rapid_car_ypos_nxt = 384;
                 if (btnL) 
                      car_arrow_nxt = ARROW_ON_ECO_CAR;               
                      case(car_arrow)
                        ARROW_ON_ECO_CAR:                        
                        begin
                            arrow_xpos_nxt = 208; 
                            arrow_ypos_nxt = 480; 
                            arrow_visible_nxt = 1'b1;
                            if (btnU)
                                car_nxt = ECO_CAR;
                            else if(btnR)
                                car_arrow_nxt = ARROW_ON_FORCE_CAR;
                        end
                        ARROW_ON_FORCE_CAR:
                        begin
                            arrow_xpos_nxt = 400; 
                            arrow_ypos_nxt = 480; 
                            arrow_visible_nxt = 1'b1;
                            if  (btnU)
                                car_nxt = FORCE_CAR;
                             else if (btnR)
                                car_arrow_nxt = ARROW_ON_NITRO_CAR;
                        end
                        ARROW_ON_NITRO_CAR:
                        begin
                            arrow_xpos_nxt = 592; 
                            arrow_ypos_nxt = 480; 
                            arrow_visible_nxt = 1'b1;
                            if (btnU)
                                 car_nxt = NITRO_CAR;
                            else if(btnR)
                                 car_arrow_nxt = ARROW_ON_RAPID_CAR;
                        end
                        ARROW_ON_RAPID_CAR:
                        begin
                             arrow_xpos_nxt = 208; 
                             arrow_ypos_nxt = 480; 
                             arrow_visible_nxt = 1'b1;
                             if (btnU)
                                 car_nxt = RAPID_CAR;
                             else if(btnR)
                                 car_arrow_nxt = ARROW_ON_ECO_CAR;
                        end
                      endcase
                   

                   end
                   
               CONTROL_SELECT:
                    begin
                    car_arrow_nxt=0;
                    control_nxt = 0;
                    lap_timer_start_nxt = 0;
                    title_screen_visible_nxt = 0;
                    track_visible_nxt = 0;
                    player_visible_nxt = 0;
                    control_select_visible_nxt = 1;
                    car_select_visible_nxt = 0;
                    arrow_visible_nxt = 0;
                    eco_car_visible_nxt = 0;
                    rapid_car_visible_nxt = 0;
                    nitro_car_visible_nxt = 0;
                    force_car_visible_nxt = 0;
                    if(btnU)
                    state_nxt = GAME;
                    else 
                    state_nxt = CONTROL_SELECT;

                   case(control_arrow)
                             ARROW_ON_KEYBOARD:
                             begin
                                 arrow_xpos_nxt = 256; 
                                 arrow_ypos_nxt = 576; 
                                 arrow_visible_nxt = 1'b1;
                                 if (btnU)
                                    control_nxt = KEYBOARD;
                                 else if(btnR)
                                    control_arrow_nxt = ARROW_ON_BASYS;
                             end
                             ARROW_ON_BASYS:
                             begin
                                 arrow_xpos_nxt = 640; 
                                 arrow_ypos_nxt = 576; 
                                  arrow_visible_nxt = 1'b1;
                                  if (btnU)
                                     control_nxt = BASYS;
                                  else if (btnR)
                                     control_arrow_nxt = ARROW_ON_KEYBOARD;
                             end
                       endcase
                       

                    end
                GAME:
                    begin
                    car_arrow_nxt=0;
                    control_nxt = 0;
                    lap_timer_start_nxt = 1;
                    title_screen_visible_nxt = 0;
                    track_visible_nxt = 1;
                    player_visible_nxt = 1;
                    control_select_visible_nxt = 0;
                    car_select_visible_nxt = 0;
                    arrow_visible_nxt = 0;
                    eco_car_visible_nxt = 0;
                    rapid_car_visible_nxt = 0;
                    nitro_car_visible_nxt = 0;
                    force_car_visible_nxt = 0;
                    if (btnU)
                    state_nxt = TITLE_SCREEN;
                    else 
                    state_nxt = GAME;


                    end                       
            endcase            
            if(rst) state_nxt = TITLE_SCREEN;      
      end 
      
 always @(posedge pclk)
      begin
          state <= state_nxt;
          lap_timer_start <= lap_timer_start_nxt;
          title_screen_visible <= title_screen_visible_nxt;
          car_select_visible <= car_select_visible_nxt ;
          track_visible <= track_visible_nxt;
          player_visible <= player_visible_nxt;
          control_select_visible <= control_select_visible_nxt ;
          arrow_visible <= arrow_visible_nxt ;
          eco_car_visible <= eco_car_visible_nxt;
          rapid_car_visible <= rapid_car_visible_nxt;
          nitro_car_visible <= nitro_car_visible_nxt;
          force_car_visible <= force_car_visible_nxt;
          arrow_xpos <= arrow_xpos_nxt; 
          arrow_ypos <= arrow_ypos_nxt;
          control <= control_nxt;
          control_arrow <= control_arrow_nxt;
          car <= car_nxt;
          eco_car_xpos <= eco_car_xpos_nxt;
          eco_car_ypos <= eco_car_ypos_nxt;
          force_car_xpos <= force_car_xpos_nxt ;
          force_car_ypos <= force_car_ypos_nxt;
          nitro_car_xpos <= nitro_car_xpos_nxt;
          nitro_car_ypos <= nitro_car_ypos_nxt;
          rapid_car_xpos <= rapid_car_xpos_nxt;
          rapid_car_ypos <= rapid_car_ypos_nxt;
      end
      
endmodule

