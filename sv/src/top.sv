
`timescale 1ns / 1ps
`include "types.sv"

module top
import types::*;
(
    input logic clk,
    input logic nRST,
    input logic [DW-1:0] diff_in,
    output logic [DW-1:0] yin_val
);

    // Cumulative Sum Instantiation
    logic [DW-1:0] total;
    cumsum cumsum_inst(.clk(clk), .nRST(nRST), .diff_in(diff_in), .total(total));

    // Counter Instantiation
    logic [17:0] count;
    logic rollover_flag;
    counter #(.SIZE(18)) counter_inst (.clk(clk), .n_rst(nRST), .clear(1'b0), .count_enable(),
        .rollover_val(MAX_PERIOD), .count_out(count), .rollover_flag(rollover_flag));

    // Div Setup and Divider Instantiation
    logic t_valid
    logic [17:0] quotient;
    div_setup setup_inst(.clk(clk), .nRST(nRST),.total(total), .count(count), .dividend_data(port_a), .divisor_data(port_b),
        .dout_tvalid(t_valid), dout_quotient(quotient));

    // DUAL PORT INSTANTIATION: STILL NEED TO DO
    logic [17:0] port_a; // Still need to work on size from memory
    logic [17:0] port_b; // Still need to work on size from memory

    // Divider Check Setup
    logic [17:0] fp;
    div_check check_inst(.clk(clk), .nRST(nRST), .rollover_flag(rollover_flag), .t_valid(t_valid), .fp(fp));

    // DUAL PORT SETUP: STILL NEED TO DO

endmodule