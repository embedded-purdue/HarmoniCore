
`timescale 1ns / 1ps
`include "../include/types.sv"

module shiftwrapper 
import types::*;
(
    input logic clk, rst,
    input logic [DW-1:0] diff_in,
    output logic [DW-1:0] shifted_diff
);
    shift_reg your_instance_name (
        .D(diff_in),        // input wire [17:0] D
        .CLK(clk),          // input wire CLK
        .SCLR(rst),         // input wire SCLR
        .Q(shifted_diff)    // output wire [17:0] Q
    );

endmodule