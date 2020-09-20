`timescale 1ns / 1ps

module main_fsm(
    input wire pclk,
    input wire rst,
    input wire btnR,
    input wire btnU,
    input wire btnD,
    input wire btnL,
    input wire [5:0] key,
    input wire [7:0] keycode,
    output reg game_visible,
    output reg title_screen_visible,
    output reg car_select_visible,
    output reg control_select_visible,
    output reg arrow_visible,
    output reg [3:0] controls,
    output reg [1:0] car_visible,
    output reg [10:0] nitro_avatar_xpos,
    output reg [10:0] nitro_avatar_ypos,
    output reg [10:0] rapid_avatar_xpos,
    output reg [10:0] rapid_avatar_ypos,
    output reg [10:0] arrow_xpos,
    output reg [10:0] arrow_ypos
    );

localparam TITLE_SCREEN = 3'b000;
localparam GAME = 3'b001;
localparam CAR_SELECT = 3'b011;
localparam CONTROL_SELECT = 3'b010;
localparam STATE_CHANGED = 3'b110;

localparam SELECTING_NITRO_CAR = 0;
localparam SELECTING_RAPID_CAR = 1;

localparam ARROW_ON_KEYBOARD = 0;
localparam ARROW_ON_BASYS = 1;

localparam NITRO_CAR_VISIBLE = 2'b01;
localparam RAPID_CAR_VISIBLE = 2'b10;

localparam NO_CONTROL = 2'b0;
localparam KEYBOARD = 2'b01;
localparam BASYS = 2'b11;

localparam KEY_UP = 6'b000001;
localparam KEY_DOWN = 6'b000010;
localparam KEY_LEFT = 6'b000100;
localparam KEY_RIGHT = 6'b001000;
localparam KEY_ENTER = 6'b010000;

localparam DELAY = 10000000;


reg choosing_car, choosing_car_nxt;
reg [1:0] control_arrow, control_arrow_nxt;
reg [3:0] state, state_nxt;
reg [1:0] car_visible_nxt;
reg [1:0] control, control_nxt;
reg car_select_visible_nxt, control_select_visible_nxt, arrow_visible_nxt, title_screen_visible_nxt, game_visible_nxt;
reg [10:0] arrow_xpos_nxt, arrow_ypos_nxt;
reg [25:0] menu_timer, menu_timer_nxt;
reg [10:0] nitro_avatar_xpos_nxt, nitro_avatar_ypos_nxt, rapid_avatar_xpos_nxt, rapid_avatar_ypos_nxt;
reg [3:0] next_state, next_state_nxt;
reg [1:0] next_control, next_control_nxt;

always@(*)
begin
    car_visible_nxt = car_visible;
    state_nxt = state;
    choosing_car_nxt = choosing_car;
    control_arrow_nxt = control_arrow;
    title_screen_visible_nxt = title_screen_visible;
    game_visible_nxt = game_visible;
    control_select_visible_nxt = control_select_visible;
    car_select_visible_nxt = car_select_visible;
    arrow_visible_nxt = arrow_visible;
    control_nxt = NO_CONTROL;
    nitro_avatar_xpos_nxt = 240;
    nitro_avatar_ypos_nxt = 370;
    rapid_avatar_xpos_nxt = 640;
    rapid_avatar_ypos_nxt = 370;
    arrow_xpos_nxt = arrow_xpos; 
    arrow_ypos_nxt = arrow_ypos;
    menu_timer_nxt = 0;
    next_state_nxt = next_state;
    next_control_nxt = next_control;
    
    case(state)
    TITLE_SCREEN:
    begin
        control_nxt = NO_CONTROL;
        title_screen_visible_nxt = 1;
        game_visible_nxt = 0;
        control_select_visible_nxt = 0;
        car_select_visible_nxt = 0;
        arrow_visible_nxt = 0;

        if((btnU || btnD || btnL || btnR || keycode)) 
        begin
            next_state_nxt = CAR_SELECT;
            state_nxt = STATE_CHANGED;
        end
        else state_nxt = TITLE_SCREEN;
    end
    CAR_SELECT:
    begin
        choosing_car_nxt = choosing_car;
        title_screen_visible_nxt = 0;
        game_visible_nxt = 0;
        control_select_visible_nxt = 0;
        car_select_visible_nxt = 1;
        arrow_visible_nxt = 0;
        control_nxt = NO_CONTROL;
        
        if((btnU || (key == KEY_ENTER)))
        begin
            next_state_nxt = CONTROL_SELECT;
            state_nxt = STATE_CHANGED;
        end
        else state_nxt = CAR_SELECT;

        case(choosing_car)         
        SELECTING_NITRO_CAR:
        begin
            arrow_xpos_nxt = 270; 
            arrow_ypos_nxt = 480; 
            arrow_visible_nxt = 1;
            if (btnU || key == KEY_ENTER) car_visible_nxt = NITRO_CAR_VISIBLE;
            else if(btnR || key == KEY_RIGHT) choosing_car_nxt = SELECTING_RAPID_CAR;
        end
        SELECTING_RAPID_CAR:
        begin
             arrow_xpos_nxt = 670;
             arrow_ypos_nxt = 480;
             arrow_visible_nxt = 1;
             if (btnU || key == KEY_ENTER) car_visible_nxt = RAPID_CAR_VISIBLE;
             else if(btnL || key == KEY_LEFT) choosing_car_nxt = SELECTING_NITRO_CAR;
        end
        default:
        begin
            arrow_xpos_nxt = 0;
            arrow_ypos_nxt = 0;
            arrow_visible_nxt = 0;
            car_visible_nxt = car_visible;
        end
        endcase
    end
           
    CONTROL_SELECT:
    begin
        control_nxt = NO_CONTROL;
        title_screen_visible_nxt = 0;
        game_visible_nxt = 0;
        control_select_visible_nxt = 1;
        car_select_visible_nxt = 0;

        if(btnU || (key == KEY_ENTER))
        begin
            next_state_nxt = GAME;
            state_nxt = STATE_CHANGED;
        end
        else state_nxt = CONTROL_SELECT;
        
        case(control_arrow)
            ARROW_ON_KEYBOARD:
            begin
                arrow_xpos_nxt = 256; 
                arrow_ypos_nxt = 576; 
                arrow_visible_nxt = 1;
                if((btnU || (key == KEY_ENTER))) next_control_nxt = KEYBOARD;
                else if(btnR || (key == KEY_RIGHT)) control_arrow_nxt = ARROW_ON_BASYS;
            end
            ARROW_ON_BASYS:
            begin
                arrow_xpos_nxt = 640;
                arrow_ypos_nxt = 576;
                arrow_visible_nxt = 1;
                if ((btnU || (key == KEY_ENTER))) next_control_nxt = BASYS;
                else if (btnL || key == KEY_LEFT) control_arrow_nxt = ARROW_ON_KEYBOARD;
            end
            default:
            begin
                arrow_xpos_nxt = 0;
                arrow_ypos_nxt = 0;
                arrow_visible_nxt = 0;
                control_nxt = NO_CONTROL;
                control_arrow_nxt = control_arrow;
            end
        endcase
    end
    GAME:
    begin
        car_visible_nxt = car_visible;
        control_nxt = control;
        title_screen_visible_nxt = 0;
        game_visible_nxt = 1;
        control_select_visible_nxt = 0;
        car_select_visible_nxt = 0;
        control_arrow_nxt = control_arrow;
        arrow_visible_nxt = 0;
        state_nxt = GAME;
    end                       
    STATE_CHANGED:
    begin
        control_nxt = NO_CONTROL;
        state_nxt = STATE_CHANGED;
        if(menu_timer < DELAY) menu_timer_nxt = menu_timer + 1;
        else
        begin
            menu_timer_nxt = 0;
            state_nxt = next_state;
            if(state_nxt == GAME) control_nxt = next_control;
        end
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
        car_visible <= 0;
        choosing_car <= 0;
        menu_timer <= 0;
        nitro_avatar_xpos <= 0;
        nitro_avatar_ypos <= 0;
        rapid_avatar_xpos <= 0;
        rapid_avatar_ypos <= 0;
        next_state <= 0;
        next_control <= 0;
    end
    else
    begin
        menu_timer <= menu_timer_nxt;
        state <= state_nxt;
        title_screen_visible <= title_screen_visible_nxt;
        car_select_visible <= car_select_visible_nxt;
        game_visible <= game_visible_nxt;
        control_select_visible <= control_select_visible_nxt;
        arrow_visible <= arrow_visible_nxt;
        arrow_xpos <= arrow_xpos_nxt; 
        arrow_ypos <= arrow_ypos_nxt;
        control <= control_nxt;
        control_arrow <= control_arrow_nxt;
        car_visible <= car_visible_nxt;
        choosing_car <= choosing_car_nxt;
        nitro_avatar_xpos <= nitro_avatar_xpos_nxt;
        nitro_avatar_ypos <= nitro_avatar_ypos_nxt;
        rapid_avatar_xpos <= rapid_avatar_xpos_nxt;
        rapid_avatar_ypos <= rapid_avatar_ypos_nxt;
        next_state <= next_state_nxt;
        next_control <= next_control_nxt;
        if(control == KEYBOARD) controls <= key[3:0];
        else if(control == BASYS) controls <= {btnR, btnL, btnD, btnU};
        else controls <= 0;
    end
      
endmodule

