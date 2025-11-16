`timescale 1ns / 1ps

`ifndef TYPES
`define TYPES

package types;

    parameter DW = 18;
    parameter FFT_DW = DW;
    parameter MAX_VAL = (1 <<< (FFT_DW-1)) - 1;
    parameter MIN_VAL = -(1 <<< (FFT_DW-1));
    parameter DECIMALBITS = 11;
    parameter SEMITONES_IN_OCTAVE = 12;
    parameter DR = 44100;
    parameter FRAME_LEN = 2048;
    parameter HOP_LEN = FRAME_LEN / 4;
    parameter WIN_LEN = FRAME_LEN / 2;
    // parameter TROUGH_THRESHOLD = 0.1;
    parameter FMIN = 65.41; //C2
    parameter FMAX = 2093; //C7
    parameter MIN_PERIOD = 21;       // floor (44100 / 2093.004522404789) [SR / fmax]
    parameter TROUGH_THRESHOLD = 10000; // should be 0.1;
    parameter DIVIDE_INPUT_W = 24;
endpackage

`endif 