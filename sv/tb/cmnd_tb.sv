
`timescale 1ns / 1ps
`include "../include/types.sv"
`include "../include/cmnd_if.vh"

module cmnd_tb;

    parameter PERIOD = 10;
    logic clk = 1, rst;

    // clock
    always #(PERIOD/2) clk++;

    // interface
    cmnd_if cmndif ();

    // test program
    test PROG (
        clk,
        rst,
        cmndif
    );

    // DUT
    cmnd DUT(clk, rst, cmndif);

endmodule

program test
import types::*;
(
    input logic clk,
    output logic rst,
    cmnd_if.tb tbif
);

    task sendDiff (input logic [DW-1:0] diff_in, input logic diff_valid);
        begin
            tbif.diff_in = diff_in;
            tbif.diff_valid = diff_valid;
            @(negedge clk);
        end
    endtask

    task sendInterp (input logic [DW-1:0] interp_dividend, input logic [DW-1:0] interp_divisor, input logic [DW-1:0] interp_tau, input logic interp_valid);
        begin
            tbif.interp_dividend = interp_dividend;
            tbif.interp_divisor = interp_divisor;
            tbif.interp_tau = interp_tau;
            tbif.interp_valid = interp_valid;
            @(negedge clk);
        end
    endtask

    string test_name;
    integer i;
    initial begin
        tbif.interp_dividend = '0;
        tbif.interp_divisor = '0;
        tbif.interp_tau = '0;
        tbif.interp_valid = 1'b0;

        rst = 1'b1;
        repeat (2) @(negedge clk);
        rst = 1'b0;
        
        // ************************************************************************
        // Test Case 1: Basic Test
        // ************************************************************************
        test_name = "Basic Test";
        $display("%s", test_name);

        for (i = 1; i <= 800; i++) begin
            sendDiff(18'h0 + i, 1'b1);
        end

        sendInterp(18'h2800, 18'hA00, 18'h800, 1'b1); // result is 18'h2000 then input should be 18'h2800 and whatever DR is

        repeat (100) @(negedge clk);

        $finish;
    end

endprogram
