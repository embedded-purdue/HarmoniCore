
`timescale 1ns / 1ps
`include "../include/types.sv"
`include "../include/cmnd_if.vh"
`include "../include/divblock_if.vh"

module cmnd
import types::*;
(
    input logic clk, rst,
    cmnd_if.cmnd cmndif
);
    // Cumulative Sum Instantiation
    logic [DW-1:0] total;
    cumsum cumsum_inst(.clk(clk), .rst(rst), .diff_in(cmndif.diff_in), 
                       .total(total));

    // Counter Instantiation
    logic [DW-1:0] count;
    logic rollover_flag;
    counter counter_inst (.clk(clk), .rst(rst), .count_enable(cmndif.diff_valid), .rollover_val(MAX_PERIOD),
                                       .count(count), .flag(rollover_flag));
    
    // Diff Shift Register Instantiation
    logic [DW-1:0] delayed_diff;
    shiftwrapper shift_inst (.clk(clk), .rst(rst), .diff_in(cmndif.diff_in), .shifted_diff(delayed_diff));

    // Div and Memory Block Instantiation
    divblock_if divmemif();
    divblock divblock_inst (clk, rst, divmemif);
    
    always_ff @(posedge clk) begin : latchFinalValue
        if (rst) begin
            cmndif.psola_valid <= 1'b0;
            cmndif.psola_out <= '0;
        end
        else if (divmemif.final_valid) begin
            cmndif.psola_valid <= divmemif.final_valid;
            cmndif.psola_out <= divmemif.final_out;
        end
    end

    always_comb begin : connectSignals
        divmemif.rollover_flag    = rollover_flag;
        divmemif.total            = total;
        divmemif.count            = count + 1; // tau from 1, max_period+1
        divmemif.delayed_diff     = delayed_diff;
        divmemif.interp_enable    = cmndif.interp_valid;
        divmemif.interp_dividend  = cmndif.interp_dividend;
        divmemif.interp_divisor   = cmndif.interp_divisor;
        divmemif.interp_tau       = cmndif.interp_tau;
        cmndif.yin_valid          = divmemif.yin_valid;
        cmndif.yin_out            = divmemif.yin_out;
    end

endmodule
