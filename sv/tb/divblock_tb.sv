
`timescale 1ns / 1ps
`include "../include/types.sv"
`include "../include/divblock_if.vh"
import types::*;

module divblock_tb;

    parameter PERIOD = 10;
    logic clk = 1, nRST;

    // clock
    always #(PERIOD/2) clk++;

    divblock_if ctrif();

    // test program
    test PROG (
        clk,
        nRST,
        ctrif
    );

    // DUT
    divblock DUT(clk, nRST, ctrif);

endmodule

program test (
    input logic clk, 
    output logic nRST,
    divblock.divblock_tb ctrif
);

    task sendDiff (input logic [DW-1:0] dividend_in, input logic [DW-1:0] divisor_in);
        begin
            divif.dividend_valid = 1'b1;
            divif.dividend_data  = dividend_in;
            divif.divisor_valid  = 1'b1;
            divif.divisor_data   = divisor_in;
            @(negedge clk);
        end
    endtask

    string test_name;
    initial begin

        nRST = 1'b0;
        repeat (2) @(negedge clk);
        nRST = 1'b1;
        repeat (2) @(negedge clk);
        
        // ************************************************************************
        // Test Case 1: Fully Pipelined Divisions
        // ************************************************************************
        test_name = "Fully Pipelined Divisions";
        $display("%s", test_name);

        @(negedge clk);
        assert (divif.out_data == 18'h012AA) $display ("Correct output value (output repeating)"); // 7 / 3 = 2.3333
            else $display ("Incorrect output value (output repeating) ERROR");
        @(negedge clk);
        assert (divif.out_data == 18'h0EEEE) $display ("Correct output value (output repeating)"); // 56 / 1.875 = 29.8666
            else $display ("Incorrect output value (output repeating) ERROR");
        @(negedge clk);
        assert (divif.out_data == 18'h32E00) $display ("Correct output value (input repeating)"); // -63 / 2.4 = -26.25
            else $display ("Incorrect output value (input repeating) ERROR");
        $display("");

        repeat (15) @(negedge clk);
        $finish;

    end

endprogram
