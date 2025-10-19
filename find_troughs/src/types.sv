`timescale 1ns / 1ps

// This package should be in its own file (types.sv) but is included here for completeness.
// I've also corrected the TROUGH_THRESHOLD to be an integer-based fixed-point value.
package types;
    parameter DW = 18;
    parameter FFT_DW = DW;
    parameter MAX_VAL = (1 <<< (FFT_DW-1)) - 1;
    parameter MIN_VAL = -(1 <<< (FFT_DW-1));
    parameter DECIMALBITS = 11; // Number of fractional bits in DW
    parameter SEMITONES_IN_OCTAVE = 12;
    parameter DR = 44100;
    parameter FRAME_LEN = 2048;
    parameter HOP_LEN = FRAME_LEN / 4;
    parameter WIN_LEN = FRAME_LEN / 2;

    // Original real number threshold
    parameter real TROUGH_THRESHOLD_REAL = 0.1; 
    // Scaled fixed-point threshold for hardware comparison
    parameter TROUGH_THRESHOLD = integer'(TROUGH_THRESHOLD_REAL * (1 << DECIMALBITS)); 

    parameter FMIN = 65.41; //C2
    parameter FMAX = 2093; //C7
    // Calculated as an integer
    parameter MIN_PERIOD = DR / FMAX; 
endpackage
