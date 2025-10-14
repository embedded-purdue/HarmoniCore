
`timescale 1ns / 1ps
`include "types.sv"

module div_setup
import types::*;
(
    input logic clk,
    input logic nRST,
    input logic [DW-1:0] total,
    input logic [DW-1:0] count,
    output logic [17:0] dout
);
    logic [DW-1:0] dividend_data, divisor_data, result_data;
    logic dividend_valid, divisor_valid, result_valid;

    always_ff @(posedge clk, negedge nRST) begin : cummeanDiv
        if(~nRST) begin
            dividend_valid <= 1'b0;
            divisor_valid <= 1'b0;
            dividend_data <= '0;
            divisor_data <= '0;
        end
        else if (count >= MIN_VAL - 1) begin
            dividend_valid = 1'b1;
            divisor_valid = 1'b1;
            dividend_data = total;
            divisor_data = count;
        end

    end

    // 22 cycle latency
    div div_cummean (
        .aclk(aclk),
        .s_axis_dividend_tvalid(dividend_valid),
        .s_axis_dividend_tdata(dividend_data),
        .s_axis_divisor_tvalid(divisor_valid),
        .s_axis_divisor_tdata(divisor_data),

        .m_axis_dout_tvalid(result_valid),
        .m_axis_dout_tdata(result_data)
    );

    always_ff @(posedge clk, negedge nRST) begin : cummeanOut
        if (~nRST)             dout <= '0;
        else if (result_valid) dout <= result_data;
    end

endmodule