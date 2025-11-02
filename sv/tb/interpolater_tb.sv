`timescale 1ns / 1ps

`include "../include/interpolater_if.vh"
`include "../include/types.sv"
import types::*;

parameter PERIOD = 10;

module interpolater_tb ();

    //CLK gen
    logic clk = 0;
    always #(PERIOD/2) clk++;

    logic nrst;

    interpolater_if intif();
    find_trough DUT(.clk(clk), .intif(intif.interp));    

    task reset_dut;
        begin
            rst = 1'b1;
            // trif.frame_done = 1'b0;
            trif.yin_in = 18'b0;
            // trif.count_out = 1'b0;
            trif.enable = 1'b0;
            @(posedge clk);
            @(posedge clk);
            @(negedge clk);
            nrst = 1'b1;
            @(posedge clk);
            @(posedge clk);
        end
    endtask

    task simple_calc;
        begin
            @(negedge clk);
            intif.trough_found = 1'b1;
            intif.next_yin = 18'h2;
            intif.curr_yin = 18'h4;
            intif.prev_yin = 18'h10;
            @(posedge clk);
            intif.trough_found = 1'b0;
            intif.next_yin = 18'h0;
            intif.curr_yin = 18'h0;
            intif.prev_yin = 18'h0;
        end
    endtask

    
    string curr;
    initial begin
        // $monitor("%0t min_yin: %h", $time, min_yin);
        curr = "RESET";
        nrst = 0;
        reset_dut();

        // curr = "Test Trough";
        // test_trough();
        // #(PERIOD);

        curr = "Random Numbers";
        simple_calc();
        #(PERIOD * 30);
        // #(PERIOD);

        // assuming that I get an enable signal and a valid yin on the same cycle

        // curr = "Test Last Sample Min";
        // test_last_min();
        // #(PERIOD);
        // #(PERIOD);

        $finish;
    end
endmodule