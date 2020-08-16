`timescale 1 ns / 1 ps

module xga_timing (
  input wire pclk,
  input wire rst,
  output reg [10:0] vcount,
  output wire vsync,
  output wire vblnk,
  output reg [10:0] hcount,
  output wire hsync,
  output wire hblnk,
  output wire frame_ended
);

parameter X_VISIBLE_AREA = 1024;
parameter X_FRONT_PORCH = 24;
parameter X_SYNC_PULSE = 136;
parameter X_BACK_PORCH = 160;
localparam X_WHOLE_LINE = X_VISIBLE_AREA + X_FRONT_PORCH + X_SYNC_PULSE + X_BACK_PORCH;

parameter Y_VISIBLE_AREA = 768;
parameter Y_FRONT_PORCH = 3;
parameter Y_SYNC_PULSE = 6;
parameter Y_BACK_PORCH = 29;
localparam Y_WHOLE_LINE = Y_VISIBLE_AREA + Y_FRONT_PORCH + Y_SYNC_PULSE + Y_BACK_PORCH;
  
reg [10:0] hcount_nxt;
reg [10:0] vcount_nxt;

always @(posedge pclk)
begin
    if(rst)
    begin
        hcount <= 0;
        vcount <= 0;
    end
    else
    begin
        hcount <= hcount_nxt;
        vcount <= vcount_nxt;
    end
end

always @*
begin
    if (hcount < (X_WHOLE_LINE - 1)) 
    begin
        hcount_nxt = hcount + 1;
        vcount_nxt = vcount;
    end
    else
    begin
        hcount_nxt = 0;
        if(vcount < (Y_WHOLE_LINE - 1)) vcount_nxt = vcount + 1;
        else
         vcount_nxt = 0;
    end
end

assign hsync = rst ? 0 : ((hcount > (X_VISIBLE_AREA + X_FRONT_PORCH - 1)) && (hcount < (X_WHOLE_LINE - X_BACK_PORCH)));
assign hblnk = rst ? 0 : (hcount > (X_VISIBLE_AREA - 1));
assign vsync = rst ? 0 : ((vcount > (Y_VISIBLE_AREA + Y_FRONT_PORCH - 1)) && (vcount < (Y_WHOLE_LINE - Y_BACK_PORCH)));
assign vblnk = rst ? 0 : (vcount > (Y_VISIBLE_AREA - 1));
assign frame_ended = rst ? 0 : (vcount == 0);
endmodule
