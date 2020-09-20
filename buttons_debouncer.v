`timescale 1ns / 1ps

module buttons_debouncer(
    input wire clk,
    input wire btnR,
    input wire btnL,
    input wire btnD,
    input wire btnU,
    output wire btnR_D,
    output wire btnD_D,
    output wire btnL_D,
    output wire btnU_D
);
    
debouncer btnR_debouncer(
    .clk(clk),
    .I(btnR),
    .O(btnR_D)
);
debouncer btnL_debouncer(
    .clk(clk),
    .I(btnL),
    .O(btnL_D)
);
debouncer btnD_debouncer(
    .clk(clk),
    .I(btnD),
    .O(btnD_D)
);
debouncer btnU_debouncer(
    .clk(clk),
    .I(btnU),
    .O(btnU_D)
);

endmodule
