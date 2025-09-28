
`timescale 1ns/1ps

`ifndef ALGOC_IF
`define ALGOC_IF

`include "../include/types.sv"
import types::*;

interface algoc_if;

    logic count_enable;
    logic [DW-1:0] diff_in;


    modport c (
        input diff_in, count_enable;
        output temp2
    );
    
endinterface

`endif