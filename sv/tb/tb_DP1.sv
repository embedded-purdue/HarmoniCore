`timescale 1ns / 10ps

`include "types.sv"

module tb_datapath_1
    import types::*;
();
    
    localparam CLK_PERIOD = 10ns;


    // inputs
    logic clk;
    logic rst;
    logic clear;
    logic read_en;
    logic [DW-1:0] data_in;

    // outputs
    logic [$clog2(HOP_LEN)-1:0] count_out;
    logic hop_flag;
    logic [DW-1:0] data_out;

    datapath_1 DUT (.*);

    always begin
        clk = 0;
        #(CLK_PERIOD/2);
        clk = 1;
        #(CLK_PERIOD/2);
    end

    task reset_dut; 
    begin
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        rst = 0;
        @(posedge clk);
    end 
    endtask

    task do_count; 
    begin
        integer i;
        clear = 0;
        read_en = 1;
        data_in = '0;
        
        // Count for more than HOP_LEN to see rollover
        for (i = 2000; i < 2000 + 15; i++) begin
            data_in = i;
            @(posedge clk);
        end
        read_en = 0;
    end 
    endtask

    task do_clear; 
    begin
        clear = 1;
        read_en = 0;
        data_in = '0;
        @(posedge clk);
        @(posedge clk);
        clear = 0;
    end 
    endtask

    // Main test sequence
    initial begin
        clear = 0;
        read_en = 0;
        data_in = '0;
        
        // Reset the DUT
        reset_dut();
        
        do_count();
        
        do_clear();
        
        // Count again after clear
        $display("Test 3: Count after clear");
        read_en = 1;
        repeat (20) @(posedge clk);
        read_en = 0;
        
        repeat (5) @(posedge clk);

        $finish;
    end

    // Display counter behavior
    initial begin
        $display("Time\t clk rst clear read_en count_out hop_flag data_in data_out");
        $monitor("%0t\t %b   %b     %b     %b       %d        %b        %d      %d", 
                 $time, clk, rst, clear, read_en, count_out, hop_flag, data_in, data_out);
    end

endmodule