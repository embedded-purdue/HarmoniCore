`timescale 1ns / 1ps

`include "../include/find_trough_if.vh"
`include "../include/types.sv"
import types::*;

parameter PERIOD = 10;

module find_trough_tb;

    //CLK gen
    logic clk = 0;
    always #(PERIOD/2) clk++;

    logic nrst;

    find_trough_if trif();
    find_trough DUT(.clk(clk), .nrst(nrst), .trif(trif));    

    task reset_dut;
        begin
            nrst = 1'b0;
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

    
    task rand_numbers_20;
    // logic [10:0] arr[20];
        begin
            int rand_num, i;
            // logic [10:0] arr_min;
            @(negedge clk);
            trif.enable = 1'b1;
            for (i = 0; i < FRAME_LEN - 2028; i++) begin
                
                rand_num = $urandom;  // get a random number
                $display("ind: %d lower 18 bits of rand_num (hex): %x, dec form: %d", i, rand_num[10:0], rand_num[10:0]);
                trif.yin_in = rand_num[10:0];
                // arr[i] = rand_num[10:0];
                // trif.count_out = i[10:0];
                // @(posedge clk);
                @(negedge clk);
            end
            trif.enable = 1'b0;
            // arr_min = arr.min()[0];
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            // assert(arr_min == min_yin) $display ("Found the min: %h", arr_min);
            //     else $error ("Expected min: %h, but got %h", arr_min, min_yin);
        
        end
    endtask

    task test_first_min;
        begin
            @(negedge clk);
            trif.enable = 1'b1;
            trif.yin_in = 18'h200;
            @(posedge clk);
            
            @(negedge clk);
            trif.yin_in = 18'h600;
            @(posedge clk);
            
            @(negedge clk);
            trif.yin_in = 18'h700;
            @(posedge clk);
            
            @(negedge clk);
            trif.yin_in = 18'h700;
            @(posedge clk);
            
            @(negedge clk);
            trif.yin_in = 18'h800;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h850;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h860;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h870;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h880;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h890;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h910;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h920;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h930;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h940;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h950;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h960;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h970;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h980;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h990;
            @(posedge clk);

            @(negedge clk);
            trif.yin_in = 18'h1000;
            @(posedge clk);

            @(negedge clk);
            trif.enable = 1'b0;
            @(posedge clk);  // finish previous cycle
            @(posedge clk); // first stall cycle
            @(posedge clk); // second stall
        end
    endtask

    task test_second_last_min;
        begin
        @(negedge clk);
        trif.enable = 1'b1;
        trif.yin_in = 18'h200; // Start high
        @(posedge clk);
        
        // Samples 1-17: Values higher than the eventual minimum (200).
        @(negedge clk);
        trif.yin_in = 18'h500;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h600;
        @(posedge clk);
        
        @(negedge clk);
        trif.yin_in = 18'h700;
        @(posedge clk);
        
        @(negedge clk);
        trif.yin_in = 18'h700;
        @(posedge clk);
        
        @(negedge clk);
        trif.yin_in = 18'h800;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h850;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h860;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h870;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h880;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h890;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h910;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h920;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h930;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h940;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h950;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h960;
        @(posedge clk);

        @(negedge clk);
        trif.yin_in = 18'h970;
        @(posedge clk);

        // --- Sample 18 (The Global Minimum) ---
        // This is the 19th data point (if starting count at 1) or index 18 (if starting at 0).
        // If your test expects 20 samples total, this is the second-to-last sample.
        @(negedge clk);
        trif.yin_in = 18'h980; // New absolute minimum (lower than 200)
        @(posedge clk); 

        // --- Sample 19 (Final Sample) ---
        // This is the 20th data point (or index 19).
        @(negedge clk);
        trif.yin_in = 18'h160; // Value slightly higher than the minimum
        @(posedge clk);


            @(negedge clk);
            trif.enable = 1'b0;
            @(posedge clk);  // finish previous cycle
            @(posedge clk); // first stall cycle
            @(posedge clk); // second stall
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
        rand_numbers_20();
        rand_numbers_20();
        rand_numbers_20();

        test_first_min();
        test_second_last_min();
        // #(PERIOD);

        // assuming that I get an enable signal and a valid yin on the same cycle

        // curr = "Test Last Sample Min";
        // test_last_min();
        // #(PERIOD);
        // #(PERIOD);

        $finish;
    end
endmodule