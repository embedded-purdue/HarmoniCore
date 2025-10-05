`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;
`include "../include/algoc_if.vh"

module top (
    input logic clk,
    input logic nRST,
    cumsum_if.c cif
);

    // Cumulative Sum Instantiation
    cumsum_if cif();
    logic [DW - 1:0] total;
    cumsum cumsum_inst(.clk(clk), ,.nRST(nRST), .cif(cumsum_if),.total(total));

    // Counter Instantiation
    logic [17:0] count;
    logic rollover_flag;
    counter #(.SIZE(18)) counter_inst (.clk(clk), .n_rst(nRST), .clear(1'b0), .count_enable(cif.count_enable),
        .rollover_val(MAX_PERIOD), .count_out(count), .rollover_flag(rollover_flag));

    // DUAL PORT INSTANTIATION: STILL NEED TO DO
    logic [17:0] port_a; // Still need to work on size from memory
    logic [17:0] port_b; // Still need to work on size from memory

    // Div Setup and Divider Instantiation
    logic t_valid
    logic [17:0] quotient;
    div_setup setup_inst(.clk(clk), .nRST(nRST),.total(total), .count(count), .dividend_data(port_a), .divisor_data(port_b),
        .dout_tvalid(t_valid), dout_quotient(quotient));

    // Divider Check Setup
    logic [17:0] fp;
    div_check check_inst(.clk(clk), .nRST(nRST), .rollover_flag(rollover_flag), .t_valid(t_valid), .fp(fp));

    // DUAL PORT SETUP: STILL NEED TO DO

endmodule