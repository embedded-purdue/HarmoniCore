`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;

parameter PERIOD = 10;

module yinDiff_tb;
    // STEP 1: Declare all the signals
    // (same names as module inputs/outputs)
    logic clk;
    logic rst;
    logic acf_valid;
    logic energy_valid;
    logic [FFT_DW-1:0] acf_data;
    logic [FFT_DW-1:0] energy_data;

    logic diff_valid;
    logic [FFT_DW-1:0] difference;

    // STEP 2: Instantiate the module under test
    yinDiff dut (
        .clk(clk),
        .rst(rst),
        .energy_data(energy_data),
        .energy_valid(energy_valid),
        .acf_data(acf_data),
        .acf_valid(acf_valid),
        .difference(difference),
        .diff_valid(diff_valid)
    );

    // STEP 3: Generate clock
    initial begin
        clk = 0;
        forever #(PERIOD/2) clk = ~clk;
    end
    
    // STEP 4: Write test scenarios
    initial begin
        rst = 1;
        energy_valid = 0;
        acf_valid = 0;
        energy_data = 0;
        acf_data = 0;
        
        #20;
        @(posedge clk) rst = 0;
        
        // TEST CASE 1: Capture energy[0]
        @(posedge clk) begin
            energy_data = 100;
            energy_valid = 1;
        end
        @(posedge clk) energy_valid = 0;
        @(posedge clk);
        
        // TEST CASE 2: Synchronous arrival - both signals together
        @(posedge clk) begin
            energy_data = 150;
            energy_valid = 1;
            acf_data = 20;
            acf_valid = 1;
        end
        @(posedge clk) begin
            energy_valid = 0;
            acf_valid = 0;
        end
        @(posedge clk);
        $display("TEST 2: diff=%d, diff_valid=%b (expected: 210, 1)", $signed(difference), diff_valid);
        
        // TEST CASE 3: ACF arrives first, energy delayed
        @(posedge clk) begin
            acf_data = 25;
            acf_valid = 1;
        end
        @(posedge clk) acf_valid = 0;
        @(posedge clk);
        @(posedge clk) begin
            energy_data = 180;
            energy_valid = 1;
        end
        @(posedge clk) energy_valid = 0;
        @(posedge clk);
        $display("TEST 3: diff=%d, diff_valid=%b (expected: 210, 1)", $signed(difference), diff_valid);
        
        // TEST CASE 4: Energy arrives first, ACF delayed
        @(posedge clk) begin
            energy_data = 200;
            energy_valid = 1;
        end
        @(posedge clk) energy_valid = 0;
        @(posedge clk);
        @(posedge clk) begin
            acf_data = 45;
            acf_valid = 1;
        end
        @(posedge clk) acf_valid = 0;
        @(posedge clk);
        $display("TEST 4: diff=%d, diff_valid=%b (expected: 210, 1)", $signed(difference), diff_valid);
        
        // TEST CASE 5: Burst of consecutive values
        @(posedge clk) begin
            energy_data = 160;
            energy_valid = 1;
            acf_data = 30;
            acf_valid = 1;
        end
        @(posedge clk) begin
            energy_data = 170;
            energy_valid = 1;
            acf_data = 35;
            acf_valid = 1;
        end
        @(posedge clk) begin
            energy_valid = 0;
            acf_valid = 0;
        end
        @(posedge clk);
        $display("TEST 5a: diff=%d (expected: 200)", $signed(difference));
        @(posedge clk);
        $display("TEST 5b: diff=%d (expected: 195)", $signed(difference));
        
        // TEST CASE 6: diff_valid stays low when inputs missing
        @(posedge clk);
        @(posedge clk);
        $display("TEST 6: diff_valid=%b (expected: 0)", diff_valid);
        
        // TEST CASE 7: Only energy_valid high
        @(posedge clk) begin
            energy_data = 190;
            energy_valid = 1;
            acf_valid = 0;
        end
        @(posedge clk) energy_valid = 0;
        @(posedge clk);
        $display("TEST 7: diff_valid=%b (expected: 0)", diff_valid);
        
        // TEST CASE 8: Only acf_valid high
        @(posedge clk) begin
            energy_valid = 0;
            acf_data = 50;
            acf_valid = 1;
        end
        @(posedge clk) acf_valid = 0;
        @(posedge clk);
        $display("TEST 8: diff_valid=%b (expected: 0)", diff_valid);
        
        // TEST CASE 9: Zero values
        @(posedge clk) begin
            energy_data = 0;
            energy_valid = 1;
            acf_data = 0;
            acf_valid = 1;
        end
        @(posedge clk) begin
            energy_valid = 0;
            acf_valid = 0;
        end
        @(posedge clk);
        $display("TEST 9: diff=%d, diff_valid=%b (expected: 100, 1)", $signed(difference), diff_valid);
        
        // TEST CASE 10: Large values (near max)
        @(posedge clk) begin
            energy_data = 18'b111111111111111110;
            energy_valid = 1;
            acf_data = 18'b111111111111111000;
            acf_valid = 1;
        end
        @(posedge clk) begin
            energy_valid = 0;
            acf_valid = 0;
        end
        @(posedge clk);
        $display("TEST 10: diff=%d, diff_valid=%b (large values)", $signed(difference), diff_valid);
        
        #100
        $finish;
    end
    
endmodule