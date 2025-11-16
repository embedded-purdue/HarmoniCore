`timescale 1ns/1ps

`ifndef FIND_TROUGH_IF
`define FIND_TROUGH_IF

`include "../include/types.sv"
import types::*;

interface find_trough_if;

    // logic frame_done; // or rst
    logic signed [DW-1:0] next_yin, curr_yin, prev_yin;
    logic [DECIMALBITS-1:0] idx;
    // I think DW is the width?
    logic trough_found, enable, frame_done;

    // inputs from josh
    logic signed [DW-1:0] yin_in;
    logic done_early;

    // outputs to josh
    logic [DW-1:0] tau;

    // modport find (
    //     input  yin_in, enable, done_early,
    //     output tau, idx, trough_found, frame_done, next_yin, curr_yin, prev_yin
    // );

    // modport tb (
    //     input  tau, idx, trough_found, 
    //     output frame_done, next_yin, count_out
    // );

endinterface
`endif