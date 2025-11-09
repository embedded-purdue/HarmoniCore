`timescale 1ns / 1ps

`include "../include/interpolater_if.vh"
`include "../include/types.sv"
import types::*;

parameter PERIOD = 10;

module interpolater_tb ();

    //CLK gen
    logic clk = 0;
    always #(PERIOD/2) clk++;


    interpolater_if intif();
    interpolater DUT( .intif(intif.interp)); 

    
    string curr;
    initial begin
        // $monitor("%0t min_yin: %h", $time, min_yin);
        curr = "RESET";

        intif.prev_yin = '0;
        intif.curr_yin = '0;
        intif.next_yin = '0;

        @(negedge clk);

        curr = "Random Numbers";

        intif.prev_yin = 18'hfffff;
        intif.curr_yin = '0;
        intif.next_yin = 18'hfffff;

        @(negedge clk)

        intif.prev_yin = 18'h0;
        intif.curr_yin = 18'hfffff;
        intif.next_yin = 18'h0;

        @(negedge clk)

        intif.prev_yin = 18'h1234;
        intif.curr_yin = 18'h1010;
        intif.next_yin = 18'h1988;
        
        #(PERIOD * 30);

        $finish;
    end
endmodule