`timescale 1ns / 1ps
`include "..types.sv"

import types::*;
module tb_cumsum ();

    localparam CLK_PERIOD = 10ns;

    logic clk, rst;
    logic [DW - 1:0] diff_in, total;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 0;
        @(negedge clk);
        @(negedge clk);
    end
    endtask

    task new_value;
        input logic [DW - 1:0] new_diff;
        begin
            diff_in = new_diff;
            @(posedge clk);
        end
    endtask

    cumsum DUT (.clk(clk), .nRST(n_rst), .diff_in(diff_in), .total(total));

    initial begin
        n_rst = 0;
        diff_in = '0;
        @(posedge clk);
        reset_dut;

        new_value(DW'h800);
        new_value(DW'h800);
        new_value(DW'h800);
        new_value(DW'h800);
        new_value(DW'hC00);
        new_value(DW'hC00);
        new_value(DW'hC00);
        new_value(DW'hC00);
        
        $finish;
    end
endmodule