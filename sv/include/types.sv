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
    parameter TROUGH_THRESHOLD = 0.1;
    parameter FMIN = 65.41; //C2
    parameter FMAX = 2093; //C7
    parameter PITCH_ADRESS_BITS = 6;
    parameter BLOCK_SCALE = 8;
    parameter START_OCTAVE = 2;
    parameter END_OCTAVE = 6;

endpackage

`endif 