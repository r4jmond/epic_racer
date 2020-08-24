`timescale 1ns / 1ps

module draw_img
#(parameter
    RECT_WIDTH = 128,
    RECT_LENGTH = 128,
    ADDR_WIDTH = 14
)
(
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire pclk,
    input wire rst,
    input wire visible,
    input wire [1:0] rotation,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel,
    input wire [10:0] xpos,
    input wire [10:0] ypos,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg [ADDR_WIDTH-1:0] pixel_addr
);

localparam NO_ROTATION = 2'b00;
localparam ROTATE_90 = 2'b01;
localparam ROTATE_270 = 2'b11;
localparam ROTATE_180 = 2'b10;

reg [11:0] rgb_out_nxt;
reg [ADDR_WIDTH-1:0] pixel_addr_nxt;
reg [10:0] addrx, addry;
wire [10:0] vcount_delayed, hcount_delayed;
wire hsync_delayed, vsync_delayed, hblnk_delayed, vblnk_delayed;

always @(posedge pclk)
    if(rst)
    begin
        hcount_out <= 0;
        hsync_out <= 0;
        hblnk_out <= 0;
        vcount_out <= 0;
        vsync_out <= 0;
        vblnk_out <= 0;
        rgb_out <= 0;
        pixel_addr <= 0;
    end
    else
    begin
        hcount_out <= hcount_delayed;
        hsync_out <= hsync_delayed;
        hblnk_out <= hblnk_delayed;
        vcount_out <= vcount_delayed;
        vsync_out <= vsync_delayed;
        vblnk_out <= vblnk_delayed;
        rgb_out <= rgb_out_nxt;
        pixel_addr <= pixel_addr_nxt;
    end

always @*
begin
    case(rotation)
    NO_ROTATION:
    begin
        addrx = hcount_in - xpos;
        addry = vcount_in - ypos;
    end
    ROTATE_90:
    begin
        addrx = vcount_in - ypos;
        addry = hcount_in - xpos;
    end
    ROTATE_180:
    begin
        addrx = RECT_WIDTH - 1 - (hcount_in - xpos);
        addry = RECT_LENGTH - 1 - (vcount_in - ypos);
    end
    ROTATE_270:
    begin
        addrx = RECT_LENGTH - 1 - (vcount_in - ypos);
        addry = RECT_WIDTH - 1 - (hcount_in - xpos);
    end
    endcase
    rgb_out_nxt = rgb_in;
    pixel_addr_nxt = 0;
    
    if(visible)
    begin
        if(hcount_in >= xpos && hcount_in < (xpos + RECT_WIDTH) && vcount_in >= ypos && vcount_in < (ypos + RECT_LENGTH))
        begin
            if(rgb_pixel != 12'hfac) begin
                rgb_out_nxt = rgb_pixel;
            end
            pixel_addr_nxt = { (addry[(ADDR_WIDTH/2)-1:0]), (addrx[(ADDR_WIDTH/2)-1:0]) };
        end
    end
end

delay #(11, 2) hcount_delay(
 .clk(pclk),
 .rst(rst),
 .din(hcount_in),
 .dout(hcount_delayed)
);

delay #(11, 2) vcount_delay(
 .clk(pclk),
 .rst(rst),
 .din(vcount_in),
 .dout(vcount_delayed)
);

delay #(1,2) vsync_delay(
 .clk(pclk),
 .rst(rst),
 .din(vsync_in),
 .dout(vsync_delayed)
);

delay #(1,2) hsync_delay(
 .clk(pclk),
 .rst(rst),
 .din(hsync_in),
 .dout(hsync_delayed)
);

delay #(1,2) vblnk_delay(
 .clk(pclk),
 .rst(rst),
 .din(vblnk_in),
 .dout(vblnk_delayed)
);

delay #(1,2) hblnk_delay(
 .clk(pclk),
 .rst(rst),
 .din(hblnk_in),
 .dout(hblnk_delayed)
);

endmodule
