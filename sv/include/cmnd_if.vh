
`ifndef CMND_IF_VH
`define CMND_IF_VH

`include "../include/types.sv"

interface cmnd_if;
    import types::*;

    logic [DW-1:0] diff_in, yin_val;
    logic diff_valid;

    modport cmnd (
        input diff_in, diff_valid,
        output yin_val
    );

    modport tb (
        input yin_val,
        output diff_in, diff_valid
    );
endinterface

`endif