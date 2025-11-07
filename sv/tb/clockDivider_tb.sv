`timescale 1ns / 1ps

`include "../include/types.sv"
import types::*;

module tb_clockDivider;
    // Parameter for clock period and divisor
    parameter PERIOD = 10;
    parameter DIVISOR = 10;

    // Internal signals
    logic clk = 0;                      // The input clock
    logic clk_out;                      // The divided output clock
    logic [31:0] input_cycle_count = 0; // Counts input clock cycles
    logic [31:0] output_cycle_count = 0; // Counts output clock cycles

    // Instantiate the DUT
    Clock_divider #(.DIVISOR(DIVISOR)) DUT (
        .clock_in(clk),
        .clock_out(clk_out)
    );

    // Clock generation
    always #(PERIOD/2) clk = ~clk;

    // Count every rising edge of input clock
    always @(posedge clk) begin
        input_cycle_count <= input_cycle_count + 1;
    end

    // Count every rising edge of output clock
    always @(posedge clk_out) begin
        output_cycle_count <= output_cycle_count + 1;
    end

    // Helper task for verification
    task verify_divisor;
        input int expected_output_cycles;
        input string test_name;
        begin
            if (output_cycle_count == expected_output_cycles) begin
                $display("PASS: %s - Output cycles: %d (expected: %d)", test_name, output_cycle_count, expected_output_cycles);
            end else begin
                $display("FAIL: %s - Output cycles: %d (expected: %d)", test_name, output_cycle_count, expected_output_cycles);
            end
        end
    endtask

    initial begin
        int expected;

        // TEST CASE 1: Basic test with 100 input cycles
        $display("TEST CASE 1: Divisor = %d, Input cycles = 100", DIVISOR);
        input_cycle_count = 0;
        output_cycle_count = 0;
        #(PERIOD * 2);
        repeat(100) @(posedge clk);
        #(PERIOD * 5);
        expected = 100 / DIVISOR;
        verify_divisor(expected, "Test Case 1: 100 cycles");

        // TEST CASE 2: Shorter duration with 50 input cycles
        $display("TEST CASE 2: Divisor = %d, Input cycles = 50", DIVISOR);
        input_cycle_count = 0;
        output_cycle_count = 0;
        #(PERIOD * 2);
        repeat(50) @(posedge clk);
        #(PERIOD * 5);
        expected = 50 / DIVISOR;
        verify_divisor(expected, "Test Case 2: 50 cycles");

        // TEST CASE 3: Longer duration with 200 input cycles
        $display("TEST CASE 3: Divisor = %d, Input cycles = 200", DIVISOR);
        input_cycle_count = 0;
        output_cycle_count = 0;
        #(PERIOD * 2);
        repeat(200) @(posedge clk);
        #(PERIOD * 5);
        expected = 200 / DIVISOR;
        verify_divisor(expected, "Test Case 3: 200 cycles");

        // TEST CASE 4: Odd number of cycles with 99 input cycles
        $display("TEST CASE 4: Divisor = %d, Input cycles = 99", DIVISOR);
        input_cycle_count = 0;
        output_cycle_count = 0;
        #(PERIOD * 2);
        repeat(99) @(posedge clk);
        #(PERIOD * 5);
        expected = 99 / DIVISOR;
        verify_divisor(expected, "Test Case 4: 99 cycles");

        // TEST CASE 5: Stress test with 1000 input cycles
        $display("TEST CASE 5: Divisor = %d, Input cycles = 1000", DIVISOR);
        input_cycle_count = 0;
        output_cycle_count = 0;
        #(PERIOD * 2);
        repeat(1000) @(posedge clk);
        #(PERIOD * 5);
        expected = 1000 / DIVISOR;
        verify_divisor(expected, "Test Case 5: 1000 cycles");

        $finish;
    end
endmodule