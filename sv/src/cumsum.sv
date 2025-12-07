
`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;

module cumsum (
    input logic clk, rst,
    input logic [DW-1:0] diff_in,
    output logic [DW-1:0] total
);
    logic [DW-1:0] next_total;
    always_ff @(posedge clk) begin : cumsumNext
        if (rst) total <= '0;
        else     total <= next_total;
    end

    always_comb begin : cumsumLogic
        next_total = total + diff_in;
        if (total[DW-1] == diff_in[DW-1] && next_total[DW-1] != total[DW-1]) begin // if both are pos/neg -> overflow case
            if (total[DW-1]) next_total = {1'b1, {{DW-1}{1'b0}} }; // orig was negative, set to max negative
            else             next_total = {1'b0, {{DW-1}{1'b1}} }; // orig was positive, set to max positive
        end
    end

endmodule
