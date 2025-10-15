
`timescale 1ns / 10ps
`include "../include/types.sv"
import types::*;

module shift_reg #(
    parameter LATENCY = 23
) (
    input logic clk,
    input logic nRST,
    input logic shift_en,
    input logic [DW-1:0] serial_in,
    output logic [DW-1:0] serial_out
);
    logic [DW-1:0] shift [0:LATENCY-1];

    always_ff @(posedge clk, negedge nRST) begin : shiftLogic
        if (~nRST)         shift <= '{default: '0};
        else if (shift_en) shift <= {shift[LATENCY-1:1], serial_in};
    end

    assign serial_out = shift[LATENCY-1];

endmodule