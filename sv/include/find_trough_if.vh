`timescale 1ns/1ps

`ifndef FIND_TROUGH_IF
`define FIND_TROUGH_IF

`include "../include/types.sv"
import types::*;

interface find_trough_if;

    // logic frame_done; // or rst
    logic signed [DW-1:0] yin_in, next_yin, curr_yin, prev_yin;
    logic [DECIMALBITS-1:0] idx;
    // I think DW is the width?
    logic [DW-1:0] tau;        // not sure how big the width will be
    logic trough_found, enable, frame_done;

    // modport find (
    //     input  yin_in, enable,
    //     output tau, idx, trough_found, frame_done, next_yin, curr_yin, prev_yin
    // );

    // modport tb (
    //     input  tau, idx, trough_found, 
    //     output frame_done, next_yin, count_out
    // );

endinterface
`endif