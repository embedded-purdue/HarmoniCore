`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;

module div_setup (
    input logic clk,
    input logic nRST,
    input logic [17:0] total,
    input logic [17:0] count,
    input logic [DW - 1:0] dividend_data,
    input logic [DW - 1:0] divisor_data,
    output logic dout_tvalid,
    output logic [17:0] dout_quotient
);
    
    logic dividend_valid, divisor_valid;

    always_comb begin : startDividerLogic
        if(count == MIN_VAL - 1) begin
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

    // INSTATIATE THE DIVIDER HERE: STILL NEED TO DO
    


endmodule