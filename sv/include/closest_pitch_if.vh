`include "types.sv"
import types::*;

interface closest_pitch_if;

    logic signed [DW - 1:0] freq_in;
    logic [BLOCK_SCALE - 1:0] scale;
    logic [SEMITONES_IN_OCTAVE - 1:0] active_tones;
    logic [PITCH_ADRESS_BITS - 1:0] pitch_addr;
    logic start, done;

    modport cp (
        input freq_in, scale, active_tones, start,
        output pitch_addr, done
    );
endinterface
