
`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;

module shiftwrapper_tb;

    parameter PERIOD = 10;
    logic clk = 1, nRST;
    logic [DW-1:0] diff_in;
    logic [DW-1:0] shifted_diff;

    // clock
    always #(PERIOD/2) clk++;

    // test program
    test PROG (
        clk,
        shifted_diff,
        nRST,
        diff_in
    );

    // DUT
    shiftwrapper DUT(clk, nRST, diff_in, shifted_diff);

endmodule

program test (
    input logic clk, 
    input logic [DW-1:0] shifted_diff,
    output logic nRST,
    output logic [DW-1:0] diff_in
);

    task sendInput (input logic [DW-1:0] in_diff);
        begin
            diff_in = in_diff;
            @(negedge clk);
        end
    endtask

    string test_name;
    initial begin

        nRST = 1'b1;
        repeat (2) @(negedge clk);
        nRST = 1'b0;
        repeat (2) @(negedge clk);
        
        // ************************************************************************
        // Test Case 1: Basic Test
        // ************************************************************************
        test_name = "Basic Test";
        $display("%s", test_name);

        sendInput(18'h8);
        sendInput(18'h16);
        sendInput(18'h247);

        repeat(30) @(negedge clk);
        assert (shifted_diff == 18'h8) $display ("Correct output value");
            else $display ("Incorrect output value ERROR");
        @(negedge clk);
        assert (shifted_diff == 18'h16) $display ("Correct output value");
            else $display ("Incorrect output value ERROR");
        @(negedge clk);
        assert (shifted_diff == 18'h247) $display ("Correct output value");
            else $display ("Incorrect output value ERROR");
        
        repeat(5) @(negedge clk);
        $finish;
    end

endprogram
