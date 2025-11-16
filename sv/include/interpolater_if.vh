`timescale 1ns/1ps

`ifndef INTERPOLATER_IF
`define INTERPOLATER_IF

`include "../include/types.sv"
import types::*;

interface interpolater_if;

    // logic frame_done; // or rst
    logic signed [DW-1:0] next_yin, curr_yin, prev_yin;
    // logic [DECIMALBITS-1:0] idx;
    // I think DW is the width?
    logic trough_found, frame_done;

    // input from josh is done_early. Reset the regs on frame_done or done_early.

    // output to josh
    logic signed[DIVIDE_INPUT_W-1:0] numer, denom;
    logic divide_out_ready;

    modport interp (
        input  next_yin, curr_yin, prev_yin, trough_found, frame_done,
        output numer, denom, divide_out_ready
    );

    // modport tb (
    //     input  tau, idx, trough_found, 
    //     output frame_done, next_yin, count_out
    // );

endinterface
`endif