`include "types.sv"

import types::*;

interface FPMultiply_if;

    logic signed [DW - 1: 0] a, b, c;

    modport mult (
        input a, b,
        output c
    );
endinterface
