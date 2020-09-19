`timescale 1ns / 1ps

module main_fsm(
    input wire pclk,
    input wire rst,
    input wire btnR,
    input wire btnU,
    input wire btnD,
    input wire btnL,
    output reg game_visible,
    //output reg player_visible,
    output reg title_screen_visible,
    output reg car_select_visible,
    output reg control_select_visible,
    output reg arrow_visible,
    output reg control,
    output reg [3:0] car,
    output wire [21:0] eco_car_pos,
    //output reg eco_car_ypos,
    output wire [21:0] force_car_pos,
    //output wire force_car_ypos,
    output wire [21:0] nitro_car_pos,
    //output wire nitro_car_ypos,
    output wire [21:0] rapid_car_pos,
    //output wire rapid_car_ypos,
    output reg [10:0] arrow_xpos,
    output reg [10:0] arrow_ypos
    );

localparam GAME = 2'b01;
localparam TITLE_SCREEN = 2'b00;
localparam CAR_SELECT = 2'b11;
localparam CONTROL_SELECT = 2'b10;

localparam ARROW_ON_ECO_CAR = 3'b001;
localparam ARROW_ON_FORCE_CAR = 3'b010;
localparam ARROW_ON_NITRO_CAR = 3'b011;
localparam ARROW_ON_RAPID_CAR = 3'b111;

localparam ARROW_ON_KEYBOARD = 0;
localparam ARROW_ON_BASYS = 1;

localparam ECO_CAR = 4'b0001;
localparam FORCE_CAR = 4'b0010;
localparam NITRO_CAR = 4'b0011;
localparam RAPID_CAR = 4'b0100;

localparam KEYBOARD = 1'b1;
localparam BASYS = 1'b0;


reg [3:0] car_arrow, car_arrow_nxt;
reg [1:0] control_arrow, control_arrow_nxt;
reg [3:0] state, state_nxt;
reg [3:0] car_nxt;
reg control_nxt;
reg car_select_visible_nxt, control_select_visible_nxt, arrow_visible_nxt, title_screen_visible_nxt, game_visible_nxt;
//reg eco_car_visible_nxt, rapid_car_visible_nxt, nitro_car_visible_nxt, force_car_visible_nxt;
reg [10:0] arrow_xpos_nxt, arrow_ypos_nxt;
//reg eco_car_xpos_nxt, eco_car_ypos_nxt, rapid_car_xpos_nxt, rapid_car_ypos_nxt, force_car_xpos_nxt, force_car_ypos_nxt, nitro_car_xpos_nxt, nitro_car_ypos_nxt;
reg lap_timer_start_nxt;

assign eco_car_pos [21:10] = 11'd192; //xpos [21:0]
assign eco_car_pos [10:0] = 11'd384; //ypos [10:0]
assign force_car_pos [21:10] = 11'd384;
assign force_car_pos [10:0] = 11'd384;
assign nitro_car_pos [21:10] = 11'd576;
assign nitro_car_pos [10:0] = 11'd384;
assign rapid_car_pos [21:10] = 11'd768;
assign rapid_car_pos [10:0] = 11'd384;

always@(*)
begin
    car_nxt = car;
    state_nxt = state;
    control_arrow_nxt = control_arrow;
    car_arrow_nxt = car_arrow;
    control_nxt = control;
    title_screen_visible_nxt = title_screen_visible;
    game_visible_nxt = game_visible;
    //player_visible_nxt = player_visible;
    control_select_visible_nxt = control_select_visible;
    car_select_visible_nxt = car_select_visible;
    arrow_visible_nxt = arrow_visible;
    /*eco_car_visible_nxt = eco_car_visible;
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
    rapid_car_ypos_nxt = rapid_car_ypos;*/
    arrow_xpos_nxt = arrow_xpos; 
    arrow_ypos_nxt = arrow_ypos;
    
    case(state)
    TITLE_SCREEN:
    begin
        car_arrow_nxt = 0;
        control_nxt = 0;
        title_screen_visible_nxt = 1;
        game_visible_nxt = 0;
        //player_visible_nxt = 0;
        control_select_visible_nxt = 0;
        car_select_visible_nxt = 0;
        arrow_visible_nxt = 0;
        /*eco_car_visible_nxt = 0;
        rapid_car_visible_nxt = 0;
        nitro_car_visible_nxt = 0;
        force_car_visible_nxt = 0;*/
        if(btnU) state_nxt = CAR_SELECT;
        else state_nxt = TITLE_SCREEN;
    end
    CAR_SELECT:
    begin
        car_arrow_nxt = car_arrow;
        control_nxt = control;
        title_screen_visible_nxt = 0;
        game_visible_nxt = 0;
       // player_visible_nxt = 0;
        control_select_visible_nxt = 0;
        car_select_visible_nxt = 1;
        arrow_visible_nxt = 0;
    /*eco_car_visible_nxt = 1;
    rapid_car_visible_nxt = 1;
    nitro_car_visible_nxt = 1;
    force_car_visible_nxt = 1;*/    
     /*eco_car_xpos_nxt = 0;
     eco_car_ypos_nxt = 0;
     force_car_xpos_nxt = 0;
     force_car_ypos_nxt = 0;
     nitro_car_xpos_nxt = 0;
     nitro_car_ypos_nxt = 0;
     rapid_car_xpos_nxt = 768;
     rapid_car_ypos_nxt = 384;*/
        if(btnU) state_nxt = CONTROL_SELECT;
        else state_nxt = CAR_SELECT;      
        if (btnR) car_arrow_nxt = ARROW_ON_ECO_CAR;
        case(car_arrow)
        ARROW_ON_ECO_CAR:                        
        begin
            arrow_xpos_nxt = 208; 
            arrow_ypos_nxt = 480; 
            arrow_visible_nxt = 1;
            if (btnU) car_nxt = ECO_CAR;
            else if(btnR) car_arrow_nxt = ARROW_ON_FORCE_CAR;
        end
        ARROW_ON_FORCE_CAR:
        begin
            arrow_xpos_nxt = 400; 
            arrow_ypos_nxt = 480; 
            arrow_visible_nxt = 1;
            if(btnU) car_nxt = FORCE_CAR;
            else if (btnR) car_arrow_nxt = ARROW_ON_NITRO_CAR;
        end
        ARROW_ON_NITRO_CAR:
        begin
            arrow_xpos_nxt = 592; 
            arrow_ypos_nxt = 480; 
            arrow_visible_nxt = 1;
            if (btnU) car_nxt = NITRO_CAR;
            else if(btnR) car_arrow_nxt = ARROW_ON_RAPID_CAR;
        end
        ARROW_ON_RAPID_CAR:
        begin
             arrow_xpos_nxt = 780;
             arrow_ypos_nxt = 480;
             arrow_visible_nxt = 1;
             if (btnU) car_nxt = RAPID_CAR;
             else if(btnR) car_arrow_nxt = ARROW_ON_ECO_CAR;
        end
        default:
        begin
            arrow_xpos_nxt = 0;
            arrow_ypos_nxt = 0;
            arrow_visible_nxt = 0;
            car_nxt = car;
            car_arrow_nxt = 0;
        end
        endcase
    end
           
    CONTROL_SELECT:
    begin
        car_arrow_nxt = 0;
        control_nxt = control;
        lap_timer_start_nxt = 0;
        title_screen_visible_nxt = 0;
        game_visible_nxt = 0;
        //player_visible_nxt = 0;
        control_select_visible_nxt = 1;
        car_select_visible_nxt = 0;
        arrow_visible_nxt = 0;
        if(btnU) state_nxt = GAME;
        else state_nxt = CONTROL_SELECT;
        case(control_arrow)
            ARROW_ON_KEYBOARD:
            begin
                arrow_xpos_nxt = 256; 
                arrow_ypos_nxt = 576; 
                arrow_visible_nxt = 1;
                if(btnU) control_nxt = KEYBOARD;
                else if(btnR) control_arrow_nxt = ARROW_ON_BASYS;
            end
            ARROW_ON_BASYS:
            begin
                arrow_xpos_nxt = 640; 
                arrow_ypos_nxt = 576; 
                arrow_visible_nxt = 1;
                if (btnU) control_nxt = BASYS;
                else if (btnR) control_arrow_nxt = ARROW_ON_KEYBOARD;
            end
        endcase
    end
    GAME:
    begin
        car_arrow_nxt = 0;
        control_nxt = 0;
        //lap_timer_start_nxt = 1;
        title_screen_visible_nxt = 0;
        game_visible_nxt = 1;
        control_select_visible_nxt = 0;
        car_select_visible_nxt = 0;
        arrow_visible_nxt = 0;
        /*eco_car_visible_nxt = 0;
        rapid_car_visible_nxt = 0;
        nitro_car_visible_nxt = 0;
        force_car_visible_nxt = 0;*/
        state_nxt = GAME;
    end                       
    endcase
end 
      
 always @(posedge pclk)
    if(rst)
    begin
        state <= TITLE_SCREEN;
        title_screen_visible <= 0;
        car_select_visible <= 0;
        game_visible <= 0;
        control_select_visible <= 0;
        arrow_visible <= 0;
        arrow_xpos <= 0;
        arrow_ypos <= 0;
        control <= 0;
        control_arrow <= 0;
        car <= 0;
        car_arrow <= 0;
    end
    else
    begin
        state <= state_nxt;
        //lap_timer_start <= lap_timer_start_nxt;
        title_screen_visible <= title_screen_visible_nxt;
        car_select_visible <= car_select_visible_nxt;
        game_visible <= game_visible_nxt;
        control_select_visible <= control_select_visible_nxt;
        arrow_visible <= arrow_visible_nxt;
        /*eco_car_visible <= eco_car_visible_nxt;
        rapid_car_visible <= rapid_car_visible_nxt;
        nitro_car_visible <= nitro_car_visible_nxt;
        force_car_visible <= force_car_visible_nxt;*/
        arrow_xpos <= arrow_xpos_nxt; 
        arrow_ypos <= arrow_ypos_nxt;
        control <= control_nxt;
        control_arrow <= control_arrow_nxt;
        car <= car_nxt;
        car_arrow <= car_arrow_nxt;
        /*eco_car_xpos <= eco_car_xpos_nxt;
        eco_car_ypos <= eco_car_ypos_nxt;
        force_car_xpos <= force_car_xpos_nxt;
        force_car_ypos <= force_car_ypos_nxt;
        nitro_car_xpos <= nitro_car_xpos_nxt;
        nitro_car_ypos <= nitro_car_ypos_nxt;
        rapid_car_xpos <= rapid_car_xpos_nxt;
        rapid_car_ypos <= rapid_car_ypos_nxt;*/
    end
      
endmodule

