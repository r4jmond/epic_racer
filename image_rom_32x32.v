
module image_rom_32x32 (
    input wire clk ,
    input wire [9:0] address,  // address = {addry[11:0], addrx[11:0]}
    output reg [11:0] rgb_out
);

parameter IMG_WIDTH = 32;
parameter IMG_HEIGHT = 32;
parameter IMG_PATH = "";
localparam ROM_DEPTH = IMG_WIDTH * IMG_HEIGHT;

reg [9:0] rom [0:(ROM_DEPTH - 1)];
initial $readmemh(IMG_PATH, rom);

always @(posedge clk)
    rgb_out <= rom[address];

endmodule
