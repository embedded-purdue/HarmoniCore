`timescale 1ns / 1ps

`include "../include/top_if.vh"
`include "../include/types.sv"
import types::*;

parameter PERIOD = 10;

module top_tb();
    logic clk = 0;
    always #(PERIOD/2) clk++;
    logic rst;

    top_if topif(); 

    top DUT(.clk(clk), .rst(rst), .topif(topif));

    initial begin

        $finish;
    end
endmodule