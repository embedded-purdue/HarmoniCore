
`timescale 1ns / 1ps
`include "types.sv"

module cumsum 
import types::*;
(
    input logic clk, nRST,
    input logic [DW-1:0] diff_in,
    output logic [DW-1:0] total
);
    logic [DW-1:0] next_total;
    always_ff @(posedge clk, negedge nRST) begin : cumsumNext
        if (~nRST) total <= '0;
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