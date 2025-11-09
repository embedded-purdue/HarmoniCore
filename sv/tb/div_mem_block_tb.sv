
`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;

module div_mem_block_tb;

    parameter PERIOD = 10;
    logic CLK = 1, nRST, rollover_flag;
    logic [DW-1:0] total, count, delayed_diff, final_out;

    // clock
    always #(PERIOD/2) CLK++;

    // test program
    test PROG (
        CLK,
        final_out,
        nRST,
        rollover_flag,
        total,
        count,
        delayed_diff
    );

    // DUT
    div_mem_block DUT(CLK, nRST, rollover_flag, total, count, delayed_diff, final_out);

endmodule

program test (
    input logic CLK, 
    input logic [DW-1:0] final_out,
    output logic nRST, rollover_flag,
    output logic [DW-1:0] total, count, delayed_diff
);

    task sendInput (input logic in_rollover, input logic [DW-1:0] in_total,
                    input logic [DW-1:0] in_count, input logic [DW-1:0] in_delayed_diff);
        begin
            rollover_flag = in_rollover;
            total = in_total;
            count = in_count;
            delayed_diff = in_delayed_diff;
            @(negedge CLK);
        end
    endtask

    string test_name;
    integer i;
    logic [DW-1:0] div_in, div_out, i_count;
    initial begin

        // ************************************************************************
        // Test Case 1: nRST Test
        // ************************************************************************
        test_name = "Basic Test";
        $display("%s", test_name);

        nRST = 1'b0;
        div_in = '0;
        div_out = '0;
        repeat (2) @(negedge CLK);
        nRST = 1'b1;
        repeat (2) @(negedge CLK);
        
        // ************************************************************************
        // Test Case 2: Test Cummean Division
        // ************************************************************************
        test_name = "Test Cummean Division";
        $display("%s", test_name);

        for (i = 1; i < 51; i++) begin
            div_in = i*18'hA;
            i_count = i;
            sendInput(1'b0, div_in, i_count, 18'h2); // rollover, total, count, delayed_diff
            sendInput(1'b0, div_in, i_count, 18'h5); // rollover, total, count, delayed_diff
        end
        
        // div input = 10 / 1
        // div input = 20 / 2
        // div input = 30 / 3

        // ************************************************************************
        // Test Case 3: Test Yinval Division
        // ************************************************************************
        test_name = "Test Yinval Division";
        $display("%s", test_name);

        sendInput(1'b1, 18'h0, 18'h0, 18'h0); // trigger divFlag
        repeat (21) @(negedge CLK); // wait for memFlag

        for (i = 1; i < 16; i++) begin
            sendInput(1'b1, 18'h0, 18'h0, 18'h0); // rollover, total, count, delayed_diff
        end

        repeat (5) @(negedge CLK);
        for (i = 0; i < 21; i++) begin
            @(negedge CLK);
            if (i < 10) begin
                assert (final_out == 18'h5) $display ("Correct final_out value: %d", final_out);
                    else $display ("Incorrect final_out value ERROR: %d", final_out);
            end
            else begin
                assert (final_out == 18'h0) $display ("Correct final_out value: %d", final_out);
                    else $display ("Incorrect final_out value ERROR: %d", final_out);
            end

            @(negedge CLK);
            if (i < 10) begin
                assert (final_out == 18'h2) $display ("Correct final_out value: %d", final_out);
                    else $display ("Incorrect final_out value ERROR: %d", final_out);
            end
            else begin
                assert (final_out == 18'h0) $display ("Correct final_out value: %d", final_out);
                    else $display ("Incorrect final_out value ERROR: %d", final_out);
            end
        end
        
        // yin output = 10 / 2 = 5
        // yin output = 10 / 5 = 2
        // yin output = 10 / 2 = 5
        // yin output = 10 / 5 = 2
        // ...

        repeat (2) @(negedge CLK);
        $finish;
    end

endprogram
