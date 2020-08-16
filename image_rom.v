module image_rom 
#(parameter
    IMG_WIDTH = 128,
    IMG_HEIGHT = 128,
    ADDR_WIDTH = 14,
    IMG_PATH = ""
) 
(
    input wire clk ,
    input wire [ADDR_WIDTH-1:0] address,
    output reg [11:0] rgb_out
);

localparam ROM_DEPTH = IMG_WIDTH * IMG_HEIGHT;

reg [ADDR_WIDTH-1:0] rom [0:(ROM_DEPTH - 1)];
initial $readmemh(IMG_PATH, rom);

always @(posedge clk)
    rgb_out <= rom[address];

endmodule
