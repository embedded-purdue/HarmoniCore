`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;

module cumsum_tb ();

    localparam CLK_PERIOD = 10ns;

    logic clk, rst;
    logic [DW-1:0] diff_in, total;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        rst = 0;
        @(negedge clk);
        @(negedge clk);
    end
    endtask

    task new_value (input logic [DW-1:0] new_diff);
        begin
            diff_in = new_diff;
            @(negedge clk);
        end
    endtask

    cumsum DUT (.clk(clk), .rst(rst), .diff_in(diff_in), .total(total));

    string test_name;
    initial begin
        rst = 0;
        diff_in = '0;
        @(negedge clk);
        reset_dut;

        // ************************************************************************
        // Test Case 1: Overflow Positive
        // ************************************************************************
        test_name = "Overflow Positive";
        $display("%s", test_name);

        new_value(18'h8000); // 8000
        new_value(18'h8000); // 10000
        new_value(18'h8000); // 18000
        new_value(18'h800);  // 18800
        new_value(18'h800);  // 19000
        new_value(18'h8000); // 1FFFF overflow to max positive
        new_value(18'h8000); // stay at max positive

        // ************************************************************************
        // Test Case 1: Overflow Negative
        // ************************************************************************
        test_name = "Overflow Negative";
        $display("%s", test_name);

        new_value(18'h2FFFF); // 10000
        new_value(18'h30000); // 00000
        new_value(18'h30000); // signed negative stuff
        new_value(18'h8000); 
        new_value(18'h30000);
        new_value(18'h30000); // 20000 underflow to max negative
        new_value(18'h30000); // stay at max negative
        
        $finish;
    end
endmodule