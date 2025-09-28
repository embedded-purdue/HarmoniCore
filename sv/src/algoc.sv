
`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;
`include "../include/algoc_if.vh"

module algoc (
    input logic clk, nRST,
    algoc_if.c cif
);

    logic [DW-1:0] total, next_total;
    always_ff @(posedge clk, negedge nRST) begin : cumsumNext
        if (~nRST) total <= '0;
        else       total <= next_total;
    end

    always_comb begin : cumsumLogic
        next_total = total + cif.diff_in;
        if (total[17] == cif.diff_in[17] && next_total[17] != total[17]) begin // if both are pos/neg -> overflow case
            if (total[17]) next_total = {1'b0, {17{1'b1}} };
            else           next_total = {1'b1, {17{1'b0}} };
        end
    end

    logic dividend_valid, divisor_valid;
    logic [DW-1:0] dividend_data, divisor_data;
    always_comb begin : startDividerLogic
        if(count = MIN_VAL - 1) begin
            dividend_valid = 1'b1;
            divisor_valid = 1'b1;
            dividend_data = total;
            divisor_data = count;
        end else begin
            dividend_valid = 1'b0;
            divisor_valid = 1'b0;
            dividend_data = '0;
            divisor_data = '0;
        end
    end




endmodule

