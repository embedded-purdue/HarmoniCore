
`timescale 1ns / 1ps
`include "../include/types.sv"

module shifter 
import types::*;
(
    input logic clk,
    input logic [DW-1:0] diff_in,
    output logic [DW-1:0] shifted_diff
);
    shift_reg shift_instChil (
        .D(diff_in),        // input wire [17 : 0] D
        .CLK(clk),          // input wire CLK
        .Q(shifted_diff)    // output wire [17 : 0] Q
    );

endmodule