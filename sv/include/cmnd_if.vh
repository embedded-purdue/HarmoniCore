
`ifndef CMND_IF_VH
`define CMND_IF_VH

`include "../include/types.sv"

interface cmnd_if;
    import types::*;

    // Diff Function Signals
    logic [DW-1:0] diff_in;
    logic diff_valid;

    // Output to Trough Finder
    logic [DW-1:0] yin_out;
    logic yin_valid;

    // Input from Interp
    logic [DW-1:0] interp_dividend, interp_divisor, interp_tau;
    logic interp_valid;

    // Output to PSOLA
    logic [DW-1:0] psola_out;
    logic psola_valid;

    modport cmnd (
        input diff_in, diff_valid, interp_dividend, interp_divisor, interp_tau, interp_valid,
        output yin_out, yin_valid, psola_out, psola_valid
    );

    modport tb (
        input yin_out, yin_valid, psola_out, psola_valid,
        output diff_in, diff_valid, interp_dividend, interp_divisor, interp_tau, interp_valid
    );
endinterface

`endif