
`timescale 1ns / 1ps
`include "../include/types.sv"
`include "../include/cmnd_if.vh"

module cmnd
import types::*;
(
    input logic clk,
    input logic nRST,
    cmnd_if.cmnd cmndif
);
    // Cumulative Sum Instantiation
    logic [DW-1:0] total;
    cumsum cumsum_inst(.clk(clk), .nRST(nRST), .diff_in(cmndif.diff_in), 
                       .total(total));

    // Counter Instantiation
    logic [DW-1:0] count;
    logic rollover_flag;
    counter #(.SIZE(18)) counter_inst (.clk(clk), .n_rst(nRST), .clear(1'b0), .count_enable(cmndif.diff_valid), .rollover_val(MAX_PERIOD),
                                       .count_out(count), .rollover_flag(rollover_flag));
    
    // Diff Shift Register Instantiation
    logic [DW-1:0] delayed_diff;
    shift_reg #(.LATENCY(23)) shift_inst (.clk(clk), .n_rst(nRST), .shift_en(1'b1), .serial_in(cmndif.diff_in),
                                          .serial_out(delayed_diff));

    // Div and Memory Block Instantiation
    div_mem_block div_mem_inst (.clk(clk), .nRST(nRST), .rollover_flag(rollover_flag), .total(total), .count(count), .delayed_diff(delayed_diff),
                                .final_out(cmndif.yin_val));

endmodule