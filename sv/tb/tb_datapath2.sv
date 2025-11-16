`timescale 1ns / 10ps
/* verilator coverage_off */
module tb_datapath2();

    localparam CLK_PERIOD = 10ns;

    logic clk, n_rst;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

endmodule