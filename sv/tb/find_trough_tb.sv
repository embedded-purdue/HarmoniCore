`timescale 1ns / 1ps

`include "../include/find_trough_if.vh"
`include "../include/types.sv"
import types::*;

parameter PERIOD = 10;

module find_trough_tb;

    //CLK gen
    logic clk = 0;
    always #(PERIOD/2) clk++;

    logic rst;
    string curr;

    find_trough_if trif();
    find_trough DUT(.clk(clk), .rst(rst), .trif(trif));    

    task reset_dut;
        begin
            rst = 1'b1;
            // trif.frame_done = 1'b0;
            trif.yin_in = 18'b0;
            // trif.count_out = 1'b0;
            trif.enable = 1'b0;
            trif.done_early = 1'b0;
            @(posedge clk);
            @(posedge clk);
            @(negedge clk);
            rst = 1'b0;
            @(posedge clk);
            @(posedge clk);
        end
    endtask

    
    task rand_numbers_20;
    // logic [10:0] arr[20];
        begin
            int rand_num, i;
            logic signed [DW-1:0] fp_val;
            real float_val;
            

            @(negedge clk);
            trif.enable = 1'b1;
            for (i = 0; i < FRAME_LEN - 2028; i++) begin
                
                rand_num = $urandom;  // get a random number
                fp_val = {rand_num[17:0]};
                float_val = fp_val / real'(1 << DECIMALBITS);
                $display("ind: %d lower 18 bits of rand_num (hex): %x, float form: %0f", i, fp_val, float_val);
                trif.yin_in = fp_val;
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

    task test_done_early;
        begin
        @(negedge clk);
        trif.enable = 1'b1;
        trif.yin_in = 18'h0_4000; // Start high
        @(posedge clk);
        
        @(negedge clk);
        trif.yin_in = 18'h0_5000;
        @(posedge clk);

        // trough on index 2
        @(negedge clk);
        trif.yin_in = 18'h3_1000;
        @(posedge clk);
        
        @(negedge clk);
        trif.yin_in = 18'h1700;
        @(posedge clk);
        
        @(negedge clk);
        trif.yin_in = 18'h7200;
        @(posedge clk);
        
        @(negedge clk);
        trif.yin_in = 18'h8300;
        @(posedge clk);
        
        @(negedge clk);
        trif.enable = 1'b0;
        trif.done_early = 1'b1;
        @(posedge clk);  // finish previous cycle
        @(negedge clk);
        trif.done_early = 1'b0;
        @(posedge clk); // first stall cycle
        @(posedge clk); // second stall
        end
    endtask

// -----------------------
// Q7.11 conversion helper
// -----------------------
function real q7_11_to_real (logic signed [17:0] x);
    return x / real'(1 << 11);  // divide by 2048
endfunction

// Convenient localparams for trough-testing
localparam logic signed [17:0] POS_HI   = 18'sd2458;   // +1.20
localparam logic signed [17:0] POS_MID  = 18'sd1229;   // +0.60
localparam logic signed [17:0] POS_LO   = 18'sd307;    // +0.15
localparam logic signed [17:0] POS_TR   = 18'sd102;    // +0.05  <-- trough

localparam logic signed [17:0] NEG_HI   = -18'sd2253;  // -1.10
localparam logic signed [17:0] NEG_MID  = -18'sd1434;  // -0.70
localparam logic signed [17:0] NEG_LO   = -18'sd410;   // -0.20
localparam logic signed [17:0] NEG_TR   = -18'sd82;    // -0.04  <-- trough

// -----------------------
// 1. (+,+,+)
// -----------------------
task test_ppp;
    begin
        @(negedge clk); trif.enable = 1;
        trif.yin_in = POS_MID;
        $display("PPP: yin1 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = POS_TR;
        $display("PPP: yin2 (trough) = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = POS_HI;
        $display("PPP: yin3 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.enable = 0;
        trif.done_early = 1'b1;
        @(negedge clk); trif.done_early = 1'b0;
    end
endtask

// -----------------------
// 2. (+,+,-)
// -----------------------
task test_ppn;
    begin
        @(negedge clk); trif.enable = 1;
        trif.yin_in = POS_HI;
        $display("PPN: yin1 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = POS_TR;
        $display("PPN: yin2 (trough) = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = NEG_MID;
        $display("PPN: yin3 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.enable = 0;
        trif.done_early = 1'b1;
        @(negedge clk); trif.done_early = 1'b0;
    end
endtask

// -----------------------
// 3. (+,-,-)
// -----------------------
task test_pnn;
    begin
        @(negedge clk); trif.enable = 1;
        trif.yin_in = POS_MID;
        $display("PNN: yin1 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = NEG_TR;
        $display("PNN: yin2 (trough) = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = NEG_LO;
        $display("PNN: yin3 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.enable = 0;
        trif.done_early = 1'b1;
        @(negedge clk); trif.done_early = 1'b0;
    end
endtask

// -----------------------
// 4. (+,-,+)
// -----------------------
task test_pnp;
    begin
        @(negedge clk); trif.enable = 1;
        trif.yin_in = POS_LO;
        $display("PNP: yin1 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = NEG_TR;
        $display("PNP: yin2 (trough) = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = POS_MID;
        $display("PNP: yin3 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.enable = 0;
        trif.done_early = 1'b1;
        @(negedge clk); trif.done_early = 1'b0;
    end
endtask

// -----------------------
// 5. (-,+,+)
// -----------------------
task test_npp;
    begin
        @(negedge clk); trif.enable = 1;
        trif.yin_in = NEG_HI;
        $display("NPP: yin1 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = POS_TR;
        $display("NPP: yin2 (trough) = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = POS_MID;
        $display("NPP: yin3 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.enable = 0;
        trif.done_early = 1'b1;
        @(negedge clk); trif.done_early = 1'b0;
    end
endtask

// -----------------------
// 6. (-,-,+)
// -----------------------
task test_nnp;
    begin
        @(negedge clk); trif.enable = 1;
        trif.yin_in = NEG_LO;
        $display("NNP: yin1 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = NEG_TR;
        $display("NNP: yin2 (trough) = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = POS_HI;
        $display("NNP: yin3 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.enable = 0;
        trif.done_early = 1'b1;
        @(negedge clk); trif.done_early = 1'b0;
    end
endtask

// -----------------------
// 7. (-,-,-)
// -----------------------
task test_nnn;
    begin
        @(negedge clk); trif.enable = 1;
        trif.yin_in = NEG_MID;
        $display("NNN: yin1 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = NEG_TR;
        $display("NNN: yin2 (trough) = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = NEG_LO;
        $display("NNN: yin3 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.enable = 0;
        trif.done_early = 1'b1;
        @(negedge clk); trif.done_early = 1'b0;
    end
endtask

// -----------------------
// 8. (-,+,-)
// -----------------------
task test_npn;
    begin
        @(negedge clk); trif.enable = 1;
        trif.yin_in = NEG_HI;
        $display("NPN: yin1 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = POS_TR;
        $display("NPN: yin2 (trough) = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.yin_in = NEG_LO;
        $display("NPN: yin3 = %f (raw=%0d)", q7_11_to_real(trif.yin_in), trif.yin_in);
        @(posedge clk);

        @(negedge clk); trif.enable = 0;
        trif.done_early = 1'b1;
        @(negedge clk); trif.done_early = 1'b0;
    end
endtask

    

    initial begin
        // $monitor("%0t min_yin: %h", $time, min_yin);
        curr = "RESET";
        reset_dut();

        // curr = "Test Trough";
        // test_trough();
        // #(PERIOD);

        curr = "Random Numbers";
        rand_numbers_20();
        rand_numbers_20();
        rand_numbers_20();

        curr = "First min";
        test_first_min();
        test_second_last_min();
        test_done_early();

        #(PERIOD * 20);
        test_ppp();
        #(PERIOD * 3);
        test_pnp();
        #(PERIOD * 3);
        test_ppn();
        #(PERIOD * 3);
        test_pnn();
        #(PERIOD * 3);

        test_nnn();
        #(PERIOD * 3);
        test_nnp();
        #(PERIOD * 3);
        test_npn();
        #(PERIOD * 3);
        test_npp();
        #(PERIOD * 3);
        // #(PERIOD);

        // assuming that I get an enable signal and a valid yin on the same cycle

        // curr = "Test Last Sample Min";
        // test_last_min();
        // #(PERIOD);
        // #(PERIOD);

        $finish;
    end
endmodule