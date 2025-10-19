`timescale 1ns / 1ps

import types::*;

module top #(
    parameter DW = 18,
    parameter FRAME_LEN = 2048,
    parameter signed [DW-1:0] TROUGH_THRESHOLD = -18'sd204,
    parameter MIN_PERIOD = 21
) (
    input logic clk,
    input logic n_rst,
    input logic signed [DW-1:0] next_yin,
    input logic next_idx,
    output logic signed [DW-1:0] prev_yin,
    output logic signed [DW-1:0] curr_yin,
    output logic trough_found_out,
    output logic signed [DW-1:0] min_val_out,
    output logic signed [DW-1:0] first_trough,
    output logic signed [DW-1:0] tau
);
    logic [$clog2(FRAME_LEN)-1:0] count_out;
    logic frame_done;

    counter #(.FRAME_LEN(FRAME_LEN)) count (
        .clk(clk),
        .n_rst(n_rst),
        .count_out(count_out),
        .frame_done(frame_done)
    );

    logic signed idx;

    find_trough #(
        .DW(DW),
        .FRAME_LEN(FRAME_LEN),
        .TROUGH_THRESHOLD(TROUGH_THRESHOLD),
        .MIN_PERIOD(MIN_PERIOD)
    ) f_trough (
        .clk(clk),
        .n_rst(n_rst),
        .frame_done(frame_done),
        .next_yin(next_yin),
        .count_out(count_out),
        .tau(tau),
        .idx(idx),
        .trough_found(trough_found_out),
        .min_val(min_val_out),
        .first_trough(first_trough),
        .prev_yin(prev_yin),
        .curr_yin(curr_yin)
    );

endmodule

module counter #(
    parameter FRAME_LEN = 2048
) (
    input  logic clk,
    input  logic n_rst,
    output logic [$clog2(FRAME_LEN)-1:0] count_out,
    output logic frame_done
);
    logic [$clog2(FRAME_LEN)-1:0] next_count;
    logic next_frame_done;

    always_ff @(posedge clk) begin
        if (~n_rst) begin
            count_out  <= '0;
            frame_done <= 1'b0;
        end else begin
            count_out  <= next_count;
            frame_done <= next_frame_done;
        end
    end

    always_comb begin
        if (count_out == FRAME_LEN - 1) begin
            next_count      = '0;
            next_frame_done = 1'b1;
        end else begin
            next_count      = count_out + 1;
            next_frame_done = 1'b0;
        end
    end
endmodule


module find_trough #(
    parameter DW = 18,
    parameter FRAME_LEN = 2048,
    parameter signed [DW-1:0] TROUGH_THRESHOLD = -18'sd204,
    parameter MIN_PERIOD = 21
) (
    input logic clk, n_rst, frame_done,
    input logic signed [DW-1:0] next_yin,
    input logic [$clog2(FRAME_LEN)-1:0] count_out,
    output logic signed [DW-1:0] tau,
    output logic signed [DW-1:0] idx,
    output logic trough_found,
    output logic signed [DW-1:0] min_val,
    output logic signed [DW-1:0] first_trough,
    output logic signed [DW-1:0] prev_yin,
    output logic signed [DW-1:0] curr_yin
);

    logic signed [DW-1:0] next_tau;
    logic signed [DW-1:0] smallest_min, next_smallest_min;
    logic [$clog2(FRAME_LEN)-1:0] min_index, next_min_index;
    logic [$clog2(FRAME_LEN)-1:0] trough_index, next_trough_index;
    logic next_trough_found;
    
    logic signed [DW-1:0] next_min_val;
    logic signed [DW-1:0] next_first_trough;
    
    localparam signed [DW-1:0] MAX_VAL = (1 << (DW-2)) - 1;
    logic [$clog2(MIN_PERIOD):0] period_counter, next_period_counter;

    always_ff @(posedge clk) begin : Controller
        if (~n_rst) begin
            min_index         <= '0;
            trough_index      <= '0;
            trough_found      <= 1'b0;
            smallest_min      <= MAX_VAL;
            tau               <= '0;
            curr_yin          <= '0;
            prev_yin          <= '0;
            min_val           <= '0;
            first_trough      <= '0;
            period_counter    <= '0;
        end else begin
            trough_index     <= next_trough_index;
            trough_found     <= next_trough_found;
            smallest_min     <= next_smallest_min;
            min_index        <= next_min_index;
            curr_yin         <= next_yin;
            prev_yin         <= curr_yin;
            tau              <= next_tau;
            min_val          <= next_min_val;
            first_trough     <= next_first_trough;
            period_counter   <= next_period_counter;
        end
    end

    always_comb begin : next_xxx_logic
        // --- Default assignments (hold current values) ---
        next_tau                = tau;
        next_trough_found       = trough_found;
        next_trough_index       = trough_index;
        next_smallest_min       = smallest_min;
        next_min_index          = min_index;
        next_period_counter     = period_counter;
        next_min_val            = min_val;
        next_first_trough       = first_trough;

        if (period_counter > 0) begin
            next_period_counter = period_counter - 1;
        end

        // --- Logic to find the first trough ---
        if ((curr_yin < prev_yin) && (curr_yin <= next_yin) && (curr_yin < TROUGH_THRESHOLD) && (~trough_found) && (period_counter == 0)) begin
            next_trough_index     = count_out - 1;
            next_trough_found     = 1'b1;
            next_period_counter   = MIN_PERIOD;
            next_first_trough     = curr_yin; // Latch the first trough's value
        end

        // --- Always search for the overall minimum value ---
        if (curr_yin < smallest_min) begin
            next_min_index    = count_out - 1;
            next_smallest_min = curr_yin;
        end

        // --- Logic at the end of a frame ---
        if (frame_done) begin
            // Latch the final overall minimum value
            next_min_val = smallest_min;

            // Set tau for the next stage based on results
            if (trough_found) begin
                next_tau = trough_index + MIN_PERIOD;
            end else begin
                next_tau = min_index + MIN_PERIOD;
            end
            
            // --- Reset states for the NEXT frame search ---
            next_smallest_min   = MAX_VAL;
            next_min_index      = '0;
            next_trough_index   = '0;
            
            next_period_counter = '0;
            // next_first_trough = '0;

            // If no trough was found in the entire frame, reset the first_trough output.
            // Otherwise, it correctly holds its latched value.
            if (~trough_found) begin
                next_first_trough = '0;
            end
        end
    end

    assign idx = tau - MIN_PERIOD;

endmodule