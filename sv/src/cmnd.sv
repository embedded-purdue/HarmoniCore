
`timescale 1ns / 1ps
`include "../include/types.sv"
`include "../include/cmnd_if.vh"

module cmnd
import types::*;
(
    input logic clk,
    input logic RST,
    cmnd_if.cmnd cmndif
);
    // Cumulative Sum Instantiation
    logic [DW-1:0] total;
    cumsum cumsum_inst(.clk(clk), .RST(RST), .diff_in(cmndif.diff_in), 
                       .total(total));

    // Counter Instantiation
    logic [DW-1:0] count;
    logic rollover_flag;
    counter #(.SIZE(18)) counter_inst (.clk(clk), .rst(RST), .clear(1'b0), .count_enable(cmndif.diff_valid), .rollover_val(MAX_PERIOD+1),
                                       .count(count), .flag(rollover_flag));
    
    // Diff Shift Register Instantiation
    logic [DW-1:0] delayed_diff;
    shifter shift_inst (.clk(clk), .diff_in(cmndif.diff_in), .shifted_diff(delayed_diff));

    // Div and Memory Block Instantiation
    div_mem_block div_mem_inst (.clk(clk), .RST(RST), .rollover_flag(rollover_flag), .total(total), .count(count), .delayed_diff(delayed_diff),
                                .final_out(cmndif.yin_val));

endmodule
