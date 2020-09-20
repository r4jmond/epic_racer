`timescale 1ns / 1ps
/******************************************************************************
 * (C) Copyright 2016 AGH UST All Rights Reserved
 *
 * MODULE:    bin2bcd
 * DEVICE:    general
 * PROJECT:   stopwatch
 *
 * ABSTRACT:  binary to BCD converter, three 8421 BCD digits
 *            Algorithm description:
 *            http://www.eng.utah.edu/~nmcdonal/Tutorials/BCDTutorial/BCDConversion.html
 *
 * HISTORY:
 * 1 Jan 2016, RS - initial version
 * 21 Jan 2020, DO - added bcd3(now it can convert 16b numbers)
 * 21 Jan 2020, DO - added minutes counter, minutes output; seconds reset after 60 seconds
 *
 *******************************************************************************/
module bin2bcd (
        input  wire [15:0] bin,  // input binary number
        output reg  [3:0]  bcd0, // LSB
        output reg  [3:0]  bcd1,
        output reg  [3:0]  bcd2,
        output reg  [3:0]  bcd3, //MSB
        output reg  [3:0]  minutes
    );
    
    reg [15:0] seconds;
    integer i;

    always @(bin)
    begin

        bcd0 = 0;
        bcd1 = 0;
        bcd2 = 0;
        bcd3 = 0;
        minutes = 0;
        seconds = bin;
        
        for ( i = 9; i >= 0; i = i - 1 )
        begin
            if ( seconds >= 6000  )
                begin
                    seconds = seconds - 6000;
                    minutes = minutes +1;
                    if(minutes >=10)
                    minutes = minutes-10;
                end
        end

        for ( i = 15; i >= 0; i = i - 1 )
        begin
            if( bcd0 > 4 ) bcd0 = bcd0 + 3;
            if( bcd1 > 4 ) bcd1 = bcd1 + 3;
            if( bcd2 > 4 ) bcd2 = bcd2 + 3;
            if( bcd3 > 4 ) bcd3 = bcd3 + 3;
            { bcd3[3:0], bcd2[3:0], bcd1[3:0], bcd0[3:0] } =
            { bcd3[2:0], bcd2[3:0], bcd1[3:0], bcd0[3:0], seconds[i] };
        end

    end

endmodule
