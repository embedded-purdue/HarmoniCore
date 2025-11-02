
`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;
`include "../include/algoc_if.vh"

module cumsum (
    input logic clk, rst,
    output logic [DW - 1:0] total,
    cumsum_if.c cif
);
    logic [DW-1:0] next_total;
    always_ff @(posedge clk) begin : cumsumNext
        if (rst) total <= '0;
        else       total <= next_total;
    end

    always_comb begin : cumsumLogic
        next_total = total + diff_in;
        if (total[17] == diff_in[17] && next_total[17] != total[17]) begin // if both are pos/neg -> overflow case
            if (total[17]) next_total = {1'b0, {17{1'b1}} };
            else           next_total = {1'b1, {17{1'b0}} };
        end
    end

endmodule