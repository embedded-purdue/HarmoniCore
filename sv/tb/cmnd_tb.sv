
`timescale 1ns / 1ps
`include "../include/types.sv"

module cmnd_tb;

    parameter PERIOD = 10;
    logic clk = 1, nRST;

    // clock
    always #(PERIOD/2) clk++;

    // interface
    cmnd_if cmndif ();

    // test program
    test PROG (
        clk,
        nRST,
        cmndif
    );

    // DUT
    cmnd DUT(clk, nRST, cmndif);

endmodule

program test
import types::*;
(
    input logic clk,
    output logic nRST,
    cmnd_if.tb tbif
);

    task sendInput (input logic [DW-1:0] diff_in, input logic diff_valid, input logic expYinVal);
        begin
            tbif.diff_in = diff_in;
            tbif.diff_valid = diff_valid;
            repeat (20) @(negedge clk);

            $display("=================================");
            assert (tbif.yinval == expYinVal) $display ("Correct yin value");
                else $display ("Incorrect yin value ERROR");
            $display("");

        end
    endtask

    string test_name;
    initial begin
        
        // ************************************************************************
        // Test Case 1: Basic Test
        // ************************************************************************
        test_name = "Basic Test";
        $display("%s", test_name);

        sendInput(18'h8, 1'b1, 18'h0);


    end

endprogram
