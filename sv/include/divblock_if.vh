
`timescale 1ns/1ps

`ifndef DIVBLOCK_IF
`define DIVBLOCK_IF

`include "../include/types.sv"
import types::*;

interface divblock_if;

    // Algo C Signals (Cummean)
    logic rollover_flag;
    logic [DW-1:0] total, count, delayed_diff;

    // Algo D Signals (Interp)
    logic interp_enable;
    logic [DW-1:0] interp_dividend, interp_divisor, interp_tau;

    // Output to Algo D
    logic yin_valid;
    logic [DW-1:0] yin_out;

    // Final Output
    logic final_valid;
    logic [DW-1:0] final_out;

    modport divblock (
        input rollover_flag, total, count, delayed_diff,
        input interp_enable, interp_dividend, interp_divisor, interp_tau,
        output yin_valid, yin_out,
        output final_valid, final_out
    );

    modport divblock_tb (
        output rollover_flag, total, count, delayed_diff,
        output interp_enable, interp_dividend, interp_divisor, interp_tau,
        input yin_valid, yin_out,
        input final_valid, final_out
    );
    
endinterface

`endif

/*

Input: dividend_valid, divisor_valid, dividend_data, divisor_data,

Output: out_valid, out_data

*/